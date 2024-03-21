import 'package:flutter/material.dart';
import 'package:sumo/constants.dart';
import 'package:sumo/joystick/entities/point_entity.dart';

class SumoRing extends StatelessWidget {
  final PointEntity point;

  const SumoRing(this.point, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: point.x,
      top: point.y,
      child: Container(
        width: SUMO_SIZE,
        height: SUMO_SIZE,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          border: Border.all(color: Colors.white, width: 3),
        ),
      ),
    );
  }
}
