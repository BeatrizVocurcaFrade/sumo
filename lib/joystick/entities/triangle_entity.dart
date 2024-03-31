import 'dart:math';

import 'package:sumo/constants.dart';
import 'package:sumo/joystick/entities/point_entity.dart';

class TriangleEntity {
  PointEntity? a;
  PointEntity? b;
  PointEntity? c;
  PointEntity? center;
  double angle;
  double xComp;
  double yComp;

  TriangleEntity({
    required this.center,
    this.xComp = 0,
    this.yComp = 0,
    this.angle = 0,
    this.a,
    this.b,
    this.c,
  }) {
    // init internal angle

    double alpha = (pi / 3);

    // init components
    angle = pi / 5;
    xComp = cos(angle);
    yComp = sin(angle);

    // init points triangle
    a = PointEntity(x: center!.x, y: center!.y - BALL_SIZE / 2);
    b = PointEntity(
        x: center!.x - (cos(alpha / 3) * (BALL_SIZE / 2)),
        y: center!.y + (sin(alpha / 3) * (BALL_SIZE / 2)));
    c = PointEntity(
        x: center!.x + (cos(alpha / 3) * (BALL_SIZE / 2)),
        y: center!.y + (sin(alpha / 3) * (BALL_SIZE / 2)));
  }

  PointEntity rotate({required PointEntity? p, double angle = pi / 4}) =>
      PointEntity(
        x: cos(angle) * p!.x - sin(angle) * p.y,
        y: sin(angle) * p.x + cos(angle) * p.y,
      );

  void rotatesTank() {
    xComp = cos(angle);
    yComp = sin(angle);
  }

  void updateTank() {
    a = rotate(p: a);
    b = rotate(p: b);
    c = rotate(p: c);

    // rotatesTank();
  }
}
