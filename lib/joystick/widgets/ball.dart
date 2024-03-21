import 'package:flutter/material.dart';
import 'package:sumo/constants.dart';
import 'package:sumo/joystick/entities/point_entity.dart';

class Ball extends StatelessWidget {
  final PointEntity point;
  final Color? color;
  const Ball({
    super.key,
    required this.point,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: point.x,
      top: point.y,
      child: Container(
        width: BALL_SIZE,
        height: BALL_SIZE,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color ?? Colors.redAccent,
        ),
        child: const Icon(
          Icons.person,
        ),
      ),
    );
  }
}
