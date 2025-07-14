import 'package:flutter/material.dart';
import 'package:ispgaya_ant/l10n/app_localizations.dart';

class BottomSheetGAYA extends StatelessWidget {
  const BottomSheetGAYA({
    super.key,
  });

//THis is the bottom widget for the app which just contains ISP's logo and a string about who made the app

  @override
  Widget build(BuildContext context) {
    return Container (
      height: 55,
      padding: EdgeInsetsGeometry.all(5),
      decoration: BoxDecoration(color:  Color(0xffFB923C), boxShadow:  [BoxShadow(color: Colors.black, blurRadius: 3.0, spreadRadius: 0.5)]),
      child: Column(
        children: [
          Center(
            child: Image.asset('assets/ispgayalogo.png', height: 35,),
              
          ),
          Text(AppLocalizations.of(context)!.credits, style: TextStyle(color: Colors.white, fontSize: 7),)
        ],
      )
    );
  }
}
