import 'package:flutter/material.dart';
import 'package:kidz_quiz/core/constants.dart';
import 'package:kidz_quiz/presentation/screens/quiz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class GameLevels extends StatefulWidget {
  const GameLevels({super.key, required this.quizName});

  final String quizName;

  @override
  State<GameLevels> createState() => _GameLevelsState();
}

class _GameLevelsState extends State<GameLevels> {
  Future<void> _initializeDefaultScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the key 'quizName' exists
    bool keyExists = prefs.containsKey(widget.quizName);

    // If the key does not exist, set the default score
    if (!keyExists) {
      prefs.setStringList(widget.quizName, List.generate(10, (index) => '0'));
    }
  }

  Future<String> getScore(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList(widget.quizName);

    return items?[index] ?? '0';
  }

  @override
  void initState() {
    super.initState();
    _initializeDefaultScore();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;

    if (screenWidth >= 768) {
      crossAxisCount = 4; // Adjust the number of columns for larger screens
    } else if (screenWidth >= 480) {
      crossAxisCount = 3; // Adjust the number of columns for medium screens
    } else {
      crossAxisCount =
          2; // Adjust the number of columns for small screens (e.g., mobile)
    }

    return Container(
      decoration: kContainerDecoration,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF01BFE3),
          title: Text(
            widget.quizName,
            style: kTextStyle,
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimationLimiter(
            child: GridView.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
              crossAxisCount: crossAxisCount,
              children: List.generate(
                10,
                (index) => AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 800),
                  columnCount: crossAxisCount,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: FutureBuilder<String>(
                        future: getScore(index),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            String currentScore =
                                snapshot.data ?? "No data available";
                            String imagePath;
                            if (int.parse(currentScore) == 5) {
                              imagePath = "threeStar";
                            } else if (int.parse(currentScore) > 2) {
                              imagePath = "twoStar";
                            } else if (int.parse(currentScore) > 0) {
                              imagePath = "oneStar";
                            } else {
                              imagePath = "zeroStar";
                            }
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/starImages/$imagePath.png'),
                                    fit: BoxFit.contain),
                              ),
                              child: InkWell(
                                onTap: () {
                                  TouchSound().playButtonSound();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Quiz(
                                        level: '${index + 1}',
                                        quizType: widget.quizName,
                                      ),
                                    ),
                                  );
                                },
                                splashColor: kThemeColor,
                                radius: 30,
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(fontSize: 35),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
