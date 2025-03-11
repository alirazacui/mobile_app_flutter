import 'package:flutter/material.dart';
import 'flashcard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<Map<String, String>>> decks = {
    "Flutter": [
      {"question": "What is Flutter?", "answer": "A UI toolkit by Google"},
      {"question": "Which language does Flutter use?", "answer": "Dart"},
    ],
    "Dart": [
      {"question": "Is Dart statically typed?", "answer": "Yes"},
      {"question": "What keyword is used for classes?", "answer": "`class`"},
    ],
    "Java": [
      {"question": "What is Java?", "answer": "A programming language"},
      {"question": "What is JVM?", "answer": "Java Virtual Machine"},
    ],
  };

  void _updateDeck(String deckName, List<Map<String, String>> updatedDeck) {
    setState(() {
      decks[deckName] = updatedDeck; // Update deck with new flashcards
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select a Deck")),
      body: ListView(
        children: decks.keys.map((deckName) {
          return ListTile(
            title: Text(deckName),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashcardScreen(
                    deckName: deckName,
                    initialFlashcards: decks[deckName]!,
                    onUpdateDeck: _updateDeck, // Pass function to update deck
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
