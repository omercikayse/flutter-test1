// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppHome(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class MyAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppHomeState();
  }
}

class _MyAppHomeState extends State<MyAppHome> {
  String dumyText =
      '                                 The lorem ipsum is a placeholder text used in publishing and graphic design. This filler text is a short paragraph that contains all the letters of the alphabet. The characters are spread out evenly so that the reader'
          .toLowerCase()
          .replaceAll(',', '')
          .replaceAll('.', '');
  String userName = '';
  int step = 0;
  int score = 0;
  late int lastTypedAt;

  void updateLastTypeAt() {
    lastTypedAt = DateTime.now().millisecondsSinceEpoch;
  }

  void onType(String value) {
    updateLastTypeAt();
    String trimmedValue = dumyText.trimLeft();
    setState(() {
      if (trimmedValue.indexOf(value) != 0) {
        step = 2;
      } else {
        score = value.length;
      }
    });
  }

  void onUserNameType(String value) {
    setState(() {
      userName = value;
    });
  }

  void onStartClick() {
    setState(() {
      updateLastTypeAt();
      step++;
    });

    var timer = Timer.periodic((Duration(seconds: 1)), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;
      setState(() {
        if (step == 1 && now - lastTypedAt > 5000) {
          timer.cancel();
          step++;
        }
        if (step != 1) timer.cancel();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> shownWidget = [];

    if (step == 0) {
      shownWidget = <Widget>[
        Text('Welcome !'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: onUserNameType,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'What is your name?'),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            child: Text('Start'),
            onPressed: userName.length == 0 ? null : onStartClick,
          ),
        )
      ];
    } else if (step == 1) {
      shownWidget = <Widget>[
        Text('$score'),
        Container(
          height: 40,
          child: Marquee(
            text: dumyText,
            style: TextStyle(fontSize: 24, letterSpacing: 2),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            velocity: 75,
            pauseAfterRound: Duration(seconds: 10),
            startPadding: 0,
            accelerationDuration: Duration(seconds: 15),
            accelerationCurve: Curves.ease,
            decelerationDuration: Duration(microseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 16, top: 16),
          child: TextField(
            autofocus: true,
            onChanged: onType,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Type please'),
          ),
        )
      ];
    } else {
      shownWidget = <Widget>[
        Text('Finish, your score : $score'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              ElevatedButton(onPressed: resetGame, child: Text("Try Again!")),
        )
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello Ayse"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: shownWidget,
      )),
    );
  }

  void resetGame() {
    setState(() {
      score = 0;
      step = 0;
    });
  }
}
