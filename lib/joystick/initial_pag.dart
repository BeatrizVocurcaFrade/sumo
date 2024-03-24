import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:sumo/constants.dart';
import 'package:sumo/joystick/blueth_cubit/blueth_cubit.dart';
import 'package:sumo/joystick/blueth_cubit/blueth_state.dart';
import 'package:sumo/joystick/components/drawer_item.dart';
import 'package:sumo/joystick/entities/point_entity.dart';
import 'package:sumo/joystick/player_cubit/player_cubit.dart';
import 'package:sumo/joystick/player_cubit/player_state.dart';
import 'package:sumo/joystick/widgets/ball.dart';
import 'package:sumo/joystick/widgets/sumo_ring.dart';

class JoystickAreaExample extends StatefulWidget {
  const JoystickAreaExample({super.key});

  @override
  State<JoystickAreaExample> createState() => _JoystickAreaExampleState();
}

class _JoystickAreaExampleState extends State<JoystickAreaExample>
    with WidgetsBindingObserver {
  PlayerCubit playerCubit = PlayerCubit();
  BluethCubit bluethCubit = BluethCubit();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      playerCubit.initPoints(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height);
      bluethCubit.initBluetooth();
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.index == 0) {
      if (bluethCubit.bluetoothState.isEnabled) {
        bluethCubit.listBondeDevices();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    bluethCubit.timer!.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool isInCicle(PointEntity point) {
    return distPointAndCircle(playerCubit.realBallCenterPoint(point),
                playerCubit.realSumoCenterPoint()) -
            BALL_SIZE / 2 >
        0;
  }

  double distPointAndCircle(PointEntity point, PointEntity circlePoint) =>
      (SUMO_DARK_SIZE / 2 - distBeetweenPoint(point, circlePoint));

  @override
  void didChangeDependencies() {
    playerCubit.initPoints(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    super.didChangeDependencies();
  }

  double distBeetweenPoint(PointEntity a, PointEntity b) =>
      sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));
  // a() {
  //   List<MiniPoint> balss = [];

  //   for (var i = 0; i < 2000; i++) {
  //     double intValue_x = Random().nextInt(300) + 30;
  //     double intValue_y = Random().nextInt(500) + 5;
  //     var point = PointEntity(x: intValue_x, y: intValue_y);
  //     if (isInCicle(point)) {
  //       balss.add(MiniPoint(point: point, color: Colors.pink));
  //     } else {
  //       balss.add(MiniPoint(point: point, color: Colors.orange));
  //     }
  //   }
  //   return balss;
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BluethCubit, BluethState>(
      bloc: bluethCubit,
      builder: (context, stateBlu) {
        return BlocBuilder<PlayerCubit, PlayerState>(
          bloc: playerCubit,
          builder: (context, state) {
            return Scaffold(
              drawer: Drawer(
                child: Column(
                  children: [
                    const DrawerHeader(
                      child: Text("Aparelhos via Bluetooth"),
                    ),
                    ...bluethCubit.devices.map((device) => DrawerItem(
                          icon: Icons.cell_tower,
                          isConnected: device.isConnected,
                          title: stateBlu.status == BluethStatus.connecting
                              ? "..."
                              : device.name.toString(),
                          onTap: () {
                            if (stateBlu.status != BluethStatus.connecting) {
                              bluethCubit.getBTConnection(device);
                            }
                          },
                        ))
                  ],
                ),
              ),
              appBar: AppBar(
                title: const Text('Luta de Sumô'),
                actions: [
                  const Text(
                    'Bluetooth',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Visibility(
                    visible: stateBlu.status != BluethStatus.loading,
                    replacement: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator()),
                    ),
                    child: Switch(
                        value: stateBlu.isBlueth,
                        onChanged: (val) async {
                          if (!await bluethCubit.askPermission()) {
                            return showMessage(
                                'Aceite a permissão de bluetooth nas configurações primeiro!');
                          }

                          bluethCubit.switchBluetooth(val);
                        }),
                  ),
                ],
              ),
              body: SafeArea(
                child: JoystickArea(
                  mode: JoystickMode.all,
                  initialJoystickAlignment: const Alignment(0.9, -0.1),
                  listener: (details) {
                    PointEntity futurePoint = PointEntity(
                      x: playerCubit.pointA.x + STEP * details.x,
                      y: playerCubit.pointA.y + STEP * details.y,
                    );

                    if (!isInCicle(futurePoint)) return;

                    playerCubit.pointA = PointEntity(
                      x: playerCubit.pointA.x + STEP * details.x,
                      y: playerCubit.pointA.y + STEP * details.y,
                    );
                    setState(() {});
                  },
                  child: Stack(
                    children: [
                      SumoRing(
                        playerCubit.sumoPoint,
                      ),
                      Ball(
                        point: playerCubit.pointB,
                        color: Colors.green,
                      ),
                      Ball(
                        point: playerCubit.pointA,
                      ),
                      // ...a()
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
