import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leaderboard/core/extensions.dart';

abstract class UserBoardRepository {
  Future<bool> updateUserScore(int newScore);
  Stream<QuerySnapshot> getLeaderBoardData(LeaderBoardFilter filter);
}

class UserBoardRepositoryImpl implements UserBoardRepository {
  final _leaderboardRef = FirebaseFirestore.instance.collection('user_board');

  final _userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Stream<QuerySnapshot> getLeaderBoardData(LeaderBoardFilter filter) {
    if (filter == LeaderBoardFilter.today) {
      final startOfDay = DateTime.now().subtract(Duration(hours: DateTime.now().hour));
      return _leaderboardRef
          .where("timestamp", isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .orderBy("score", descending: true)
          .snapshots();
    } else if (filter == LeaderBoardFilter.weekly) {
      final startOfWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
      return _leaderboardRef
          .where("timestamp", isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
          .orderBy("score", descending: true)
          .snapshots();
    }
    return _leaderboardRef.orderBy("score", descending: true).snapshots();
  }

  @override
  Future<bool> updateUserScore(int newScore) async {
    final userDoc = await _leaderboardRef.where("userId", isEqualTo: _userId).get();

    if (userDoc.docs.isNotEmpty) {
      final docId = userDoc.docs.first.id;
      await _leaderboardRef.doc(docId).update({'score': newScore, 'timestamp': FieldValue.serverTimestamp()});
      return true;
    }
    return false;
  }
}
