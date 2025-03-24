import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:leaderboard/core/config/enums.dart';
import 'package:leaderboard/features/onboarding/data/repository/auth_repository.dart';

class AuthenticationProvider extends ChangeNotifier {
  final authRepo = AuthRepositoryImpl();

  ViewState viewState = ViewState.idle;

  Future<void> googleSignIn() async {
    try {
      final authResult = await authRepo.signInWithGoogle();

      if (authResult.credential == null) {
        viewState = ViewState.error;
        notifyListeners();
        return;
      } else {
        viewState = ViewState.success;
        if (authResult.user != null) {
          _updateNewUser(authResult.user?.uid ?? "", authResult.user?.displayName ?? "");
        }
        notifyListeners();
        return;
      }
    } catch (e) {
      log("Error occured :: $e");
      viewState = ViewState.error;
      notifyListeners();
      return;
    }
  }

  Future<void> appleSignIn() async {
    try {
      final authResult = await authRepo.signInWithApple();

      if (authResult.credential == null) {
        viewState = ViewState.error;
        notifyListeners();
        return;
      } else {
        viewState = ViewState.success;
        if (authResult.user != null) {
          _updateNewUser(authResult.user?.uid ?? "", authResult.user?.displayName ?? "");
        }
        notifyListeners();
        return;
      }
    } catch (e) {
      log("Error occured :: $e");
      viewState = ViewState.error;
      notifyListeners();
      return;
    }
  }

  Future<void> _updateNewUser(String userId, String username) async {
    final userBoardRef = FirebaseFirestore.instance.collection('user_board').doc(userId);
    final userDoc = await userBoardRef.get();

    if (userDoc.exists) {
      await userBoardRef.update({'username': username});
    } else if (!userDoc.exists) {
      await userBoardRef.set({
        'userId': userId,
        'username': username,
        'score': 0,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }
}
