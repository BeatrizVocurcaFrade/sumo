import 'package:equatable/equatable.dart';

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

  const BluethState({
    this.isBlueth = false,
    required this.status,
  });

  @override
  List<Object?> get props => [
        isBlueth,
        status,
      ];

  BluethState copyWith({
    bool? isBlueth,
    BluethStatus? status,
  }) =>
      BluethState(
        isBlueth: isBlueth ?? this.isBlueth,
        status: status ?? this.status,
      );
}
