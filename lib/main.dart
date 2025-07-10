import 'package:flutter/material.dart';
import 'package:mobile_gaya_ant/models/localenotifer.dart';
import 'package:mobile_gaya_ant/visuals/pages/splashscreen.dart';
import 'package:mobile_gaya_ant/models/bluetoothmodule.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
 
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return 
      Consumer<LocaleNotifer>(
      builder: (context, notifier, child) {
        debugPrint(notifier.locale.toString());
        return MaterialApp(
          title: 'Formigueiro Do ISPGAYA',
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
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
