import 'package:flutter/material.dart';
import 'package:math_quiz_game/screens/home_screen.dart';
import 'package:math_quiz_game/screens/mixed_operation_quiz.dart';
import 'package:math_quiz_game/utils/constants.dart';

void main() {
  runApp(MathQuiz());
}

class MathQuiz extends StatelessWidget {
  MathQuiz({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id : (context) => HomeScreen(),
        additionScreen : (context) => QuizScreen(list: ['+']),
        subtractionScreen : (context) => QuizScreen(list: ['-']),
        multiplicationScreen : (context) => QuizScreen(list: ['*']),
        divisionScreen: (context) => QuizScreen(list: ['/']),
        QuizScreen.id : (context) => QuizScreen(list: ['+', '*', '/', '-']),
      },
    );
  }
}
