import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leaderboard/features/home/presentation/views/home_screen.dart';
import 'package:leaderboard/features/onboarding/presentation/views/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Leaderboard system", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))),
    );
  }

  void navigate() {
    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;

      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MyHomePage()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AuthScreen()));
      }
    });
  }
}
