import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'blueth_state.dart';

class BluethCubit extends Cubit<BluethState> {
  BluethCubit() : super(const BluethState(status: BluethStatus.init));
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  List<BluetoothDevice> devices = [];
  List<List<int>> chunks = [];
  int contentLength = 0;
  BluetoothConnection? connection;

  // Uint8List _bytes = Uint8List(0);
  // RestartableTimer? timer;
  // void stateChangeListener() {
  //   FlutterBluetoothSerial.instance.onStateChanged().listen((value) {
  //     bluetoothState = value;
  //     if (kDebugMode) {
  //       print('--State is Enabled: ${value.isEnabled}');
  //     }
  //     if (bluetoothState.isEnabled) {
  //       listBondeDevices();
  //     } else {
  //       devices.clear();
  //     }
  //     emit(state.copyWith(status: BluethStatus.stateChangeListener));
  //   });
  // }

  // void _drawImage() {
  //   emit(state.copyWith(status: BluethStatus.generericLoading));
  //   if (chunks.isEmpty || contentLength == 0) return;
  //   _bytes = Uint8List(contentLength);
  //   int offSet = 0;
  //   for (var chunk in chunks) {
  //     _bytes.setRange(offSet, offSet * chunk.length, chunk);
  //     offSet += chunk.length;
  //   }
  //   emit(state.copyWith(status: BluethStatus.loaded));
  //   contentLength = 0;
  //   chunks.clear();
  // }

  void initBluetooth() {
    // getBTState();
    // stateChangeListener();
    // listBondeDevices();
    connectToDevice();

    readData();
    // timer = RestartableTimer(const Duration(seconds: 1), _drawImage);
  }

  // Future<void> sendMessage(String text) async {
  //   if (state.conecction == null) {
  //     await connectToDevice();
  //   }
  //   if (text.isEmpty) return;
  //   var value = text.trim();
  //   try {
  //     state.conecction!.output.add(utf8.encode(value));
  //     await state.conecction!.output.allSent;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e.toString());
  //     }
  //   }
  // }

  // Future<void> connectToDevice() async {
  //   List<BluetoothDevice> devices = [];

  //   // Lista dispositivos emparelhados
  //   devices = await FlutterBluetoothSerial.instance.getBondedDevices();

  //   // Escolhe dispositivo HC-06
  //   BluetoothDevice hc06 =
  //       devices.firstWhere((device) => device.name == "HC-06");

  //   // Tenta conectar ao dispositivo
  //   try {
  //     connection = await BluetoothConnection.toAddress(hc06.address);
  //     print('Conexão estabelecida com sucesso.');
  //   } catch (error) {
  //     print('Erro ao conectar: $error');
  //   }
  // }

  // Future<BluetoothConnection?> connectToDevice() async {
  //   String address = "98:D3:71:FD:30:21";
  //   emit(state.copyWith(status: BluethStatus.connecting));
  //   BluetoothConnection connection;
  //   try {
  //     connection = await BluetoothConnection.toAddress(address);
  //     print('Conexão estabelecida com sucesso.');
  //     emit(state.copyWith(
  //         status: BluethStatus.stoppedConnecting, conecction: connection));
  //     return connection;
  //   } catch (error) {
  //     print('Erro ao conectar: $error');
  //     return null;
  //   }
  // }

  // Future<BluetoothConnection?> getBTConnection(BluetoothDevice? deviceP) async {
  //   if (deviceP == null && state.selectedDevice == null) return null;
  //   BluetoothDevice device;
  //   if (deviceP == null) {
  //     device = state.selectedDevice!;
  //   } else {
  //     device = deviceP;
  //   }

  //   emit(state.copyWith(
  //       status: BluethStatus.connecting, selectedDevice: deviceP));
  //   BluetoothConnection connection =
  //       await BluetoothConnection.toAddress(device.address);
  //   // connection.input!.listen(_onDataReceived).onDone(() {
  //   //   emit(state.copyWith(status: BluethStatus.stoppedConnecting));
  //   // });
  //   emit(state.copyWith(
  //       status: BluethStatus.stoppedConnecting, conecction: connection));
  //   return connection;
  // }

  // void _onDataReceived(Uint8List data) {
  //   if (data.isNotEmpty) {
  //     chunks.add(data);
  //     contentLength += data.length;
  //     timer!.reset();
  //   }
  //   if (kDebugMode) {
  //     print("Data Length: $contentLength, chunks: ${chunks.length}");
  //   }
  // }

  Future<void> readData() async {
    if (state.conecction == null) {
      await connectToDevice();
    }
    state.conecction!.input!.listen((Uint8List data) {
      String message = String.fromCharCodes(data);
      if (kDebugMode) {
        print('Dados recebidos: $message');
        emit(state.copyWith(messageReceived: message));
      }
    }).onDone(() {
      if (kDebugMode) {
        print('Conexão Bluetooth encerrada.');
      }
    });
  }

  // void getBTState() {
  //   FlutterBluetoothSerial.instance.state.then((value) {
  //     bluetoothState = value;
  //     if (bluetoothState.isEnabled) {
  //       listBondeDevices();
  //     }
  //     emit(state.copyWith(status: BluethStatus.getBTState));
  //   });
  // }

  // void listBondeDevices() {
  //   FlutterBluetoothSerial.instance.getBondedDevices().then((value) {
  //     devices = value;
  //     emit(state.copyWith(status: BluethStatus.listBondeDevices));
  //   });
  // }

  Future<void> connectToDevice() async {
    // Lista dispositivos emparelhados
    devices = await FlutterBluetoothSerial.instance.getBondedDevices();

    // Escolhe dispositivo HC-06
    BluetoothDevice hc06 =
        devices.firstWhere((device) => device.name == "HC-06");

    // Tenta conectar ao dispositivo
    try {
      connection = await BluetoothConnection.toAddress(hc06.address);
      if (kDebugMode) {
        print('Conexão estabelecida com sucesso.');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Erro ao conectar: $error');
      }
    }
  }

  void sendData(String data) {
    if (connection == null) return;
    connection!.output.add(Uint8List.fromList(data.codeUnits));
    connection!.output.allSent.then((_) {
      if (kDebugMode) {
        print('Dados enviados com sucesso: $data');
      }
    });
  }

  Future<void> switchBluetooth(bool accepted) async {
    emit(state.copyWith(status: BluethStatus.loading));
    if (accepted) {
      await FlutterBluetoothSerial.instance.requestEnable();
      connectToDevice();
    } else {
      await FlutterBluetoothSerial.instance.requestDisable();
    }
    emit(state.copyWith(isBlueth: accepted, status: BluethStatus.loaded));
  }

  Future<bool> getPermission(Permission permission) async {
    var status = await permission.request();
    return (!status.isDenied && !status.isPermanentlyDenied);
  }

  Future<bool> askPermission() async {
    emit(state.copyWith(status: BluethStatus.loading));
    var bluetoothAdvertise = await getPermission(Permission.bluetoothAdvertise);
    var bluetoothConnect = await getPermission(Permission.bluetoothConnect);
    var bluetoothScan = await getPermission(Permission.bluetoothScan);
    emit(state.copyWith(status: BluethStatus.loaded));
    return bluetoothAdvertise && bluetoothConnect && bluetoothScan;
  }
}
