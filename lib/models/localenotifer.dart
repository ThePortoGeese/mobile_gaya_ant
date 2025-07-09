

import 'package:flutter/material.dart';

class LocaleNotifer extends ChangeNotifier{
  
  Locale? _locale = WidgetsBinding.instance.platformDispatcher.locale;
  Locale? get locale => _locale;
  void setLocale(Locale local){
    _locale = local;
    notifyListeners();
  }
}