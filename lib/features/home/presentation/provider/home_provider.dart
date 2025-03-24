import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:leaderboard/features/leaderboard/data/repository/user_board_repository.dart';

class HomeProvider extends ChangeNotifier {
  final userBoardRepo = UserBoardRepositoryImpl();

  int _counter = 0;
  int get counter => _counter;
  set counter(int newCounter) {
    _counter = newCounter;
    notifyListeners();
  }

  Future<void> getScore() async {
    try {
      final score = await userBoardRepo.getUserScore();
      counter = score;
    } catch (e) {
      log("Error updating score : $e");
    }
  }

  incrementCounter() {
    _counter++;
    notifyListeners();
  }
}
