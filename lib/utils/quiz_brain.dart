import 'dart:math';

class QuizBrain {
  var _quizQuestionString = '';
  int _quizAnswer = 0;
  List<int> _possibleOption = [1, 2, 3, 4];
  List<String> _listOfSigns = [] ;

  QuizBrain(List<String> l){
    _listOfSigns = l;
  }

  void makeQuiz() {
    Random _random = Random();
    var selectedSign = _listOfSigns[_random.nextInt(_listOfSigns.length)];
    var firstNumber =
        _random.nextInt(10) + 10; // generates random numbers from 10 to 19
    var secondNumber =
        _random.nextInt(10) + 2; //generates random number from 2 to 11

    var realResult;
    switch (selectedSign) {
      case '+':
        {
          //making large numbers in case of addition
          firstNumber *= (_random.nextInt(9) + 5);
          secondNumber *= (_random.nextInt(9) + 4);
          realResult = firstNumber + secondNumber;
        }
        break;

      case '-':
        {
          //making large numbers in case of subtraction
          firstNumber *= (_random.nextInt(9) + 5);
          secondNumber *= (_random.nextInt(9) + 4);
          realResult = firstNumber - secondNumber;
        }
        break;

      case '*':
        realResult = firstNumber * secondNumber;
        break;

      case '/':
        {
          //syncing so that it will be exact divisible
          if (firstNumber % secondNumber != 0) {
            if (firstNumber % 2 != 0) firstNumber++;
            for (int i = secondNumber; i > 0; i--) {
              if (firstNumber % i == 0) {
                secondNumber = i;
                break;
              }
            }
          }
          // realResult = (firstNumber/secondNumber).toInt(); //below one can be used
          realResult = firstNumber ~/ secondNumber;
        }
        break;
    }

    var falseMaker = [-4, -3, -2, -1, 1, 2, 3, 4];
    List<int> possibleOption = [0, 0, 0];
    for (int i = 0; i < 3;) {
      var rand = realResult + falseMaker[_random.nextInt(falseMaker.length)];
      //if real Answer is itself negative options can contain negative value
      if (realResult < 0 && !possibleOption.contains(rand)) {
        possibleOption[i] = rand;
        i++;
      } else if (!possibleOption.contains(rand) && rand > 0) {
        possibleOption[i] = rand;
        i++;
      }
    }
    //inserting real answer and random index of option list
    possibleOption.insert(_random.nextInt(4), realResult);

    _quizAnswer = realResult;
    _quizQuestionString = '$firstNumber $selectedSign $secondNumber';
    _possibleOption = possibleOption;
  }

  get quizAnswer => _quizAnswer;
  get quizQuestionString => _quizQuestionString;
  get possibleOption => _possibleOption;

}
