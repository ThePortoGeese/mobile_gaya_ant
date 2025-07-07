import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_gaya_ant/bluetoothmodule.dart';
import 'package:mobile_gaya_ant/visuals/smallwidgets/antactionbutton.dart';
import 'package:mobile_gaya_ant/visuals/smallwidgets/antbodycontrols.dart';
import 'package:mobile_gaya_ant/visuals/smallwidgets/tiltingdpad.dart';
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
            SizedBox(height: 10),
          
            Stack(children:[
              AntBodyControls() ,
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
                        context.read<BluetoothModule>().sendBytes(Uint8List.fromList([5]), "StopBtn");
                      } 
                    ),
                  ),
                ],
              ),]),
            SizedBox(height: 10,),
            Text("VELOCIDADE"),
            Consumer<BluetoothModule>(
              builder: (context, btm, child) {
                if(btm.bluetoothConnection == null) {
                  antVelocity = 120;
                }
                return Slider(value: antVelocity,min: 100,max: 190, onChanged: (value) {
                  context.read<BluetoothModule>().sendBytes(Uint8List.fromList([value.toInt()]), "VelocityMeter");
                  setState(() {
                    antVelocity = value;
                  });
                },);
              }
            ),
            Column(
              spacing: 20,
              // TODO: ADD MORE BUTTONS
              children: <Widget>[
                  // TODO: ADD SEND BYTES TO THESE FUNCTIONS, THEY ONLY HAVE NEUTRAL STATE
                  AntActionButton(text: "Agarrar", byte: [Uint8List.fromList([5]),Uint8List.fromList([8]),Uint8List.fromList([9])]),
                  TiltingDPad(),
                  AntActionButton(text: "Atacar", byte: [Uint8List.fromList([5]),Uint8List.fromList([10])]),
                  AntActionButton(text: "Dançar", byte: [Uint8List.fromList([5])]),
              ],
            ),

          ],
        ),
      )
    ));
  }
}



