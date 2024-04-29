import 'package:equatable/equatable.dart';

enum PlayerStatus {
  init,
  loding,
  loaded,
  initPoints,
  startAnimation,
}

class PlayerState extends Equatable {
  final PlayerStatus status;
  final double setAnimations;

  const PlayerState({
    required this.status,
    this.setAnimations = 0,
  });

  @override
  List<Object?> get props => [
        status,
        setAnimations,
      ];

  PlayerState copyWith({
    PlayerStatus? status,
    double? setAnimations,
  }) =>
      PlayerState(
        status: status ?? this.status,
        setAnimations: setAnimations ?? this.setAnimations,
      );
}
