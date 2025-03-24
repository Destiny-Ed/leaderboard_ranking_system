import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:leaderboard/core/config/enums.dart';
import 'package:leaderboard/features/leaderboard/data/repository/user_board_repository.dart';

class LeaderboardProvider extends ChangeNotifier {
  final userBoardRepo = UserBoardRepositoryImpl();

  ViewState viewState = ViewState.idle;

  LeaderBoardFilter _selectedFilter = LeaderBoardFilter.all;
  LeaderBoardFilter get selectedFilter => _selectedFilter;
  set selectedFilter(LeaderBoardFilter newFilter) {
    _selectedFilter = newFilter;
    notifyListeners();
  }

  Future<void> updateScore(int newScore) async {
    viewState = ViewState.busy;
    notifyListeners();
    try {
      final result = await userBoardRepo.updateUserScore(newScore);
      viewState = (result ? ViewState.success : ViewState.error);
      notifyListeners();
    } catch (e) {
      log("Error updating score : $e");
      viewState = ViewState.error;
      notifyListeners();
    }
  }

  Stream<QuerySnapshot> getLeaderboardStream() {
    return userBoardRepo.getLeaderBoardData(_selectedFilter);
  }
}
