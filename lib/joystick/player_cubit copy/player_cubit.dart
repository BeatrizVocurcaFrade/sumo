import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sumo/constants.dart';
import 'package:sumo/joystick/entities/point_entity.dart';
import 'package:sumo/joystick/player_cubit/player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit({this.maxTimeVideo = 0})
      : super(const PlayerState(status: PlayerStatus.init));
  final int maxTimeVideo;
  PointEntity pointA = PointEntity(x: 0, y: 0);
  PointEntity pointB = PointEntity(x: 0, y: 0);
  PointEntity initialPoint = PointEntity(x: 0, y: 0);
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  List<BluetoothDevice> devices = [];

  void stateChangeListener() {
    FlutterBluetoothSerial.instance.onStateChanged().listen((value) {
      _bluetoothState = value;
      if (kDebugMode) {
        print('--State is Enabled: ${value.isEnabled}');
      }
      if (_bluetoothState.isEnabled) {
        listBondeDevices();
      } else {
        devices.clear();
      }
      emit(state.copyWith(status: PlayerStatus.stateChangeListener));
    });
  }

  initBluetooth() {
    getBTState();
    stateChangeListener();
    listBondeDevices();
  }

  void getBTState() {
    FlutterBluetoothSerial.instance.state.then((value) {
      _bluetoothState = value;
      if (_bluetoothState.isEnabled) {
        listBondeDevices();
      }
      emit(state.copyWith(status: PlayerStatus.getBTState));
    });
  }

  void listBondeDevices() {
    FlutterBluetoothSerial.instance.getBondedDevices().then((value) {
      devices = value;
      emit(state.copyWith(status: PlayerStatus.listBondeDevices));
    });
  }

  Future<void> switchBluetooth(bool accepted) async {
    if (accepted) {
      await FlutterBluetoothSerial.instance.requestEnable();
    } else {
      await FlutterBluetoothSerial.instance.requestDisable();
    }
    emit(state.copyWith(isBluetooth: accepted));
  }

  // bool isInCicle(PointEntity point) =>
  //     pow(point.x - initialPoint.x, 2) + pow(point.y - initialPoint.y, 2) <
  //     pow(SUMO_SIZE / 2, 2);
  Future<bool> getPermission(Permission permission) async {
    var status = await permission.request();
    return (!status.isDenied && !status.isPermanentlyDenied);
  }

  Future<bool> askPermission() async {
    var bluetoothAdvertise = await getPermission(Permission.bluetoothAdvertise);
    var bluetoothConnect = await getPermission(Permission.bluetoothConnect);
    var bluetoothScan = await getPermission(Permission.bluetoothScan);
    return bluetoothAdvertise && bluetoothConnect && bluetoothScan;
  }

  void initPoints(double width, double height) {
    pointA = PointEntity(
      x: width / 4 - BALL_SIZE / 2, //horizontal
      y: height / 2.7 - BALL_SIZE / 2,
    );
    initialPoint.x = pointA.x - (SUMO_SIZE / 2) + (BALL_SIZE / 2);
    initialPoint.y = pointA.y - (SUMO_SIZE / 2) + (BALL_SIZE / 2);
    pointB = pointA;
    pointA = PointEntity(
      x: pointA.x,
      y: pointA.y + 30,
    );
    pointB = PointEntity(
      x: pointB.x,
      y: pointB.y - 30,
    );
    emit(state.copyWith(status: PlayerStatus.initPoints));
  }
}
