import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () async {
              await fetchRandomDog();
            },
            child: Text("Hunde anzeigen"),
          ),
        ),
      ),
    );
  }
}

Future<void> fetchRandomDog() async {
  final response = await http.get(
    Uri.parse('https://dog.ceo/api/breeds/image/random'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final imageUrl = data['message'] as String;
    final breed = extractBreedFromUrl(imageUrl);

    print('Hundebild: $imageUrl');
    print('Rasse: $breed');
  } else {
    print('Fehler beim Laden des Hundes');
  }
}

String extractBreedFromUrl(String url) {
  // Beispiel: https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg
  final parts = url.split('/');
  final breedInfo = parts[parts.indexOf('breeds') + 1];

  // Formatieren: "hound-afghan" → "Hound Afghan"
  return breedInfo
      .split('-')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}
