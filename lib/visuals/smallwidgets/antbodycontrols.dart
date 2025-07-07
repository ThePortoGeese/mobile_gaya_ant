
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../bluetoothmodule.dart';

class AntBodyControls extends StatefulWidget {
  const AntBodyControls({super.key,});
  final String id = "AntBodyControls"; 
  @override
  State<AntBodyControls> createState() => _AntBodyControlsState();
}

class _AntBodyControlsState extends State<AntBodyControls> {
  bool headActive = false;
  bool tailActive = false;
  ui.Image? antBody;
  ui.Image? antHead;
  ui.Image? antTail;

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
  Widget build(BuildContext context) {
    return Consumer<BluetoothModule>(
      builder: (context, btm, child) {
        if(btm.bluetoothConnection != null){
          if(btm.lastSender != widget.id){
            debugPrint("Reset Tail State");
            headActive = false;
            tailActive = false;
          }
        }
        //TODO: FIX TS
        return Center(
          child: SizedBox(
            width: 300,
            height: 200,
            child: GestureDetector(
              onTapDown: (details) => getSector(details),
              child: CustomPaint (
                painter: (antBody != null && antHead != null && antTail != null) ?  AntBodyPainter(headActive: headActive, tailActive: tailActive, antBody: antBody!, antHead: antHead!, antTail: antTail!) : null
              )
            ),
          ),
        );
      }
    );
    
  }

  void getSector(dynamic details){
    if(details.localPosition.dx <context.size!.width/2.7){
      context.read<BluetoothModule>().sendBytes(Uint8List.fromList([7]), widget.id);
      setState(() {
        headActive = !headActive;
      });
      debugPrint("HeadState: $headActive");
    } else if(details.localPosition.dx > context.size!.width * 0.61){
      context.read<BluetoothModule>().sendBytes(Uint8List.fromList([6]), widget.id);
      debugPrint("TailState1: $tailActive");
      setState(() {
        tailActive = !tailActive;
      });
      debugPrint("TailState: $tailActive");
    }
  }
}

class AntBodyPainter extends CustomPainter {
  const AntBodyPainter ({
    required this.headActive, 
    required this.tailActive,
    required this.antBody,
    required this.antHead,
    required this.antTail
  });
  final ui.Image antHead;
  final bool headActive;
  final bool tailActive;
  final ui.Image antBody;
  final ui.Image antTail;
  @override
  void paint(Canvas canvas, Size size) {
    final headPaint = Paint()
    ..colorFilter = ColorFilter.mode(
      headActive ? Color(0xffFF7919)    // or whatever colour you need
                    : Color(0xffFF9A47),    // “no tint” = white
      BlendMode.srcIn,                 // keeps the image’s alpha, replaces colour
    );

    final tailPaint = Paint()
    ..colorFilter = ColorFilter.mode(
      tailActive ? Color(0xffFF7919)    // or whatever colour you need
                    : Color(0xffFF9A47),     // “no tint” = white
      BlendMode.srcIn,                 // keeps the image’s alpha, replaces colour
    );
    
    canvas.drawImage(antBody,Offset(size.width/4, 0), Paint()..color = Colors.brown);
    canvas.drawImage(antHead,Offset(size.width/2.7-81, 0), headPaint);
    canvas.drawImage(antTail, Offset(size.width*0.61, 0), tailPaint);
  }

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