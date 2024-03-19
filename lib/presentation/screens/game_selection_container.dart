import 'package:flutter/material.dart';
import '../../core/constants.dart';
import 'game_levels.dart';

class GameContainer extends StatelessWidget {
  const GameContainer(
      {super.key, required this.imageIndex, required this.quiz});
  final int imageIndex;
  final String quiz;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          'assets/images/game_selection_image$imageIndex.png',
          fit: BoxFit.cover,
        ),
        ElevatedButton(
          onPressed: () {
            TouchSound().playButtonSound();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GameLevels(
                  quizName: quiz,
                ),
              ),
            );
          },
          style: kHomeScreenButton,
          child: Text(
            quiz,
            style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontFamily: "ChailceNogginRegular"),
          ),
        ),
      ],
    );
  }
}
