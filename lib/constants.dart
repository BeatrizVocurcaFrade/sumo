// ignore_for_file: constant_identifier_names

import 'package:fluttertoast/fluttertoast.dart';

const BALL_SIZE = 30.0;
const SUMO_SIZE = 200.0;
const STEP = 15.0;

void showMessage(String message) =>
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG);
