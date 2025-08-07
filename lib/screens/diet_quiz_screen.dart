import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../models/quiz_model.dart';

class DietQuizScreen extends StatefulWidget {
  const DietQuizScreen({super.key});

  @override
  _DietQuizScreenState createState() => _DietQuizScreenState();
}

class _DietQuizScreenState extends State<DietQuizScreen> {
  int _currentQuestionIndex = 0;
  String _selectedDietGenre = '';

  void _nextQuestion(String dietGenre) {
    setState(() {
      _selectedDietGenre = dietGenre; // For now, we'll just take the last selection
      if (_currentQuestionIndex < dietQuiz.length - 1) {
        _currentQuestionIndex++;
      } else {
        // Quiz is finished, navigate to the meal plan screen
        // Navigator.push(context, MaterialPageRoute(builder: (context) => MealPlanScreen(dietGenre: _selectedDietGenre)));
        print("Quiz finished! Selected Diet: $_selectedDietGenre");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Question currentQuestion = dietQuiz[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(title: const Text("Your Diet Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(currentQuestion.text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...currentQuestion.options.map((option) {
              return ElevatedButton(
                onPressed: () => _nextQuestion(option.dietGenre),
                child: Text(option.text),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}