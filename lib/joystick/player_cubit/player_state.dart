import 'package:equatable/equatable.dart';

enum PlayerStatus {
  init,
  bluetooth,
  stateChangeListener,
  initPoints,
  getBTState,
  listBondeDevices,
}

class PlayerState extends Equatable {
  final bool isBluetooth;
  final PlayerStatus status;

  const PlayerState({
    this.isBluetooth = false,
    required this.status,
  });

  @override
  List<Object?> get props => [
        isBluetooth,
        status,
      ];

  PlayerState copyWith({
    bool? isBluetooth,
    PlayerStatus? status,
  }) =>
      PlayerState(
        isBluetooth: isBluetooth ?? this.isBluetooth,
        status: status ?? this.status,
      );
}
