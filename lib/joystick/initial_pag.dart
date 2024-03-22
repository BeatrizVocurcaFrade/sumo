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

  // bool isInCicle(PointEntity point) =>
  //     pow(point.x - initialPoint.x, 2) + pow(point.y - initialPoint.y, 2) <
  //     pow(SUMO_SIZE / 2, 2);
  @override
  void didChangeDependencies() {
    playerCubit.initPoints(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    super.didChangeDependencies();
  }

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
                    replacement: const CircularProgressIndicator(),
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
                    // PointEntity futurePoint = PointEntity(
                    //   x: pointA.x + STEP * details.x,
                    //   y: pointA.y + STEP * details.y,
                    // );

                    // if (isInCicle(futurePoint)) return;

                    playerCubit.pointA = PointEntity(
                      x: playerCubit.pointA.x + STEP * details.x,
                      y: playerCubit.pointA.y + STEP * details.y,
                    );
                    setState(() {});
                  },
                  child: Stack(
                    children: [
                      SumoRing(
                        playerCubit.initialPoint,
                      ),
                      Ball(
                        point: playerCubit.pointB,
                        color: Colors.green,
                      ),
                      Ball(
                        point: playerCubit.pointA,
                      ),
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
