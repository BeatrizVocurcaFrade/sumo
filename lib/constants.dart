// ignore_for_file: constant_identifier_names

import 'package:fluttertoast/fluttertoast.dart';

const BALL_SIZE = 30.0;
const SUMO_SIZE = 250.0;
const SUMO_DARK_SIZE = 250.0;
const STEP = 15.0;
const SUMO_RING_POSITION_Y = 2.8;

///quanto maior mais alto
const SUMO_RING_POSITION_X = 4.8;

///quanto maior mais esquerda
const DIST_PLAYER_CENTER = 30;

void showMessage(String message) =>
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG);
