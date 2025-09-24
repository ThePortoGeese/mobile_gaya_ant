import 'package:flutter/material.dart';
import 'package:ispgaya_ant/l10n/app_localizations.dart';

class WelcomePopUp extends StatefulWidget {
  const WelcomePopUp({super.key});
  @override
  State<WelcomePopUp> createState() => _WelcomePopUpState();
}

//THIS IS A POPUP that introduces the user to the app's functionalities

class _WelcomePopUpState extends State<WelcomePopUp> {
  late List<String> displayText;
  int currentText = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //collection of texts that are presented to the user
    //easier to do it this way
    displayText = [AppLocalizations.of(context)!.welcomeMessage1, AppLocalizations.of(context)!.welcomeMessage2, AppLocalizations.of(context)!.welcomeMessage3, AppLocalizations.of(context)!.welcomeMessage4];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    
  }

    @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(10),
        width: 300,
        height:300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(AppLocalizations.of(context)!.welcome, textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            Divider(thickness: 5, ),
            SingleChildScrollView(child: Text(displayText[currentText])),
            Spacer(),
            Row( 
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Visibility(visible: currentText!=0,child: ElevatedButton(onPressed: () {
                  //This button is only visible when the current text isnt the first
                  //It decreases the text num when clicked

                  setState(() {
                    currentText--;
                  });
                }, child: Icon(Icons.navigate_before))
                ),
                Text("${currentText+1}/${displayText.length}"),
                ElevatedButton(onPressed: () {
                  //Pops the dialog when current text is the last

                  if(currentText + 1 == displayText.length){
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      currentText++;  
                    });
                  }
                  }, child: (currentText +1 != displayText.length) ? Icon(Icons.navigate_next) : Icon(Icons.done)),
              ],   
            ),
          ]
        ),
      ),
    );
  }
}