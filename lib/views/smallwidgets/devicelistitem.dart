import 'package:flutter/material.dart';


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
