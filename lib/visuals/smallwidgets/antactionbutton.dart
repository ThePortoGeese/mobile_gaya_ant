
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide Size;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:mobile_gaya_ant/l10n/app_localizations.dart';
import 'package:mobile_gaya_ant/visuals/widgets/bluetoothmodule.dart';
import 'package:mobile_gaya_ant/models/generalvalues.dart';
import 'package:mobile_gaya_ant/visuals/dialogs/normalalert.dart';
import 'package:provider/provider.dart';

class AntActionButton extends StatefulWidget {
  const AntActionButton({
    super.key,
    required this.text,
    required this.byte,
    required this.btnColor
  });
  final List<String> text;
  final List<Uint8List> byte;
  final Color btnColor;

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
          if(btm.lastSender != widget.text[0]){
            functionNumber = 0;
          }
        } else {
          functionNumber = 0;
        }

        return Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>((functionNumber == 0) ? widget.btnColor : transformPressedEffect(widget.btnColor)), 
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                     
                    borderRadius: BorderRadius.circular(40.0),
                    side: BorderSide(color: Colors.black, strokeAlign: (functionNumber == 0) ? 0 : 6),
                    
                  ))),
              
              onPressed: () {
                setState(() {
                  if(++functionNumber == widget.byte.length){
                  functionNumber=0;
                }
                });
                context.read<BluetoothModule>().sendBytes(widget.byte[functionNumber], widget.text[0]);
              } , child: Text((functionNumber > widget.text.length-1) ? AppLocalizations.of(context)!.stop : widget.text[functionNumber], style: TextStyle(fontSize: 18))
            ),
          ),
        );
      }
    );}   

  Color transformPressedEffect(Color baseColor) {
    final hsl = HSLColor.fromColor(baseColor);
    
    final modified = hsl.withSaturation(
      (hsl.saturation * 1.25).clamp(0.0, 1.0),
    ).withLightness(
      (hsl.lightness * 0.85).clamp(0.0, 1.0),
    );

    return modified.toColor();
  }
}