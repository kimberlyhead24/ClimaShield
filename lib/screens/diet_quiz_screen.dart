import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../models/quiz_model.dart';

class DietQuizScreen extends StatefulWidget {
  const DietQuizScreen({super.key});

  @override
  State<DietQuizScreen> createState() => _DietQuizScreenState();
}

class _DietQuizScreenState extends State<DietQuizScreen> {
  int _currentQuestionIndex = 0;
  String _selectedDietGenre = '';

  void _nextQuestion(String dietGenre) {
    setState(() {
      _selectedDietGenre = dietGenre;
      if (_currentQuestionIndex < dietQuiz.length - 1) {
        _currentQuestionIndex++;
      } else {
        // TODO(schema-v2): navigate to MealPlanScreen(dietGenre: _selectedDietGenre)
        // For now, just log
        // log('Quiz finished! Selected Diet: $_selectedDietGenre', name: 'DietQuizScreen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Question currentQuestion = dietQuiz[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Your Diet Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.text,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (currentQuestion.type == QuestionType.textInput)
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Write ingredients separated by commas',
                ),
                onSubmitted: (value) {
                  // TODO(schema-v2): store disliked ingredients somewhere
                  _nextQuestion(_selectedDietGenre);
                },
              )
            else
              ...currentQuestion.options.map((option) {
                final String dietGenre = option.dietGenre ?? option.value;
                return ElevatedButton(
                  onPressed: () => _nextQuestion(dietGenre),
                  child: Text(option.text),
                );
              }),
          ],
        ),
      ),
    );
  }
}
