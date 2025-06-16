import 'package:api_test/dog_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Future<DogData>? _dog;

  //                                                 liefert DogData über API

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
        backgroundColor: const Color.fromARGB(255, 192, 255, 252),
        appBar: AppBar(
          title: Text(
            "DOG-API  APP",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          foregroundColor: const Color.fromARGB(255, 1, 106, 101),
          backgroundColor: const Color.fromARGB(255, 110, 228, 222),
          elevation: 3,
          shadowColor: const Color.fromARGB(255, 0, 146, 139),
          // backgroundColor: const Color.fromARGB(255, 173, 235, 232),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Aufrufen aus der API
              if (_dog != null)
                FutureBuilder<DogData>(
                  future: _dog,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Fehler: ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      final dog = snapshot.data!;
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              dog.imageUrl,
                              height: 350,
                              width: 350,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return SizedBox(
                                  height: 250,
                                  width: 250,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return SizedBox(
                                  height: 250,
                                  width: 250,
                                  child: Center(child: Icon(Icons.error)),
                                );
                              },
                            ),
                          ),
                          // Image.network(dog.imageUrl),
                          SizedBox(height: 10),
                          Text(
                            dog.breed,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 1, 60, 57),
                            ),
                          ),
                          SizedBox(height: 40),
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
                    _dog = fetchRandomDog();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "New One",
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 1, 106, 101),
                    ),
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 110, 228, 222),
                  shadowColor: const Color.fromARGB(255, 0, 146, 139),
                  elevation: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// dawsdas
