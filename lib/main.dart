import 'package:flutter/material.dart';
import 'views/pages/menupage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formigueiro Do ISPGAYA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFB923C)),
      ),
      home: const MenuPage(title: 'Controlo do Robô Formiga'),
    );
  }
}
