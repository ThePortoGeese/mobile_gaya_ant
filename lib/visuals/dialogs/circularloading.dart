import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {

  const CircularLoading({
    super.key, 
    required this.loadingText,
  });
  final String loadingText;
  @override
  Widget build(BuildContext context) {
    return  Center(
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
                Flexible(child: Text(loadingText,textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal, decoration: TextDecoration.combine(List.from({TextDecoration.none})))),),
                CircularProgressIndicator()
              ],
            ),
          ),
        );
    }

    
}
