import 'package:flutter/material.dart';

//Interistingly, the device list item is just a normal button
//The ondevicetap function gets passed down to it since I didnt want to use the bluetooth module in 
//5  billion files, its located in the menupage.dart

class DeviceListItem extends StatelessWidget {
  const DeviceListItem({
    super.key,
    required this.value,
    required this.onDeviceTap
  });

  final String value;
  final Function onDeviceTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => onDeviceTap(),
        child: Text(value,style: TextStyle(color: Colors.black),),
      );
    }
}
