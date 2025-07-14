// ignore_for_file: camel_case_types

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/bluetoothmodule.dart';


enum Direction {up, right, down, left, none}

class dPad extends StatefulWidget {
  const dPad({
    super.key,
  });
  final String id = "dPad";
  @override
  State<dPad> createState() => _dPadState();
}

//This is the D-Pad widget

class _dPadState extends State<dPad> {

  //Radius and sensitivity is set here
  //Watch out for changing the radius, the text painters in the widget kinda get funky, I dunno why
  final int radius = 100;
  final double sensitivity = 4.0;
  Direction currentDir=Direction.none; 

  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothModule>(
      builder: (context, btm, child) {
        if(btm.bluetoothConnection != null){
          if(btm.lastSender != widget.id){
            currentDir = Direction.none;
          }
        } else {
          currentDir = Direction.none;
        }
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: (details) => update(details),
          onPanUpdate: (details) => update(details),
          onPanEnd: (_) => resetAnt(),
          onLongPressStart: (details) => update(details),
          onLongPressEnd: (_) => resetAnt(),
          onLongPressCancel: () => resetAnt(),
          onTapDown: (details) => update(details),
          onTapUp: (_)=> resetAnt(),
          child: Container(
            height: radius*2,
            width: radius*2,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xffFB923C)),
            child: CustomPaint(
              painter: dPadPainter(dir: currentDir, sensitivity: sensitivity),
            )
          ),
        );
      }
    );
  }
  //This function is triggered when the user lifts their finger
  void resetAnt() {
    context.read<BluetoothModule>().sendBytes(Uint8List.fromList([5]), widget.id);
    setState(() {
      currentDir = Direction.none;
    });
    return;
  }
  //Function called each time the user taps, pans or long presses
  //Gets its position and calculates the direction
  void update(dynamic details) {
      final local = details.localPosition;
      final size = context.size!;
      final center = size.center(Offset.zero);
      final offsetFromCenter = local -  center;

      Direction dir = retrieveDirection(offsetFromCenter);
    
      //debugPrint(dir.toString());

      setState(() {
        currentDir = dir;
        sendDataBasedOnDirection(dir);
      });
  }
  //Send the ant commands based on the direction, check ant API for reference 
  void sendDataBasedOnDirection(Direction dir){
    switch (dir){
      case Direction.up:
        context.read<BluetoothModule>().sendBytes(Uint8List.fromList([1]), widget.id);
        break;
      case Direction.down:
        context.read<BluetoothModule>().sendBytes(Uint8List.fromList([2]), widget.id);
        break;
      case Direction.left:
        context.read<BluetoothModule>().sendBytes(Uint8List.fromList([3]), widget.id);
        break;
      case Direction.right:
        context.read<BluetoothModule>().sendBytes(Uint8List.fromList([4]), widget.id);
        break;
      case Direction.none:
        
    }
  }
   //THis gets the direction the user is clicking based on math :D
  Direction retrieveDirection(Offset offsetFromCenter){
    if(offsetFromCenter.dx.abs() < sensitivity && offsetFromCenter.dy.abs() <sensitivity){
      return Direction.none;
    }
    //IF it has moved more on the main axis than the cross axis
    if(offsetFromCenter.dx.abs() >= offsetFromCenter.dy.abs()){
      return (offsetFromCenter.dx < 0 ? Direction.left : Direction.right);
    } else {
      return (offsetFromCenter.dy < 0 ? Direction.up : Direction.down);
    }
  }
}

class dPadPainter extends CustomPainter{
  const dPadPainter({
    required this.dir, required this.sensitivity
  });

  final Direction dir;
  final double sensitivity;

  @override
  void paint(Canvas canvas, Size size) {
    Rect canvasClipCircle = Rect.fromCenter(center: Offset(size.width/2, size.height/2), width: size.width, height: size.height);

    //This circle is slightly smaller than the canvas so the stroke doesnt look weird on the app
    Rect borderCircle = Rect.fromCenter(center: Offset(size.width/2, size.height/2), width: size.width-2, height: size.height-2);

    Paint borderPaint = Paint();
    borderPaint.style = PaintingStyle.stroke;
    borderPaint.color = Colors.black;
    borderPaint.strokeWidth = 2;

    //Clips the canvas so the ovals dont look goofy
    var pat = Path()..addOval( canvasClipCircle);

    canvas.clipPath(pat);
    canvas.drawOval(borderCircle, borderPaint);

    Paint ovalPaint = Paint();
    ovalPaint.color = Color(0xffCE5200);
    //Draws the ovals with a darker color, making the rest of the circle pop out
    //this has no effect on functionality, just looks cool
    {
      Rect rect = Rect.fromCenter(center: Offset(size.width, size.height), width: 150, height: 130) ;
      canvas.drawOval(rect, ovalPaint);
      canvas.drawOval(rect, borderPaint);
    }
    {
      Rect rect = Rect.fromCenter(center: Offset(0, size.height), width: 150, height: 130) ;
      
      canvas.drawOval(rect, ovalPaint);
      canvas.drawOval(rect, borderPaint);
    }
    {
      Rect rect = Rect.fromCenter(center: Offset(0, 0), width: 150, height: 130) ;
      
      canvas.drawOval(rect, ovalPaint);
      canvas.drawOval(rect, borderPaint);
    }
    {
      Rect rect = Rect.fromCenter(center: Offset(size.width, 0), width: 150, height: 130) ;
      
      canvas.drawOval(rect, ovalPaint);
      canvas.drawOval(rect, borderPaint);
    }
    //These are the arrows of the dPad, they are drawn in a very schizophrenic way since size/2 didnt match up to the center
    //due to the font size I think?
    //watch out for ts if you change the radius
    //ts pmo

      const textStyle = TextStyle(
        color: Colors.black,
        fontSize: 30,
      );
    {
      const textSpan = TextSpan(
        text: '↑',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      textPainter.paint(canvas, Offset(size.width/2-10, size.height/2-20 - size.height/2*0.8));
    }
    {
      const textSpan = TextSpan(
        text: '↓',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      textPainter.paint(canvas, Offset(size.width/2-10, size.height/2-20 + size.height/2*0.8));
    }
    {
      const textSpan = TextSpan(
        text: '↶',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      textPainter.paint(canvas, Offset(size.width/2-12.5-size.width/2*0.8, size.height/2-25));
    }
    {
      const textSpan = TextSpan(
        text: '↷',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      textPainter.paint(canvas, Offset(size.width/2-12.5+size.width/2*0.8, size.height/2-25));
    }

    Offset center = Offset(size.width/2, size.height/2);
    Paint sectorPaint = Paint();
    sectorPaint.color = Color(0xffF4B400).withValues(alpha: 0.3);
    Path sector = Path()..moveTo(center.dx,center.dy);

    //Paints the sector a bit yellower if its selected
    //Purely design choice, looks cool 
    switch (dir){
      case Direction.up:
        sector.lineTo(center.dx+sqrt(size.width), center.dy+sqrt(size.height));
        sector.addArc( canvasClipCircle, 7 * pi / 4, - pi/2);
        sector.lineTo(center.dx, center.dy);
      case Direction.right:
        sector.lineTo(center.dx+sqrt(size.width), center.dy+sqrt(size.height));
        sector.addArc( canvasClipCircle, 7 * pi / 4, pi/2);
        sector.lineTo(center.dx, center.dy);
      case Direction.down:
        sector.lineTo(center.dx+sqrt(size.width), center.dy+sqrt(size.height));
        sector.addArc( canvasClipCircle, pi / 4, pi/2);
        sector.lineTo(center.dx, center.dy);
      case Direction.left:
        sector.lineTo(center.dx+sqrt(size.width), center.dy+sqrt(size.height));
        sector.addArc( canvasClipCircle, 5 * pi / 4, - pi/2);
        sector.lineTo(center.dx, center.dy);
      default:
        sector.addArc(Rect.fromCenter(center: center, width: sensitivity*2, height: sensitivity*2), 0, 2*pi);
    }

    canvas.drawPath(sector, sectorPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}