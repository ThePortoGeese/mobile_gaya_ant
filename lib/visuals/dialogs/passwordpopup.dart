import 'package:flutter/material.dart';
import 'package:mobile_gaya_ant/l10n/app_localizations.dart';

class PasswordPopUp extends StatefulWidget {
  const PasswordPopUp({super.key});
  @override
  State<PasswordPopUp> createState() => _PasswordPopUpState();
}

class _PasswordPopUpState extends State<PasswordPopUp> {
  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  String retrieveText(){
    return _textEditingController.text;
  }

    @override
  Widget build(BuildContext context) {
  
    return Dialog(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(10),
        width: 300,
        height:200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(AppLocalizations.of(context)!.passwordNecessary, textAlign: TextAlign.center,),
            Divider(thickness: 5, ),
            Text(AppLocalizations.of(context)!.passwordNecessaryMessage),
            TextField(
              controller: _textEditingController,
              autocorrect: false,
              autofocus: true,
            ),
            ElevatedButton(onPressed: () => Navigator.pop(context, retrieveText()), child: Text("OK"))
          ],
      
      
        ),
      ),
    );
  }
}