import 'package:flutter/material.dart';

class BottomSheetGAYA extends StatelessWidget {
  const BottomSheetGAYA({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container (
      height: 100,
      padding: EdgeInsetsGeometry.all(20),
      decoration: BoxDecoration(color:  Color(0xffFB923C), boxShadow:  [BoxShadow(color: Colors.black, blurRadius: 3.0, spreadRadius: 0.5)]),
      child: Center(
        child: Image.asset('assets/ispgayalogo.png'),
    
      )
    );
  }
}
