import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_gaya_ant/l10n/app_localizations.dart';
import 'package:mobile_gaya_ant/visuals/widgets/bluetoothmodule.dart';
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

class _AntMovingControlsState extends State<AntMovingControls> with SingleTickerProviderStateMixin {
  double _antVelocity = 100;
  late final AnimationController _animationController = AnimationController(vsync: this, 
      duration: Duration(milliseconds: 1000)
    );
  late final Animation<double> _animation = CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn);
  late bool _wasConnected = false;
  @override
  void initState() {
    super.initState();
  }


   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final btm = context.watch<BluetoothModule>();
    final connected = btm.bluetoothConnection?.isConnected ?? false;


    if (connected != _wasConnected) {
      connected ? _animationController.forward(from: 0) : _animationController.reverse();
      _wasConnected = connected;
    }
  }

  animateForward(){
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothModule>(builder: (context, btm,child) => Visibility(visible: btm.bluetoothConnection?.isConnected??false,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context , child) {
          return Transform(
            transform: Matrix4.translationValues(0, (1 - _animation.value) * 1000, 0),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.white, boxShadow: [BoxShadow(color: Colors.blueGrey, blurRadius: 5.0, spreadRadius: 1.0)]),
              padding: const EdgeInsets.all(30),
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                          child: Consumer<BluetoothModule>(
                            builder: (context, btm, child) => 
                            Visibility(
                              visible: btm.lastAction != 5,
                              child: FloatingActionButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(30), side: BorderSide(width: 1)),
                                backgroundColor: const Color(0xffDB3B3E),
                                foregroundColor: Colors.white,
                                
                                child: Icon(Icons.stop) , onPressed: (){
                                  btm.sendBytes(Uint8List.fromList([5]), "StopBtn");
                                } 
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),]),
                  SizedBox(height: 10,),
                  Text(AppLocalizations.of(context)!.velocity, style: TextStyle(fontSize: 10 + _antVelocity*0.05),),
                  Consumer<BluetoothModule>(
                    builder: (context, btm, child) {
                      if(btm.bluetoothConnection == null) {
                        _antVelocity = 120;
                      }
                      return Slider(value: _antVelocity,min: 100,max: 190, onChanged: (value) {
                        btm.sendBytes(Uint8List.fromList([value.toInt()]), "VelocityMeter");
                        setState(() {
                          _antVelocity = value;
                        });
                      },
                      activeColor: Color.lerp(Colors.green, Colors.red  , (_antVelocity-100)/100 )
                      );
                    }
                  ),
                  Column(
                    spacing: 20,

                    children: <Widget>[
                        AntActionButton(btnColor:  Color(0xffFFAA69),text: [AppLocalizations.of(context)!.grab, AppLocalizations.of(context)!.release], byte: [Uint8List.fromList([8]),Uint8List.fromList([9])]),
                        TiltingDPad(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AntActionButton(btnColor:Color(0xffD9534F),text: [AppLocalizations.of(context)!.attack], byte: [Uint8List.fromList([5]),Uint8List.fromList([10])]),
                            AntActionButton(btnColor:Color(0xffF4B400), text: [AppLocalizations.of(context)!.dance], byte: [Uint8List.fromList([5]), Uint8List.fromList([20])]),
                        
                          ],
                        )
                            
                    ],
                  ),
            
                ],
              ),
            ),
          );
        }
      )
    ));
  }
}



