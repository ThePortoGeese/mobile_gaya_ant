import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

ValueNotifier<BluetoothConnection?> bluetoothConnection = ValueNotifier(null);
const TextStyle alertTitleStyle = TextStyle(fontWeight: FontWeight.bold, color:Color(0xffDB3B3E), fontSize: 22);