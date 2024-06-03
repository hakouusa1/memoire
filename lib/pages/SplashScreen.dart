import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'auth_page.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Need Serve",
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 99, 99, 99),
              ),
            ),
            SizedBox(height: 16),
            Flexible(
              child: Lottie.asset('assets/images/animation.json'),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                "Bienvenue Dans notre application, ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 140, 139, 139),
                ),
              ),
            ),
          ],
        ),
        nextScreen: authPage(),
        splashTransition: SplashTransition.fadeTransition,
        duration: 3000,
        splashIconSize: 350,
        pageTransitionType: PageTransitionType.bottomToTop,
        animationDuration: const Duration(seconds: 2),
        backgroundColor: Colors.white,
      ),
    );
  }
}
