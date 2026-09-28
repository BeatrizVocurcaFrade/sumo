# sumo: Bluetooth sumo-robot controller (Flutter prototype)

Flutter prototype for driving a sumo robot from an Android phone. It connects over classic Bluetooth serial to an **HC-06** module and shows an on-screen joystick.

## Features

- **Bluetooth management:** on/off switch, adapter status, runtime permissions (scan, connect, advertise), bonded-device list, and automatic connection to the paired HC-06.
- **Joystick screen:** landscape joystick that moves a player marker inside a circular arena (circle-collision math); the heading is tracked with a rotation matrix.
- **Serial link:** a test action that writes to the Bluetooth connection, with incoming bytes shown in debug builds.
- **State management:** two Cubits, one for Bluetooth and one for the player, with Equatable states.

**Stack:** Flutter · Dart · flutter_bloc · flutter_bluetooth_serial · flutter_joystick · permission_handler

## Run

```bash
flutter pub get
flutter run   # Android device with Bluetooth; pair the HC-06 first
```

## Status

Prototype (2024). Joystick movement is not yet translated into motor commands. The next step is mapping joystick direction and speed to a serial command protocol on the robot's microcontroller.
