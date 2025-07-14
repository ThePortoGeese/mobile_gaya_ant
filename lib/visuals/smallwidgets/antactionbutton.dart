import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide Size;
import 'package:ispgaya_ant/l10n/app_localizations.dart';
import 'package:ispgaya_ant/models/bluetoothmodule.dart';
import 'package:provider/provider.dart';

class AntActionButton extends StatefulWidget {
  const AntActionButton({
    super.key,
    required this.id,
    required this.text,
    required this.byte,
    required this.btnColor
  });
  final String id;
  final List<String> text;
  final List<Uint8List> byte;
  final Color btnColor;

  @override
  State<AntActionButton> createState() => _AntActionButtonState();
}

//This is a little customizable action button which can have an infinite number of states
//You need to pass the bytes that each action sends and its text
//The first byte should always be the neutral state of the part you are moving as the button naturally starts inactive
//when functionNumber is 0, the button is inactive
//the button changes colour to a slightly more saturated and darker value of the original colour
//and it's border changes a bit
//If you dont provide a text for the last state, it gets provided to you (Default is stop)
//Also, the order of the text should be Action1-ActionN-NeutralState

class _AntActionButtonState extends State<AntActionButton> {
  int functionNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothModule>(
      builder: (context, btm, child) {

        if(btm.bluetoothConnection != null){
          if(btm.lastSender != widget.id){
            functionNumber = 0;
          }
        } else {
          functionNumber = 0;
        }

        //debugPrint(widget.text[0] + " " + functionNumber.toString());
        return 
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>((functionNumber == 0) ? widget.btnColor : transformPressedEffect(widget.btnColor)), 
              foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.black, strokeAlign: (functionNumber == 0) ? 0 : 6),
                  
                ))),
            
            onPressed: () {
              setState(() {
                if(++functionNumber == widget.byte.length){
                functionNumber=0;
              }
              });
              context.read<BluetoothModule>().sendBytes(widget.byte[functionNumber],widget.id);
            } , child: Text((functionNumber > widget.text.length-1) ? AppLocalizations.of(context)!.stop : widget.text[functionNumber], style: TextStyle(fontSize: 18))
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