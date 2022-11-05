import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_quiz_game/utils/components.dart';
import 'package:math_quiz_game/utils/constants.dart';
import 'package:math_quiz_game/utils/quiz_brain.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

import 'home_screen.dart';

QuizBrain _quizBrain = QuizBrain([]);
int _score = 0;
int _highest = 0;
double _value = 1;
int _falseCounter = 0;
int _totalNumberOfQuiz = 0;
String isCorrect = '';

class QuizScreen extends StatefulWidget {
  static const String id = 'mixed_operation_screen';
  QuizScreen({required List<String> list}){
    _quizBrain = QuizBrain(list);
  }

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  late Timer _timer;
  int _totalTime = 0;
  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() async {
    _quizBrain.makeQuiz();
    startTime();
    _value = 1;
    _score = 0;
    _falseCounter = 0;
    _totalNumberOfQuiz = 0;
    isCorrect = 'Answer ?';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _highest = preferences.getInt('highest') ?? 0;
  }

  void startTime() {
    const speed = Duration(milliseconds: 100);
    _timer = Timer.periodic(speed, (timer) {
      if (_value > 0) {
        setState(() {
          _value > 0.005 ? _value -= 0.005 : _value = 0;
          _totalTime = (_value * 20 + 1).toInt();
        });
      } else {
        setState(() {
          _totalTime = 0;
          showMyDialog();
          _timer.cancel();
        });
      }
    });
  }



  Future<void> showMyDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              backgroundColor: const Color(0xFFF3896C),
              title: const FittedBox(
                child: Text(
                  'GAME OVER',
                  style: kDialogueBoxTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              titlePadding: const EdgeInsets.all(15.0),
              content: Text(
                'Score : $_score / $_totalNumberOfQuiz',
                style: kScore,
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                      // onPressed: () => SystemNavigator.pop(),
                  // onPressed: () => Navigator.pop(context),
                  onPressed: ()=> Navigator.pushNamed(context, HomeScreen.id),
                  child: const Text(
                    'EXIT',
                    style: kDialogueBox,
                    textAlign: TextAlign.left,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    startGame();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'PLAY AGAIN',
                    style: kDialogueBox,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget showAnswerStatus() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: const Color(0xFF99CCE7),
      height: 50.0,
      width: 150,
      alignment: Alignment.center,
      child: Text(
        '$isCorrect',
        style: const TextStyle(
          fontSize: 30.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade500,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF11161E),
              Color(0xFF072765),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ScoreIndicator(),
              QuestionBox(questionString: _quizBrain.quizQuestionString),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: showAnswerStatus()),
                  CircularPercentIndicator(
                    radius: 40.0,
                    lineWidth: 8.0,
                    percent: _value,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: _value > 0.6
                        ? Colors.green
                        : _value > 0.3
                            ? Colors.yellow
                            : Colors.red,
                    center: Text(
                      '$_totalTime',
                      style: kPercentText,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OptionBox(option: _quizBrain.possibleOption[0]),
                  OptionBox(option: _quizBrain.possibleOption[1]),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OptionBox(option: _quizBrain.possibleOption[2]),
                  OptionBox(option: _quizBrain.possibleOption[3]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionBox extends StatelessWidget {
  OptionBox({super.key, required this.option});
  int option;

  void checkAnswer() async {
    if (option == _quizBrain.quizAnswer) {
      isCorrect = 'Correct!';
      _score++;
      _value >= 0.89 ? _value = 1 : _value += 0.1;
      if (_highest < _score) {
        _highest = _score;
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setInt('highest', _highest);
      }
      playSound(sound: 'sound/correct-choice.wav');
    } else {
      isCorrect = 'Wrong!';
      _falseCounter++;
      _value < 0.02 * _falseCounter
          ? _value = 0
          : _value -= 0.02 * _falseCounter;
      playSound(sound: 'sound/wrong-choice.wav');
    }
  }

  void playSound({required String sound}){
    final player = AudioPlayer();
    player.play(AssetSource(sound));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _totalNumberOfQuiz++;
        checkAnswer();
        _quizBrain.makeQuiz();
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blue,
        backgroundColor: const Color(0xFF9DA0EA),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: Colors.black,
        elevation: 20,
        animationDuration: const Duration(seconds: 1),
      ),
      child: Container(
        height: 100,
        width: 120,
        alignment: Alignment.center,
        child: Text(
          '$option',
          style: kOptionText,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ScoreIndicator extends StatelessWidget {
  const ScoreIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 10.0, right: 10.0, top: 30.0, bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'HIGHEST',
                style: kScoreTitle,
              ),
              Text(
                '$_highest',
                style: kScore,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'SCORE',
                style: kScoreTitle,
              ),
              Text(
                '$_score',
                style: kScore,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuestionBox extends StatelessWidget {
  QuestionBox({super.key, required this.questionString});

  String questionString = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      decoration: cBoxDecoration,
      width: double.infinity,
      child: Center(
        child: Text(
          questionString,
          style: kQuestionString,
        ),
      ),
    );
  }
}