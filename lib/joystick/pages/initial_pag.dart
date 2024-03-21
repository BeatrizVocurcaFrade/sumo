import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:sumo/constants.dart';
import 'package:sumo/joystick/entities/point_entity.dart';
import 'package:sumo/joystick/widgets/ball.dart';
import 'package:sumo/joystick/widgets/sumo_ring.dart';

class JoystickAreaExample extends StatefulWidget {
  const JoystickAreaExample({super.key});

  @override
  State<JoystickAreaExample> createState() => _JoystickAreaExampleState();
}

class _JoystickAreaExampleState extends State<JoystickAreaExample> {
  PointEntity pointA = PointEntity(x: 0, y: 0);
  PointEntity pointB = PointEntity(x: 0, y: 0);
  PointEntity initialPoint = PointEntity(x: 0, y: 0);
  void initPoints() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pointA = PointEntity(
        x: MediaQuery.of(context).size.width / 4 - BALL_SIZE / 2, //horizontal
        y: MediaQuery.of(context).size.height / 2.7 - BALL_SIZE / 2,
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
      setState(() {});
    });
  }

  @override
  void initState() {
    initPoints();
    super.initState();
  }

  bool isInCicle(PointEntity point) =>
      pow(point.x - initialPoint.x, 2) + pow(point.y - initialPoint.y, 2) <
      pow(SUMO_SIZE / 2, 2);
  @override
  void didChangeDependencies() {
    initPoints();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luta de Sumô'),
      ),
      body: SafeArea(
        child: JoystickArea(
          mode: JoystickMode.all,
          initialJoystickAlignment: const Alignment(0.9, -0.1),
          listener: (details) {
            // PointEntity futurePoint = PointEntity(
            //   x: pointA.x + STEP * details.x,
            //   y: pointA.y + STEP * details.y,
            // );

            // if (isInCicle(futurePoint)) return;

            pointA = PointEntity(
              x: pointA.x + STEP * details.x,
              y: pointA.y + STEP * details.y,
            );
            setState(() {});
          },
          child: Stack(
            children: [
              SumoRing(
                initialPoint,
              ),
              Ball(
                point: pointB,
                color: Colors.green,
              ),
              Ball(
                point: pointA,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
