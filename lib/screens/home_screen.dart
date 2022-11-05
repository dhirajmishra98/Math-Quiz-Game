import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:math_quiz_game/screens/mixed_operation_quiz.dart';
import 'package:math_quiz_game/utils/components.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:math_quiz_game/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    musicChanged = false;
    player.stop();
  }
  final player = AudioPlayer();
  String sound = 'sound/background-music.mp3';
  bool musicChanged = false;

  void playSound(bool value) {
    if (musicChanged == false) {
      setState(() {
        musicChanged = true;
        player.play(AssetSource(sound));
        player.onPlayerComplete.listen((event) {
          player.play(AssetSource(sound));
        });
      });
    } else {
      setState(() {
        musicChanged = false;
        player.stop();
      });
    }
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'MATH QUIZ',
                style: kMathQuizHeading,
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: DefaultTextStyle(
                  style: kGameTitle,
                  textAlign: TextAlign.center,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'GAME..',
                        speed: Duration(milliseconds: 300),
                      ),
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,
                  ),
                ),
              ),
              SizedBox(
                height: 80.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, additionScreen);
                    },
                    child: bHomeOptionButton('assets/icon/addition.png'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, subtractionScreen);
                    },
                    child: bHomeOptionButton('assets/icon/minus.png'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, multiplicationScreen);
                    },
                    child: bHomeOptionButton('assets/icon/multiplication.png'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, divisionScreen);
                    },
                    child: bHomeOptionButton('assets/icon/division.png'),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, QuizScreen.id);
                },
                child: bMixScreenButton('MIX'),
              ),
              SizedBox(
                height: 80.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tap to Play!',
                    style: kTapToPlay,
                  ),
                  SizedBox(
                    width: 100.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'MUSIC',
                        style: kTapToPlay,
                      ),
                      SizedBox(
                        width: 40.0,
                      ),
                      Transform.scale(
                        scale: 1.5,
                        child: Switch.adaptive(
                          value: musicChanged,
                          onChanged: playSound,
                          activeColor: Colors.red,
                          inactiveThumbColor: Colors.purpleAccent,
                          inactiveTrackColor: Colors.purple,
                          // autofocus: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
