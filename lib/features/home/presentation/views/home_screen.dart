import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leaderboard/core/config/enums.dart';
import 'package:leaderboard/features/home/presentation/provider/home_provider.dart';
import 'package:leaderboard/features/leaderboard/presentation/provider/leaderboard_provider.dart';
import 'package:leaderboard/features/leaderboard/presentation/views/leaderboard_screen.dart';
import 'package:leaderboard/features/onboarding/data/repository/auth_repository.dart';
import 'package:leaderboard/features/onboarding/presentation/views/splash_screen.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().getScore();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text("Hi, ${FirebaseAuth.instance.currentUser?.displayName}"),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthRepositoryImpl().logout();
              if (context.mounted) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen()));
              }
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Current Score'),
            Text('${context.watch<HomeProvider>().counter}', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer<LeaderboardProvider>(
                  builder: (context, leaderBoardState, child) {
                    return ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.blue),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),

                      onPressed: () async {
                        await leaderBoardState.updateScore(context.read<HomeProvider>().counter);

                        if (leaderBoardState.viewState == ViewState.error) {
                          log("Error occured while updating score");
                          return;
                        }
                        log("score updated successfully");
                      },
                      child: Text(leaderBoardState.viewState == ViewState.busy ? "loading..." : "Save New Score"),
                    );
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LeaderboardScreen()));
                  },
                  child: Text("View LeaderBoard >> "),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: context.read<HomeProvider>().incrementCounter,
        tooltip: 'Increment',
        label: Text("Increment Score"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
