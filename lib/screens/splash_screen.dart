import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:violence_app/navigationBar/bottom_bar.dart';
import 'package:violence_app/screens/beranda_screen.dart';
import 'package:violence_app/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<bool> _checkIfOnBoardingViewed() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool('onBoard') ?? false;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      bool onBoardingViewed = await _checkIfOnBoardingViewed();
      if (onBoardingViewed) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const BottomNavigationWidget()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const OnboardingScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/splash_image.png', width: 200, height: 200,),
          ],
        ),
      ),
    );
  }
}
