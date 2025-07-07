import 'package:flutter/material.dart';

class BottomSheetGAYA extends StatelessWidget {
  const BottomSheetGAYA({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container (
      height: 100,
      decoration: BoxDecoration(color:  Color(0xffFB923C)),
      child: Center(
        child: Image.asset('assets/ispgayalogo.png'),
    
      )
    );
  }
}
