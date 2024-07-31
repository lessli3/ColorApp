import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:color_app/home.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

//Se define la clase del Splash
class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    //Se genera el splash
    return AnimatedSplashScreen(
      //Animacion utilizada desde /img
        splash: Lottie.asset('img/splashcolor.json'),
        //Redirige al home cuando termine el splash
        nextScreen: Home(),
        duration: 2200,
      splashIconSize: 400,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
