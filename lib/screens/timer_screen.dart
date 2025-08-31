import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  late int initialTime;
  late String player1Name;
  late String player2Name;

  int player1Time = 0;
  int player2Time = 0;
  bool isPlayer1Active = false;
  bool isPlayer2Active = false;
  bool isRunning = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        player1Name = args['player1Name'];
        player2Name = args['player2Name'];
        initialTime = args['initialTime'];
        player1Time = initialTime;
        player2Time = initialTime;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      isRunning = true;
      isPlayer1Active = true;
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (isPlayer1Active) {
          player1Time--;
          if (player1Time <= 0) {
            player1Time = 0;
            timer.cancel();
            isRunning = false;
            _playSound();
            _showTimeOutDialog(player1Name);
          }
        } else if (isPlayer2Active) {
          player2Time--;
          if (player2Time <= 0) {
            player2Time = 0;
            timer.cancel();
            isRunning = false;
            _playSound();
            _showTimeOutDialog(player2Name);
          }
        }
      });
    });
  }

  void pauseTimer() {
    setState(() {
      timer?.cancel();
      isRunning = false;
    });
  }

  void resetTimer() {
    setState(() {
      timer?.cancel();
      isRunning = false;
      isPlayer1Active = false;
      isPlayer2Active = false;
      player1Time = initialTime;
      player2Time = initialTime;
    });
  }

  void switchPlayer() {
    if (isRunning) {
      setState(() {
        isPlayer1Active = !isPlayer1Active;
        isPlayer2Active = !isPlayer2Active;
      });
    }
  }

  void _playSound() async {
    // Ses dosyası eklemek için assets klasörüne ses dosyası ekleyin
    // await audioPlayer.play(AssetSource('sounds/time_out.mp3'));
  }

  void _showTimeOutDialog(String player) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Zaman Doldu', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('$player zamanı doldu!', style: TextStyle(fontSize: 18)),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam', style: TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Satranç Zamanlayıcı'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/setup');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Oyuncu 1 Zamanlayıcı
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (isPlayer2Active) {
                  switchPlayer();
                } else if (!isRunning) {
                  startTimer();
                }
              },
              child: Container(
                color: isPlayer1Active ? Colors.green[200] : Colors.grey[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        player1Name,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _formatTime(player1Time),
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: player1Time < 60 ? Colors.red : Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        isPlayer1Active ? 'SIRA SENDE' : 'BEKLEMEDE',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isPlayer1Active ? Colors.red : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Kontrol Butonları
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (!isRunning)
                  ElevatedButton(
                    onPressed: startTimer,
                    child: Text('BAŞLAT', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: pauseTimer,
                    child: Text('DURAKLAT', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ElevatedButton(
                  onPressed: resetTimer,
                  child: Text('SIFIRLA', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
              ],
            ),
          ),

          // Oyuncu 2 Zamanlayıcı
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (isPlayer1Active) {
                  switchPlayer();
                } else if (!isRunning) {
                  startTimer();
                  setState(() {
                    isPlayer2Active = true;
                  });
                }
              },
              child: Container(
                color: isPlayer2Active ? Colors.green[200] : Colors.grey[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        player2Name,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _formatTime(player2Time),
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: player2Time < 60 ? Colors.red : Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        isPlayer2Active ? 'SIRA SENDE' : 'BEKLEMEDE',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isPlayer2Active ? Colors.red : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}