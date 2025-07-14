

import 'package:flutter/material.dart';




//this is the easiest changenotifier for the app's locale, it is that simple
class LocaleNotifer extends ChangeNotifier{
  
  Locale? _locale = WidgetsBinding.instance.platformDispatcher.locale;
  Locale? get locale => _locale;
  void setLocale(Locale local){
    _locale = local;
    notifyListeners();
  }
}