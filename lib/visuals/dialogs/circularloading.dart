import 'package:flutter/material.dart';

//THis is a dialog that I use when im waiting for asynchronous work
//work such as searching devices or connecting to devices
//It's just a spinning circle with a text below it

class CircularLoading extends StatelessWidget {

  const CircularLoading({
    super.key, 
    required this.loadingText,
  });
  final String loadingText;
  @override
  Widget build(BuildContext context) {
    return  PopScope(
      canPop: false,
      child: Center(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xffFB923C)),
          padding: EdgeInsets.all(10),
          width: 200,
          height: 200,
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(), 
              Flexible(child: Text(loadingText,textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal, decoration: TextDecoration.combine(List.from({TextDecoration.none})))),),
            ],
          ),
        ),
      ),
    );
    }

    
}
