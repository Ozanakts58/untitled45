import 'package:flutter/material.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();
  int selectedTime = 5; // Varsayılan 5 dakika

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oyun Ayarları'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Oyuncu 1 Adı
            TextField(
              controller: player1Controller,
              decoration: InputDecoration(
                labelText: 'Oyuncu 1 Adı',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20),

            // Oyuncu 2 Adı
            TextField(
              controller: player2Controller,
              decoration: InputDecoration(
                labelText: 'Oyuncu 2 Adı',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 30),

            // Süre Seçimi
            Text(
              'Süre Seçiniz (dakika)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeOption(3),
                _buildTimeOption(5),
                _buildTimeOption(10),
              ],
            ),
            SizedBox(height: 40),

            // Başla Butonu
            ElevatedButton(
              onPressed: () {
                if (player1Controller.text.isEmpty || player2Controller.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lütfen her iki oyuncu için de isim giriniz.')),
                  );
                  return;
                }

                Navigator.pushReplacementNamed(
                  context,
                  '/timer',
                  arguments: {
                    'player1Name': player1Controller.text,
                    'player2Name': player2Controller.text,
                    'initialTime': selectedTime * 60, // Saniyeye çevir
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Text(
                  'OYUNA BAŞLA',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeOption(int minutes) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = minutes;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: selectedTime == minutes ? Colors.blue[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '$minutes dk',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: selectedTime == minutes ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}