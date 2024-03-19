import 'package:flutter/material.dart';
import 'package:kidz_quiz/core/constants.dart';
import 'package:rive/rive.dart';
import 'package:cool_alert/cool_alert.dart';

import '../../core/quiz_data.dart';

extension _TextExtension on Artboard {
  TextValueRun? textRun(String name) => component<TextValueRun>(name);
}

class RiveLevelCompletion extends StatefulWidget {
  const RiveLevelCompletion(
      {super.key,
      required this.level,
      required this.score,
      required this.quizType});

  final String level;
  final int score;
  final String quizType;

  @override
  State<RiveLevelCompletion> createState() => _RiveLevelCompletionState();
}

class _RiveLevelCompletionState extends State<RiveLevelCompletion> {
  late RiveAnimationController _controller;
  SMIInput<double>? userScore;

  @override
  void initState() {
    super.initState();
    TouchSound().levelComplete();
    _controller = OneShotAnimation(
      'idle',
    );
  }

  void _onRiveInit(Artboard artboard) {
    final textScore = artboard.textRun('score')!; // find text run named "MyRun"
    final textLevel = artboard.textRun('level')!;
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    textScore.text = '${widget.score}/5';
    textLevel.text = "Level ${widget.level}";
    artboard.addController(controller!);
    userScore = controller.findInput<double>('levelScore') as SMINumber;
    userScore?.value = widget.score.toDouble();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Container(
        decoration: kContainerDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: height * .5,
                  child: RiveAnimation.asset(
                    'assets/rive/levelComplete.riv',
                    fit: BoxFit.contain,
                    onInit: _onRiveInit,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                widget.score > 0
                    ? InkWell(
                        onTap: () {
                          Navigator.pop(context, 'next level');
                        },
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: SizedBox(
                          height: height * .12,
                          width: width * .6,
                          child: const RiveAnimation.asset(
                            'assets/rive/nextLevel.riv',
                            stateMachines: ['State Machine 1'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          Navigator.pop(context, 'restart');
                        },
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: SizedBox(
                          height: height * .12,
                          width: width * .7,
                          child: const RiveAnimation.asset(
                            'assets/rive/retry.riv',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                InkWell(
                  onTap: () {
                    CoolAlert.show(
                      context: context,
                      title: "Answers",
                      type: CoolAlertType.custom,
                      widget: Column(
                        children: List.generate(
                          5,
                          (index) {
                            final itemName = quizData[widget.quizType]
                                    ["Level ${widget.level}"][index]["answer"]
                                .toString();
                            return Card(
                              child: ListTile(
                                leading: Image.asset(
                                  "assets/images/${widget.quizType}/$itemName.png",
                                ),
                                title: Text(itemName),
                                titleTextStyle: const TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: SizedBox(
                    height: height * .12,
                    width: width * .6,
                    child: const RiveAnimation.asset(
                      'assets/rive/answer.riv',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: SizedBox(
                    height: height * .12,
                    width: width * .6,
                    child: const RiveAnimation.asset(
                      'assets/rive/home.riv',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
