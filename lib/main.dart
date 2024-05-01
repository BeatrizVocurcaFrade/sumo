import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sumo/joystick/chat/main_page.dart';

void _errorTreatment(erro, StackTrace errorTreatment) async {
  log(erro.toString() + _errorTreatment.toString());
}

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight])
    //     .then((_) {
    runApp(const JoystickExampleApp());
    // });
  }, _errorTreatment);
}

class JoystickExampleApp extends StatelessWidget {
  const JoystickExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: MainPage());
  }
}
