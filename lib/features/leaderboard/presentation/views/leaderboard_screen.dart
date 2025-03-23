import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:leaderboard/core/config/constants.dart';
import 'package:leaderboard/core/extensions.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<String, List<Map<String, dynamic>>> dummyData = {
    "today": [
      {"username": "Alice", "score": 2500},
      {"username": "Bob", "score": 2800},
      {"username": "David", "score": 1700},
      {"username": "Charlie", "score": 2600},
      {"username": "Eve", "score": 1500},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: LeaderBoardFilter.values.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: LeaderBoardFilter.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Leaderboard', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
          bottom: TabBar(
            controller: _tabController,
            tabs: LeaderBoardFilter.values.map((filter) => Tab(text: filter.name)).toList(),
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: TabBarView(
            controller: _tabController,
            children:
                LeaderBoardFilter.values.map((filter) {
                  return LeaderboardList(users: dummyData[filter.name] ?? []);
                }).toList(),
          ),
        ),
      ),
    );
  }
}

class LeaderboardList extends StatelessWidget {
  final List<Map<String, dynamic>> users;

  const LeaderboardList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return Center(child: Text('No leaderboard data available.'));
    }

    // Sort users by highest score
    final sortedUsers = List<Map<String, dynamic>>.from(users)..sort((a, b) => b['score'].compareTo(a['score']));

    final topUsers = sortedUsers.take(3).toList();
    final remainingUsers = sortedUsers.skip(3).toList();

    return Column(
      children: [
        _PodiumTopThreeUsers(topUsers: topUsers),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: remainingUsers.length,
            itemBuilder: (context, index) {
              var user = remainingUsers[index];
              return _LeaderboardTile(
                rank: index + 4,
                username: user['username'],
                score: user['score'],
                imageUrl: avatar(user["username"]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PodiumTopThreeUsers extends StatelessWidget {
  final List<Map<String, dynamic>> topUsers;

  const _PodiumTopThreeUsers({required this.topUsers});

  @override
  Widget build(BuildContext context) {
    if (topUsers.length < 3) return SizedBox.shrink();

    return FadeIn(
      duration: Duration(milliseconds: 500),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue.shade200, Colors.blue.shade600]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TopUserPodium(
              rank: 2,
              username: topUsers[1]['username'],
              score: topUsers[1]['score'],
              imageUrl: avatar(topUsers[1]['username']),
              height: 120,
            ),
            SizedBox(width: 10),
            _TopUserPodium(
              rank: 1,
              username: topUsers[0]['username'],
              score: topUsers[0]['score'],
              imageUrl: avatar(topUsers[0]['username']),

              height: 150,
              isChampion: true,
            ),
            SizedBox(width: 10),
            _TopUserPodium(
              rank: 3,
              username: topUsers[2]['username'],
              score: topUsers[2]['score'],
              imageUrl: avatar(topUsers[2]['username']),

              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopUserPodium extends StatelessWidget {
  final int rank;
  final String username;
  final int score;
  final String imageUrl;
  final double height;
  final bool isChampion;

  const _TopUserPodium({
    required this.rank,
    required this.username,
    required this.score,
    required this.imageUrl,
    required this.height,
    this.isChampion = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isChampion
            ? BounceInDown(
              duration: Duration(milliseconds: 700),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Icon(Icons.emoji_events, color: Colors.amber, size: 40),
              ),
            )
            : SizedBox.shrink(),

        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(isChampion ? 10 : 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: isChampion ? Colors.yellow : Colors.white, width: 3),
          ),
          child: CircleAvatar(
            radius: isChampion ? 40 : 30,
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(username, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        Text("Score: $score", style: TextStyle(color: Colors.white70)),
        SizedBox(height: 10),
        Container(
          height: height,
          width: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isChampion ? Colors.yellow : Colors.grey.shade300,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Text("#$rank", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
      ],
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  final int rank;
  final String username;
  final int score;
  final String imageUrl;

  const _LeaderboardTile({required this.rank, required this.username, required this.score, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(radius: 25, backgroundImage: NetworkImage(imageUrl), backgroundColor: Colors.grey.shade300),
      title: Text(username, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      subtitle: Text("Score: $score"),
      trailing: Text("#$rank", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
    );
  }
}
