import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_gaya_ant/visuals/pages/menupage.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SplashScreenRotation(),
      splashIconSize: 200,
      nextScreen: MenuPage(),
      pageTransitionType: PageTransitionType.bottomToTop,
      splashTransition: SplashTransition.slideTransition,
    );
  }
}

class SplashScreenRotation extends StatefulWidget  {
  const SplashScreenRotation({
    super.key,
  }); 

  @override
  State<SplashScreenRotation> createState() => _SplashScreenRotationState();
}

class _SplashScreenRotationState extends State<SplashScreenRotation> with SingleTickerProviderStateMixin {
    late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    super.initState();
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end:1.0).animate(_controller),
      child: Image.asset('assets/splashScreenLogo.png'),
    );
  }
}