import 'dart:math';

import 'package:sumo/constants.dart';
import 'package:sumo/joystick/entities/point_entity.dart';

class TriangleEntity {
  PointEntity? a;
  PointEntity? b;
  PointEntity? c;
  PointEntity? center;
  double xComp;
  double yComp;

  TriangleEntity({
    required this.center,
    this.xComp = 0,
    this.yComp = 0,
    this.a,
    this.b,
    this.c,
  }) {
    double alpha = (pi / 6);

    a = PointEntity(x: center!.x, y: center!.y - BALL_SIZE / 2);
    b = PointEntity(
        x: center!.x - (cos(alpha) * (BALL_SIZE / 2)),
        y: center!.y + (sin(alpha) * (BALL_SIZE / 2)));
    c = PointEntity(
        x: center!.x + (cos(alpha) * (BALL_SIZE / 2)),
        y: center!.y + (sin(alpha) * (BALL_SIZE / 2)));
  }

  PointEntity rotate(PointEntity? p, bool isLeft) {
    var xCe = (p!.x - center!.x);
    var yCe = (p.y - center!.y);
    var angle = isLeft ? -ANGULAR_STEP : ANGULAR_STEP;
    return PointEntity(
      x: center!.x + xCe * cos(angle) - yCe * sin(angle),
      y: center!.y + xCe * sin(angle) + yCe * cos(angle),
    );
  }

  void rotateTriangle(bool isLeft) {
    a = rotate(a, isLeft);
    b = rotate(b, isLeft);
    c = rotate(c, isLeft);
  }

  PointEntity increasePoint(PointEntity p, double x, double y) =>
      PointEntity(x: p.x + x, y: p.y + y);
  void moveTriangle(PointEntity futurePoint, PointEntity lastPoint) {
    var x = futurePoint.x - lastPoint.x;
    var y = futurePoint.y - lastPoint.y;
    a = increasePoint(a!, x, y);
    b = increasePoint(b!, x, y);
    c = increasePoint(c!, x, y);
    center = increasePoint(center!, x, y);
  }
}
