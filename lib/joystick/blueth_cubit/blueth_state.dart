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

  const BluethState({
    this.isBlueth = false,
    this.conecction,
    this.messageReceived = '',
    required this.status,
  });

  @override
  List<Object?> get props => [
        isBlueth,
        messageReceived,
        conecction,
        status,
      ];

  BluethState copyWith({
    bool? isBlueth,
    String? messageReceived,
    BluetoothConnection? conecction,
    BluethStatus? status,
  }) =>
      BluethState(
        conecction: conecction ?? this.conecction,
        messageReceived: messageReceived ?? this.messageReceived,
        isBlueth: isBlueth ?? this.isBlueth,
        status: status ?? this.status,
      );
}
