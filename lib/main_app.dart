import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 🔴 NEU: Datenklasse für Bild + Rasse
class DogData {
  final String imageUrl;
  final String breed;
  DogData(this.imageUrl, this.breed);
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Future<DogData>? _dogFuture;

  // 🔴 NEU: Liefert DogData statt nur URL
  Future<DogData> fetchRandomDog() async {
    final response = await http.get(
      Uri.parse('https://dog.ceo/api/breeds/image/random'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final imageUrl = data['message'] as String;

      final breedRaw = imageUrl.split('/')[4].replaceAll('-', ' ');
      final breed = breedRaw
          .split(' ')
          .map((w) => w[0].toUpperCase() + w.substring(1))
          .join(' ');

      return DogData(imageUrl, breed);
    } else {
      throw Exception('Fehler beim Laden des Hundes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Hundeanzeige")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔴 NEU: FutureBuilder statt State-Variablen
              if (_dogFuture != null)
                FutureBuilder<DogData>(
                  future: _dogFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Fehler: ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      final dog = snapshot.data!;
                      return Column(
                        children: [
                          Image.network(dog.imageUrl),
                          SizedBox(height: 10),
                          Text(
                            dog.breed,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      );
                    } else {
                      return SizedBox(); // Sollte nie passieren
                    }
                  },
                ),

              FilledButton(
                onPressed: () {
                  setState(() {
                    _dogFuture = fetchRandomDog();
                  });
                },
                child: Text("Hund anzeigen"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// fasknjdfd
