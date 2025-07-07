
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide Size;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:mobile_gaya_ant/bluetoothmodule.dart';
import 'package:mobile_gaya_ant/data/values.dart';
import 'package:mobile_gaya_ant/visuals/dialogs/normalalert.dart';
import 'package:provider/provider.dart';

class AntActionButton extends StatefulWidget {
  const AntActionButton({
    super.key,
    required this.text,
    required this.byte
  });
  final String text;
  final List<Uint8List> byte;

  @override
  State<AntActionButton> createState() => _AntActionButtonState();
}

class _AntActionButtonState extends State<AntActionButton> {
  int functionNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothModule>(
      builder: (context, btm, child) {
        if(btm.bluetoothConnection != null){
          if(btm.lastSender != widget.text){
            functionNumber = 0;
          }
        } else {
          functionNumber = 0;
        }

        return ElevatedButton(
          style: ButtonStyle(
            minimumSize: WidgetStatePropertyAll<Size>(Size(double.infinity, 50)),
            backgroundColor: WidgetStateProperty.all<Color>(Color(0xffFFAA69)), 
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                 
                borderRadius: BorderRadius.circular(40.0),
                side: BorderSide(color: Colors.black),
                
              ))),
          
          onPressed: () {
            setState(() {
              if(++functionNumber == widget.byte.length){
              functionNumber=0;
            }
            });
            context.read<BluetoothModule>().sendBytes(widget.byte[functionNumber], widget.text);
          } , child: Text(widget.text, style: TextStyle(fontSize: 18))
        );
      }
    );}   
}