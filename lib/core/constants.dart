import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// ----------------> Buttons <----------------
ButtonStyle kHomeScreenButton = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF01BFE3), //01BFE3 014872
  elevation: 4,
  side: const BorderSide(
    width: 2,
    color: Colors.white,
  ),
);

ButtonStyle kQuizLeftButton = ElevatedButton.styleFrom(
  side: const BorderSide(
    width: 2,
    color: Colors.white,
  ),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(30),
      bottomRight: Radius.circular(30),
    ), // Adjust the radius as needed
  ),
);

ButtonStyle kQuizRightButton = ElevatedButton.styleFrom(
  side: const BorderSide(
    width: 2,
    color: Colors.white,
  ),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30),
      bottomLeft: Radius.circular(30),
    ), // Adjust the radius as needed
  ),
);

// ----------------> Decorations <----------------
BoxDecoration kInkDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(25),
  boxShadow: [
    BoxShadow(
      color: kThemeColor.withOpacity(0.3),
      spreadRadius: 5,
      blurRadius: 7,
      offset: const Offset(1, 1),
    ),
  ],
);

const kContainerDecoration = BoxDecoration(
  image: DecorationImage(
      image: AssetImage('assets/images/background_image.jpg'),
      fit: BoxFit.cover),
);

const kThemeColor = Color(0xFF01BFE3);
const kTextStyle = TextStyle(
    fontSize: 20, color: Colors.white, fontFamily: "ChailceNogginRegular");
const kLevelCompleteTextStyle = TextStyle(
    fontSize: 35, color: Colors.white, fontFamily: "ChailceNogginRegular");

const kQuestionTextStyle = TextStyle(
  fontSize: 30,
  color: Colors.black,
);

// ----------------> Lists <----------------
const List kGameQuiz = [
  'Vegetables Quiz',
  'Math Quiz',
  'Technology Quiz',
  'Alphabet Quiz'
];

const List<String> kQuizLevelStar = [
  "zeroStar",
  "oneStar",
  "twoStar",
  "threeStar"
];

// ----------------> Classes <----------------
class TouchSound {
  final AudioPlayer _player = AudioPlayer();
  void playButtonSound() {
    _player.play(AssetSource('sounds/main_click_sound.wav'));
  }

  void correctAnswer() {
    _player.play(AssetSource('sounds/correct_answer_sound.wav'));
  }

  void wrongAnswer() {
    _player.play(AssetSource('sounds/wrong_answer_sound.wav'));
  }

  void levelComplete() {
    _player.play(AssetSource('sounds/level_completion_sound.wav'));
  }
}
