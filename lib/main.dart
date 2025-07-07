import 'package:flutter/material.dart';
import 'package:mobile_gaya_ant/bluetoothmodule.dart';
import 'visuals/pages/menupage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
 
  runApp(
    ChangeNotifierProvider
    (
      create: (_) => BluetoothModule(),
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formigueiro Do ISPGAYA',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), 
        Locale('pt'), 
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFB923C)),
      ),
      home: const MenuPage(title: 'Controlo do Robô Formiga'),
    );
  }
}
