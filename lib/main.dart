import 'package:flutter/material.dart';
import 'package:ispgaya_ant/models/localenotifer.dart';
import 'package:ispgaya_ant/visuals/pages/splashscreen.dart';
import 'package:ispgaya_ant/models/bluetoothmodule.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //just makes the providers for the bluetooth module and the locale notifier
  runApp(
    ChangeNotifierProvider
    (
      create: (_) => BluetoothModule(),
      child:  ChangeNotifierProvider
      (
        create: (_) => LocaleNotifer(),
        child: const MyApp()
      )
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return 
      Consumer<LocaleNotifer>(
      builder: (context, notifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Formigueiro Do ISPGAYA',
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          //sets the app's locale based on notifier's locale value
          locale: notifier.locale,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFB923C)),
          ),
          home: SplashScreen(),
        );
      }
    );
  }
}
