import 'package:flutter/material.dart';
import 'package:sumo/joystick/entities/point_entity.dart';

class MiniPoint extends StatelessWidget {
  final PointEntity point;
  final Color? color;
  const MiniPoint({
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
        width: 2,
        height: 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color ?? Colors.redAccent,
        ),
      ),
    );
  }
}
