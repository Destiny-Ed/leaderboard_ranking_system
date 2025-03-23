import 'package:flutter/material.dart';
import 'package:leaderboard/features/home/presentation/views/home_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),

            Text("Continue with Us", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Spacer(),

            ElevatedButton.icon(
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),
              icon: Icon(Icons.g_mobiledata, color: Colors.red),
              label: Text("Continue with Google", style: TextStyle(color: Colors.white)),
              onPressed: () {},
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),

              icon: Icon(Icons.apple, color: Colors.black),
              label: Text(" Continue with Apple ", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MyHomePage()));
              },
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
