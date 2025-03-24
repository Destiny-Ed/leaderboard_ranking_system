import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:leaderboard/core/config/enums.dart';
import 'package:leaderboard/features/home/presentation/views/home_screen.dart';
import 'package:leaderboard/features/onboarding/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthenticationProvider>(
        builder: (context, authState, child) {
          return Stack(
            children: [
              if (authState.viewState == ViewState.busy) CircularProgressIndicator(),
              Center(
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
                      onPressed: () async {
                        await authState.googleSignIn();

                        if (authState.viewState == ViewState.error) {
                          log("Error occured while signing in : Google");
                          return;
                        }
                        if (!context.mounted) return;
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MyHomePage()));
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),

                      icon: Icon(Icons.apple, color: Colors.black),
                      label: Text(" Continue with Apple ", style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        await authState.appleSignIn();

                        if (authState.viewState == ViewState.error) {
                          log("Error occured while signing in : Apple");
                          return;
                        }
                        if (!context.mounted) return;
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MyHomePage()));
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
