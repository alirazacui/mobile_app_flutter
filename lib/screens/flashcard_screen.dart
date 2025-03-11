import 'package:flutter/material.dart';
import '../widgets/flashcard.dart';

class FlashcardScreen extends StatefulWidget {
  final String deckName;
  final List<Map<String, String>> initialFlashcards;
  final Function(String, List<Map<String, String>>) onUpdateDeck; // ✅ Add this

  const FlashcardScreen({
    super.key,
    required this.deckName,
    required this.initialFlashcards,
    required this.onUpdateDeck, // ✅ Add this
  });

  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int _currentIndex = 0;
  int _score = 0;
  late List<Map<String, String>> _deckFlashcards;

  @override
  void initState() {
    super.initState();
    _deckFlashcards = List.from(widget.initialFlashcards);
  }

  void _updateScore(bool isCorrect) {
    setState(() {
      if (isCorrect) _score++;
    });
  }

  void _nextFlashcard() {
    if (_deckFlashcards.isEmpty) return;

    setState(() {
      _currentIndex = (_currentIndex + 1) % _deckFlashcards.length;
    });
  }

  void _addFlashcard(String question, String answer) {
    setState(() {
      _deckFlashcards.add({"question": question, "answer": answer});
      widget.onUpdateDeck(widget.deckName, _deckFlashcards); // ✅ Update HomeScreen
      if (_deckFlashcards.length == 1) {
        _currentIndex = 0;
      }
    });
  }

  void _showAddFlashcardDialog() {
    String question = "";
    String answer = "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Flashcard"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Question"),
              onChanged: (value) => question = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Answer"),
              onChanged: (value) => answer = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (question.isNotEmpty && answer.isNotEmpty) {
                _addFlashcard(question, answer);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Both fields are required!")),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.deckName)),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFlashcardDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Score: $_score", style: const TextStyle(fontSize: 20)),
          if (_deckFlashcards.isNotEmpty)
            Column(
              children: [
                Flashcard(
                  question: _deckFlashcards[_currentIndex]["question"]!,
                  answer: _deckFlashcards[_currentIndex]["answer"]!,
                  onAnswered: (isCorrect) {
                    _updateScore(isCorrect);
                    Future.delayed(const Duration(seconds: 1), _nextFlashcard);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _nextFlashcard,
                  child: const Text("Next Flashcard"),
                ),
              ],
            )
          else
            const Text("No flashcards yet! Add some using the + button."),
        ],
      ),
    );
  }
}
