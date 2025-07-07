
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide Size;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:mobile_gaya_ant/bluetoothmodule.dart';
import 'package:mobile_gaya_ant/data/values.dart';
import 'package:mobile_gaya_ant/views/dialogs/normalalert.dart';
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
        sendBytes(widget.byte[functionNumber], context);
      } , child: Text(widget.text, style: TextStyle(fontSize: 18))
    );}   
}

 void sendBytes(Uint8List i, BuildContext context) async{
    try {
      context.read<BluetoothModule>().bluetoothConnection?.output.add(i);
      await context.read<BluetoothModule>().bluetoothConnection?.output.allSent;
      debugPrint("Sent ${i.toString()}");
      return;
    } catch (e){
      if(!context.mounted) return;
      showDialog(context: context, builder: (context) {
        return Normalalert(titleText: "ERRO BLUETOOTH", bodyText: "Não foi possível estabelecer conexão com o dispositivo. Emparelhe-o de novo.", titleStyle: alertTitleStyle);
      },);
      context.read<BluetoothModule>().disconnectFromDevice();
    }
  } 