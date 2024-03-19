import 'package:flutter/material.dart';
import '../../core/constants.dart';
import 'game_selection_container.dart';

class GameSelection extends StatefulWidget {
  const GameSelection({super.key});

  @override
  State<GameSelection> createState() => _GameSelectionState();
}

class _GameSelectionState extends State<GameSelection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/background_image.jpg'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF01BFE3),
          title: const Text(
            "Quiz Selection",
            style: kTextStyle,
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: GridView.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: .7,
            crossAxisCount: 2,
            children: List.generate(
              4,
              (index) {
                return GameContainer(
                  imageIndex: index,
                  quiz: kGameQuiz[index],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
