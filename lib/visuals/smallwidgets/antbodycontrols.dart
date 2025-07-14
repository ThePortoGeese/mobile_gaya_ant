
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/bluetoothmodule.dart';


class AntBodyControls extends StatefulWidget {
  const AntBodyControls({super.key,});
  final String id = "AntBodyControls"; 
  @override
  State<AntBodyControls> createState() => _AntBodyControlsState();
}
//This is the widget responsible for showing the ant body and the controls for the head and tail

class _AntBodyControlsState extends State<AntBodyControls> with TickerProviderStateMixin {
  late final AnimationController _animationContoller = AnimationController(vsync: this, duration: Duration(seconds: 1))..repeat(reverse: true); 
  late final Animation<double> _intensity = CurvedAnimation(
    parent: _animationContoller,
    curve: Curves.easeInOut,
  );

  //This animation is the colour change in the head and tail parts of the ant
  //This animation incentivises the user to click on it (I didnt want just plain text) 

  bool headActive = false;
  bool tailActive = false;
  ui.Image? antBody;
  ui.Image? antHead;
  ui.Image? antTail;

  //I really hate how ui.Images are loaded
  //I needed to grab a random function from stack overflow so I could load the images to my custom painter
  //this is just that

  @override
  void initState() {
    super.initState();
    loadUiImage('assets/formigasempartes.png').then((img) => {
      setState(() {
        antBody = img;    
      })
    });
    loadUiImage('assets/anthead.png').then((img) => {
      setState(() {
        antHead = img;    
      })
    });
    loadUiImage('assets/anttail.png').then((img) => {
      setState(() {
        antTail = img;    
      })
    });
  }

   @override
  void dispose() {
    _animationContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothModule>(
      builder: (context, btm, child) {
        if(btm.bluetoothConnection != null){
          //This checks if the last sender of data was this widget, if it isnt e.g. the user clicked a random button which led to 
          //a reset of the animation in the ant or another action, I reset the widget state to neutral
          if(btm.lastSender != widget.id){
            headActive = false;
            tailActive = false;
          }
        }
        return Center(
          child: SizedBox(
            width: 300,
            height: 200,
            //I use a gesture detector to see where the user clicks


            child: GestureDetector(
              onTapDown: (details) => getSector(details),
              //Used a stack here so i could overlay both custom painters, creating the illusion of them being connected
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint (
                    painter: (antHead != null && antTail != null) ?  AntHeadTailPainter(intensity:_intensity,headActive: headActive, tailActive: tailActive, antHead: antHead!,antTail: antTail!) : null
                  ),
                  CustomPaint(
                    painter: (antBody != null ) ? AntBodyPainter(antBody: antBody!) : null 
                  )
                ],
              )
            ),
          ),
        );
      }
    );
    
  }
  //This function gets the details of the tapdown and checks its position
  //The values are very specific and correspond to the ant's head and tail position relative to the size of the widget
  //If you want to change this, change in the custompainter too
  void getSector(dynamic details){
    if(details.localPosition.dx <context.size!.width/2.7){
      setState(() {
        headActive = !headActive;
      });
      context.read<BluetoothModule>().sendBytes(Uint8List.fromList([7]), widget.id);
      //debugPrint("HeadState: $headActive");
    } else if(details.localPosition.dx > context.size!.width * 0.61){
      //debugPrint("TailState1: $tailActive");
      setState(() {
        tailActive = !tailActive;
      });
      context.read<BluetoothModule>().sendBytes(Uint8List.fromList([6]), widget.id);
      //debugPrint("TailState: $tailActive");
    }
  }
}


//This is the custom painter for the ant body (only)
class AntBodyPainter extends CustomPainter {
  const AntBodyPainter ({
    required this.antBody,
  });
  final ui.Image antBody;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(antBody,Offset(size.width/4, 0), Paint()..color = Colors.brown);
  }
  //shhould never repaint as it doesnt change any alteration based on state
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

//Custom painter for the ant head and tail

class AntHeadTailPainter extends CustomPainter {
  const AntHeadTailPainter ({
    required this.headActive, 
    required this.tailActive,
    required this.antHead,
    required this.antTail,
    required this.intensity
  }) : super(repaint: intensity);
  final Animation<double> intensity;
  final ui.Image antHead;
  final bool headActive;
  final bool tailActive;
  final ui.Image antTail;
  @override
  void paint(Canvas canvas, Size size) {
    //paint changes based on intensity if the part isnt active
    final headPaint = Paint()
    ..colorFilter = ColorFilter.mode(
      headActive ? Color(0xffFF7919)   
                    : Color.lerp( Colors.brown, Color(0xffFF9A47), intensity.value)!,   
      BlendMode.srcIn,              
    );

    final tailPaint = Paint()
    ..colorFilter = ColorFilter.mode(
      tailActive ? Color(0xffFF7919)   
                    : Color.lerp( Colors.brown  , Color(0xffFF9A47), intensity.value)!,    
      BlendMode.srcIn,              
    );
    
    canvas.drawImage(antHead,Offset(size.width/2.7-81, 0), headPaint);
    canvas.drawImage(antTail, Offset(size.width*0.61, 0), tailPaint);
  }
  //should always repaint (constantly changing states and all that)
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Future<ui.Image> loadUiImage(String assetPath) async {
  final ByteData data = await rootBundle.load(assetPath);
  final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  final frame = await codec.getNextFrame();
  return frame.image;
}