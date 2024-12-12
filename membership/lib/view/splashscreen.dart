import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'auth/login.dart';
import 'dart:ui' as ui;

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the next screen after a delay
    Future.delayed(const Duration(milliseconds: 5000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(46, 49, 146, 1),
            Color.fromRGBO(27, 255, 255, 1),
          ],
        )),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 120.0),
              child: Center(
                child: Text(
                  "MyMemberLink",
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = ui.Gradient.linear(
                        const Offset(0, 80),
                        const Offset(100, 20),
                        <Color>[
                          const Color.fromRGBO(117, 120, 223, 1),
                          const Color.fromRGBO(27, 255, 255, 1),
                        ],
                      ),
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black12.withOpacity(0.3),
                        offset: const Offset(5, 10.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 80),
              child: SizedBox(
                width: 400,
                height: 300,
                child: Lottie.asset(
                  "assets/animation.json",
                  repeat: false,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: LoadingAnimationWidget.twistingDots(
                leftDotColor: const Color.fromARGB(255, 18, 18, 185),
                rightDotColor: const Color.fromARGB(255, 231, 19, 19),
                size: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
