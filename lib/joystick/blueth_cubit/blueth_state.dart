import 'package:equatable/equatable.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

enum BluethStatus {
  init,
  loading,
  generericLoading,
  connecting,
  stoppedConnecting,
  loaded,
  blueth,
  stateChangeListener,
  initPoints,
  getBTState,
  listBondeDevices,
}

class BluethState extends Equatable {
  final bool isBlueth;
  final BluethStatus status;
  final String messageReceived;
  final BluetoothConnection? conecction;
  final BluetoothDevice? selectedDevice;

  const BluethState({
    this.isBlueth = false,
    this.conecction,
    this.selectedDevice,
    this.messageReceived = '',
    required this.status,
  });

  @override
  List<Object?> get props => [
        isBlueth,
        selectedDevice,
        messageReceived,
        conecction,
        status,
      ];

  BluethState copyWith({
    bool? isBlueth,
    BluetoothDevice? selectedDevice,
    String? messageReceived,
    BluetoothConnection? conecction,
    BluethStatus? status,
  }) =>
      BluethState(
        selectedDevice: selectedDevice ?? this.selectedDevice,
        conecction: conecction ?? this.conecction,
        messageReceived: messageReceived ?? this.messageReceived,
        isBlueth: isBlueth ?? this.isBlueth,
        status: status ?? this.status,
      );
}
