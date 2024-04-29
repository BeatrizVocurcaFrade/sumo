import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumo/constants.dart';
import 'package:sumo/joystick/entities/point_entity.dart';
import 'package:sumo/joystick/entities/triangle_entity.dart';
import 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit() : super(const PlayerState(status: PlayerStatus.init));
  PointEntity pointA = PointEntity(x: 0, y: 0);
  PointEntity pointB = PointEntity(x: 0, y: 0);
  PointEntity sumoPoint = PointEntity(x: 0, y: 0);
  final Duration duration = const Duration(milliseconds: 1000);
  TriangleEntity? triangle;
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
    triangle = TriangleEntity(center: realBallCenterPoint(pointA));

    emit(state.copyWith(status: PlayerStatus.initPoints));
  }

  void treatRotation(PointEntity futurePoint, PointEntity lastPoint) {
    emit(state.copyWith(status: PlayerStatus.loding));
    var future = futurePoint.y.round();
    var last = lastPoint.y.round();
    if ((future - last).abs() < 5) {
      triangle!.rotateTriangle(futurePoint.x > lastPoint.x);
    }
    triangle!.moveTriangle(futurePoint, lastPoint);
    emit(state.copyWith(status: PlayerStatus.loaded));
  }

  double distBeetweenPoint(PointEntity a, PointEntity b) =>
      sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));

  double distPointAndCircle(PointEntity point, PointEntity circlePoint) =>
      (SUMO_DARK_SIZE / 2 - distBeetweenPoint(point, circlePoint));

  Future<void> showAnimation() async {
    emit(state.copyWith(status: PlayerStatus.startAnimation, setAnimations: 1));
    await Future.delayed(duration * 2);
  }

  bool isInCicle(PointEntity point) {
    return distPointAndCircle(
                realBallCenterPoint(point), realSumoCenterPoint()) -
            BALL_SIZE / 2 >
        0;
  }
}
