import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumo/constants.dart';
import 'package:sumo/joystick/entities/point_entity.dart';
import 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit() : super(const PlayerState(status: PlayerStatus.init));
  PointEntity pointA = PointEntity(x: 0, y: 0);
  PointEntity pointB = PointEntity(x: 0, y: 0);
  PointEntity initialPoint = PointEntity(x: 0, y: 0);

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
