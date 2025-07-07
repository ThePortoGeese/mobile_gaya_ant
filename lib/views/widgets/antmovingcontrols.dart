import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_gaya_ant/bluetoothmodule.dart';
import 'package:mobile_gaya_ant/views/smallwidgets/antactionbutton.dart';
import 'package:mobile_gaya_ant/views/smallwidgets/tiltingdpad.dart';
import 'package:provider/provider.dart';


class AntMovingControls extends StatefulWidget {
  const AntMovingControls({
    super.key,
  });
  @override
  State<AntMovingControls> createState() => _AntMovingControlsState();
}

class _AntMovingControlsState extends State<AntMovingControls> {
  double antVelocity = 100;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(listenable: context.read<BluetoothModule>(), builder: (context, child) => Visibility(visible: (context.read<BluetoothModule>().bluetoothConnection?.isConnected??false),
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          children: [
            Row(children: [


            ],),
            SizedBox(height: 10),
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(30), side: BorderSide(width: 1)),
                      backgroundColor: const Color(0xffDB3B3E),
                      foregroundColor: Colors.white,
                      child: Icon(Icons.stop) , onPressed: (){
                        sendBytes(Uint8List.fromList([5]), context);
                      } 
                    ),
                  ),
                ],
              ),
            SizedBox(height: 10,),
            Text("VELOCIDADE"),
            Slider(value: antVelocity,min: 100,max: 190, onChanged: (value) {
              sendBytes(Uint8List.fromList([value.toInt()]), context);
              setState(() {
                antVelocity = value;
              });
            },),
            Column(
              spacing: 20,
              // TODO: ADD MORE BUTTONS
              children: <Widget>[
                  // TODO: ADD SEND BYTES TO THESE FUNCTIONS, THEY ONLY HAVE NEUTRAL STATE
                  AntActionButton(text: "Agarrar", byte: [Uint8List.fromList([5])]),
                  TiltingDPad(),
                  AntActionButton(text: "Atacar", byte: [Uint8List.fromList([5])]),
                  AntActionButton(text: "Dançar", byte: [Uint8List.fromList([5])]),
              ],
            ),

          ],
        ),
      )
    ));
  }
}



