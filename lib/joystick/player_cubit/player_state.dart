import 'package:equatable/equatable.dart';

enum PlayerStatus {
  init,
  initPoints,
}

class PlayerState extends Equatable {
  final PlayerStatus status;

  const PlayerState({
    required this.status,
  });

  @override
  List<Object?> get props => [
        status,
      ];

  PlayerState copyWith({
    PlayerStatus? status,
  }) =>
      PlayerState(
        status: status ?? this.status,
      );
}
