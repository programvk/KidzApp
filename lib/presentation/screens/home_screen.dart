import 'package:flutter/material.dart';
import 'package:kidz_quiz/core/constants.dart';
import 'package:kidz_quiz/presentation/screens/game_selection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final touchSound = TouchSound();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kThemeColor, Colors.blueAccent, Colors.white],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                child: Image(
                  image: AssetImage('assets/images/home_background.png'),
                ),
              ),
              Ink(
                decoration: kInkDecoration,
                child: ElevatedButton(
                  onPressed: () {
                    touchSound.playButtonSound();
                    Future.delayed(const Duration(milliseconds: 500));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameSelection(),
                      ),
                    );
                  },
                  style: kHomeScreenButton,
                  child: const Text(
                    'Start',
                    style: kTextStyle,
                  ),
                ),
              ),
              // const SizedBox(height: 15),
              // Ink(
              //   decoration: kInkDecoration,
              //   child: ElevatedButton(
              //       onPressed: () {
              //         touchSound.playButtonSound();
              //       },
              //       style: kHomeScreenButton,
              //       child: const Text(
              //         'Load',
              //         style: kTextStyle,
              //       )),
              // ),
              const SizedBox(height: 15),
              Ink(
                decoration: kInkDecoration,
                child: ElevatedButton(
                    onPressed: () {
                      touchSound.playButtonSound();
                    },
                    style: kHomeScreenButton,
                    child: const Text(
                      'Credit',
                      style: kTextStyle,
                    )),
              ),
              const SizedBox(height: 15),
              Ink(
                decoration: kInkDecoration,
                child: ElevatedButton(
                    onPressed: () {
                      touchSound.playButtonSound();
                    },
                    style: kHomeScreenButton,
                    child: const Text(
                      'Quit',
                      style: kTextStyle,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
