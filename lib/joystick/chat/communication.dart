import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Communication {
  //Bluetooth
  late FlutterBluetoothSerial fls;
  late BluetoothConnection? connection;
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  String result = '';

  // Connect to the device via Bluetooth
  Future<void> connectBl(address) async {
    await BluetoothConnection.toAddress(address).then((connection) {
      if (kDebugMode) {
        print('Connected to the device');
      }
      connection = connection;

      // Creates a listener to receive data
      connection.input?.listen(onDataReceived).onDone(() {});
    }).catchError((error) {
      if (kDebugMode) {
        print('Cannot connect, exception occured');
      }
    });
  }

  // When receive information
  void onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    result = String.fromCharCodes(buffer);
  }

  // To send Message
  Future<void> sendMessage(String text) async {
    text = text.trim();

    if (text.length > 0) {
      try {
        connection!.output.add(utf8.encode(text + "\r\n"));
        await connection!.output.allSent;
      } catch (e) {}
    }
  }

  Future<void> dispose() async {
    fls.setPairingRequestHandler(null);
    if (connection!.isConnected) {
      connection!.dispose();
      connection = null;
    }
  }
}
