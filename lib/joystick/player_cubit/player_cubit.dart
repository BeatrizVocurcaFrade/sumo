import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumo/constants.dart';
import 'package:sumo/joystick/entities/point_entity.dart';
import 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit() : super(const PlayerState(status: PlayerStatus.init));
  PointEntity pointA = PointEntity(x: 0, y: 0);
  PointEntity pointB = PointEntity(x: 0, y: 0);
  PointEntity sumoPoint = PointEntity(x: 0, y: 0);
  PointEntity realSumoCenterPoint() => PointEntity(
      x: sumoPoint.x + SUMO_DARK_SIZE / 2, y: sumoPoint.y + SUMO_DARK_SIZE / 2);
  PointEntity realBallCenterPoint(PointEntity point) =>
      PointEntity(x: point.x + BALL_SIZE / 2, y: point.y + BALL_SIZE / 2);
  void initPoints(double width, double height) {
    pointA = PointEntity(
      x: width / SUMO_RING_POSITION_X - BALL_SIZE / 2, //horizontal
      y: height / SUMO_RING_POSITION_Y - BALL_SIZE / 2,
    );
    sumoPoint.x = pointA.x - (SUMO_DARK_SIZE / 2) + (BALL_SIZE / 2);
    sumoPoint.y = pointA.y - (SUMO_DARK_SIZE / 2) + (BALL_SIZE / 2);
    pointB = pointA;
    pointA = PointEntity(
      x: pointA.x,
      y: pointA.y + DIST_PLAYER_CENTER,
    );
    pointB = PointEntity(
      x: pointB.x,
      y: pointB.y - DIST_PLAYER_CENTER,
    );
    emit(state.copyWith(status: PlayerStatus.initPoints));
  }
}
