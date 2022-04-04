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
  int step = 0;
  int score = 0;
  late int lastTypedAt;

  void updateLastTypeAt() {
    lastTypedAt = DateTime.now().millisecondsSinceEpoch;
  }

  void onType(String value) {
    print(value);
    updateLastTypeAt();
    String trimmedValue = dumyText.trimLeft();
    if (trimmedValue.indexOf(value) != 0) {
      setState(() {
        step = 2;
      });
    } else {
      setState(() {
        score = value.length;
      });
    }
  }

  void onStartClick() {
    setState(() {
      updateLastTypeAt();
      step++;
    });

    Timer.periodic((Duration(seconds: 1)), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;
      setState(() {
        if (now - lastTypedAt > 5000) step++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> shownWidget = [];

    if (step == 0) {
      shownWidget = <Widget>[
        Text('Welcome !'),
        ElevatedButton(
          child: Text('Start'),
          onPressed: onStartClick,
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
      shownWidget = <Widget>[Text('Finish, your score : $score')];
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
}