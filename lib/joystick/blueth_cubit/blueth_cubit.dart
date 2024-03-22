import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'blueth_state.dart';

class BluethCubit extends Cubit<BluethState> {
  BluethCubit() : super(const BluethState(status: BluethStatus.init));
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
      emit(state.copyWith(status: BluethStatus.stateChangeListener));
    });
  }

  void initBluetooth() {
    getBTState();
    stateChangeListener();
    listBondeDevices();
  }

  void onDataReceived(Uint8List data) {}
  void sendMessage(String text) {}
  void getBTState() {
    FlutterBluetoothSerial.instance.state.then((value) {
      _bluetoothState = value;
      if (_bluetoothState.isEnabled) {
        listBondeDevices();
      }
      emit(state.copyWith(status: BluethStatus.getBTState));
    });
  }

  void listBondeDevices() {
    FlutterBluetoothSerial.instance.getBondedDevices().then((value) {
      devices = value;
      emit(state.copyWith(status: BluethStatus.listBondeDevices));
    });
  }

  Future<void> switchBluetooth(bool accepted) async {
    if (accepted) {
      await FlutterBluetoothSerial.instance.requestEnable();
    } else {
      await FlutterBluetoothSerial.instance.requestDisable();
    }
    emit(state.copyWith(isBlueth: accepted));
  }

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
}
