import 'dart:async';

import 'package:diginote/shared/styles/styles.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
   LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progress = 0.0;

  Timer? _timer;

  int _millisecondsElapsed = 0;

  final int _totalMilliseconds = 16000;
 // 20 seconds in milliseconds
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const tick = const Duration(milliseconds: 100);
    _timer = Timer.periodic(tick, (Timer timer) {
      setState(() {
        _millisecondsElapsed += tick.inMilliseconds;
        _progress = (_millisecondsElapsed / _totalMilliseconds).clamp(0.0, 1.0);
      });
      if (_millisecondsElapsed >= _totalMilliseconds) {
        timer.cancel();
        // Here you can navigate to the next screen or perform any other actions
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Loading... ${(100 * _progress).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 20.0,color: Styles.gumColor),
            ),
            const SizedBox(height: 20.0),
            Container(width: 300,
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Styles.gumColor.withOpacity(0.5),
                valueColor: const AlwaysStoppedAnimation<Color>(Styles.gumColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

