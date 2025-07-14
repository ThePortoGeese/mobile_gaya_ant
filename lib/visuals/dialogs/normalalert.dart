import 'package:flutter/material.dart';

//Generic alert

class Normalalert extends StatelessWidget {

  const Normalalert({
    super.key, 
    required this.bodyText,
    required this.titleText,
    this.titleStyle 
  });
  final String bodyText;
  final String titleText;
  final TextStyle? titleStyle;
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
        title: Text(titleText, style: titleStyle),
        content: Text(bodyText),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text("OK")),]
        );
    }

    
}
