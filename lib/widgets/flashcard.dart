import 'package:flutter/material.dart';

class Flashcard extends StatefulWidget {
  final String question;
  final String answer;
  final Function(bool) onAnswered;

  const Flashcard({
    Key? key,
    required this.question,
    required this.answer,
    required this.onAnswered,
  }) : super(key: key);

  @override
  _FlashcardState createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  bool _isFlipped = false;
  bool _hasAnswered = false;

  void _toggleFlip() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  void _handleAnswer(bool isCorrect) {
    if (!_hasAnswered) {
      widget.onAnswered(isCorrect);
      setState(() {
        _hasAnswered = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleFlip,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 180,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _isFlipped ? Colors.blueAccent : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              _isFlipped ? widget.answer : widget.question,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _isFlipped ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (_isFlipped)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _hasAnswered ? null : () => _handleAnswer(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text("Correct"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _hasAnswered ? null : () => _handleAnswer(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text("Incorrect"),
              ),
            ],
          ),
      ],
    );
  }
}
