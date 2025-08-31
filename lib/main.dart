import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/timer_screen.dart';

void main() {
  runApp(ChessTimerApp());
}

class ChessTimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Satranç Zamanlayıcı',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: {
        '/setup': (context) => SetupScreen(),
        '/timer': (context) => TimerScreen(),
      },
    );
  }
}