import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kidz_quiz/core/constants.dart';
import 'package:kidz_quiz/core/quiz_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'animation.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key, required this.level, required this.quizType});
  final String level;
  final String quizType;

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  final touchSound = TouchSound();
  int _currentQuestion = 0;
  late int _level;
  int score = 0;
  Timer? blinkingTimer;
  List<Color> buttonColors = List.generate(4, (_) => kThemeColor);
  int isSelected = -1;

  @override
  void initState() {
    super.initState();
    getLevel();
  }

  void getLevel() {
    setState(() {
      _level = int.parse(widget.level);
    });
  }

  Future<void> saveScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedList = prefs.getStringList(widget.quizType);
    savedList?[_level - 1] = score.toString();
    prefs.setStringList(widget.quizType, savedList!);
  }

  void nextQuestion(int answer) {
    if (quizData[widget.quizType]["Level $_level"][_currentQuestion]["answer"]
            .toString() ==
        quizData[widget.quizType]["Level $_level"][_currentQuestion]["options"]
                [answer]
            .toString()) {
      touchSound.correctAnswer();
      score++;
      startBlinking(answer, Colors.green);
    } else {
      touchSound.wrongAnswer();
      startBlinking(answer, Colors.red);
    }
  }

  void levelCompleted() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RiveLevelCompletion(
          score: score,
          level: _level.toString(),
          quizType: widget.quizType,
        ),
      ),
    );

    if (result == 'restart') {
      setState(() {
        _currentQuestion = 0;
        score = 0;
      });
    } else if (result == 'next level') {
      setState(() {
        _currentQuestion = 0;
        score = 0;
        _level = _level + 1;
      });
    } else {}
  }

  void startBlinking(int buttonIndex, Color bColor) async {
    const blinkDuration = Duration(milliseconds: 300); // Blink every 500ms
    const stopBlinkingAfter =
        Duration(milliseconds: 1500); // Stop after 3 seconds

    // Start blinking
    blinkingTimer = Timer.periodic(blinkDuration, (timer) {
      setState(() {
        buttonColors[buttonIndex] =
            buttonColors[buttonIndex] == kThemeColor ? bColor : kThemeColor;
      });
    });

    // Stop blinking after some time
    await Future.delayed(stopBlinkingAfter, () {
      blinkingTimer?.cancel(); // Stop the timer
      setState(() {
        buttonColors[buttonIndex] = kThemeColor;
        isSelected = -1;
      }); // Reset to original color
    });
  }

  @override
  void dispose() {
    blinkingTimer?.cancel(); // Always cancel the timer to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double childAspectRatio;
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight > 600) {
      childAspectRatio = 2.5;
    } else {
      childAspectRatio = 3.2;
    }
    return Container(
      decoration: kContainerDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: kThemeColor,
          title: Text("LEVEL $_level"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Question ${_currentQuestion + 1}/5',
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(1, 1),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60)),
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: widget.quizType == "Alphabet Quiz"
                          ? Center(
                              child: Text(
                                quizData[widget.quizType]["Level $_level"]
                                        [_currentQuestion]["question"]
                                    .toString(),
                                style: kQuestionTextStyle,
                              ),
                            )
                          : Image(
                              image: AssetImage(
                                  'assets/images/${widget.quizType}/${quizData[widget.quizType]["Level $_level"][_currentQuestion]["answer"].toString()}.png'),
                            ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: GridView.count(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                  childAspectRatio: childAspectRatio,
                  children: List.generate(
                    4,
                    (index) => ElevatedButton(
                      onPressed: isSelected != -1
                          ? null
                          : () async {
                              isSelected = index;
                              if (_currentQuestion < 4) {
                                nextQuestion(index);
                                await Future.delayed(
                                    const Duration(milliseconds: 1500));
                                setState(() {
                                  _currentQuestion++;
                                });
                              } else {
                                nextQuestion(index);
                                await saveScore(score);
                                await Future.delayed(
                                    const Duration(milliseconds: 1500));
                                levelCompleted();
                              }
                            },
                      style: index % 2 == 0
                          ? kQuizLeftButton.copyWith(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  buttonColors[index]))
                          : kQuizRightButton.copyWith(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  buttonColors[index])),
                      child: Center(
                        child: Text(
                          quizData[widget.quizType]["Level $_level"]
                                  [_currentQuestion]["options"][index]
                              .toString(),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
