import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bluetoothmodule.dart';


enum Direction {up, right, down, left, none}

class TiltingDPad extends StatefulWidget {
  const TiltingDPad({
    super.key,
  });
  final String id = "TiltingDPad";
  @override
  State<TiltingDPad> createState() => _TiltingDPadState();
}

class _TiltingDPadState extends State<TiltingDPad> {
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
              painter: DPadPainter(dir: currentDir, radius: radius, sensitivity: sensitivity),
            )
          ),
        );
      }
    );
  }

  void resetAnt() {
    context.read<BluetoothModule>().sendBytes(Uint8List.fromList([5]), widget.id);
    setState(() {
      currentDir = Direction.none;
    });
    return;
  }

  void update(dynamic details) {
      final local = details.localPosition;
      final size = context.size!;
      final center = size.center(Offset.zero);
      final offsetFromCenter = local -  center;

      Direction dir = retrieveDirection(offsetFromCenter);
    
      debugPrint(dir.toString());

      setState(() {
        currentDir = dir;
        sendDataBasedOnDirection(dir);
      });
  }

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

class DPadPainter extends CustomPainter{
  const DPadPainter({
    required this.dir, required this.radius, required this.sensitivity
  });

  final int radius;
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


    var pat = Path()..addOval( canvasClipCircle);

    canvas.clipPath(pat);
    canvas.drawOval(borderCircle, borderPaint);

    Paint ovalPaint = Paint();
    ovalPaint.color = Color(0xffE87619);

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

      Offset center = Offset(size.width/2, size.height/2);
      Paint sectorPaint = Paint();
      sectorPaint.color = Color(0x00000000).withValues(alpha: 0.1);
      Path sector = Path()..moveTo(center.dx,center.dy);

      switch (dir){
        case Direction.up:
          sector.lineTo(center.dx+sqrt(radius), center.dy+sqrt(radius));
          sector.addArc( canvasClipCircle, 7 * pi / 4, - pi/2);
          sector.lineTo(center.dx, center.dy);
        case Direction.right:
          sector.lineTo(center.dx+sqrt(radius), center.dy+sqrt(radius));
          sector.addArc( canvasClipCircle, 7 * pi / 4, pi/2);
          sector.lineTo(center.dx, center.dy);
        case Direction.down:
          sector.lineTo(center.dx+sqrt(radius), center.dy+sqrt(radius));
          sector.addArc( canvasClipCircle, pi / 4, pi/2);
          sector.lineTo(center.dx, center.dy);
        case Direction.left:
          sector.lineTo(center.dx+sqrt(radius), center.dy+sqrt(radius));
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