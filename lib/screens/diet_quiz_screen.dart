import 'dart:developer';

import 'package:flutter/material.dart';

import '../data/quiz_data.dart';
import '../models/quiz_model.dart';

import '../data/repository.dart';
import '../models/diet_profile.dart';

class DietQuizScreen extends StatefulWidget {
  const DietQuizScreen({super.key});

  @override
  State<DietQuizScreen> createState() => _DietQuizScreenState();
}

class _DietQuizScreenState extends State<DietQuizScreen> {
  final TextEditingController _inputController = TextEditingController();

  final Map<String, dynamic> _answers = {};

  int _currentQuestionIndex = 0;
  bool _isSaving = false;

  Question get _currentQuestion => dietQuiz[_currentQuestionIndex];

  @override
  void initState() {
    super.initState();
    _syncInputController();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _syncInputController() {
    final question = _currentQuestion;

    if (question.type == QuestionType.textInput ||
        question.type == QuestionType.numberInput) {
      final savedValue = _answers[question.id] as String? ?? '';
      _inputController.text = savedValue;
      return;
    }

    _inputController.clear();
  }

  void _selectSingleChoice(String value) {
    setState(() {
      _answers[_currentQuestion.id] = value;
    });
  }

  void _toggleMultipleChoice(String value) {
    final currentValues = List<String>.from(
      _answers[_currentQuestion.id] as List? ?? [],
    );

    setState(() {
      if (currentValues.contains(value)) {
        currentValues.remove(value);
      } else {
        currentValues.add(value);
      }

      _answers[_currentQuestion.id] = currentValues;
    });
  }

  void _saveCurrentTextValue() {
    final question = _currentQuestion;

    if (question.type == QuestionType.textInput ||
        question.type == QuestionType.numberInput) {
      _answers[question.id] = _inputController.text.trim();
    }
  }

  bool get _canContinue {
    final question = _currentQuestion;

    if (question.isOptional) {
      return true;
    }

    switch (question.type) {
      case QuestionType.singleChoice:
        final answer = _answers[question.id];
        return answer is String && answer.isNotEmpty;

      case QuestionType.multipleChoice:
        final answer = _answers[question.id];
        return answer is List && answer.isNotEmpty;

      case QuestionType.textInput:
        return _inputController.text.trim().isNotEmpty;

      case QuestionType.numberInput:
        return double.tryParse(_inputController.text.trim()) != null;
    }
  }

  void _goBack() {
    if (_currentQuestionIndex == 0) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _currentQuestionIndex--;
      _syncInputController();
    });
  }

  Future<void> _goNext() async {
    _saveCurrentTextValue();

    if (!_canContinue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select or enter an answer before continuing.'),
        ),
      );
      return;
    }

    final isLastQuestion = _currentQuestionIndex == dietQuiz.length - 1;

    if (isLastQuestion) {
      await _finishQuiz();
      return;
    }

    setState(() {
      _currentQuestionIndex++;
      _syncInputController();
    });
  }

  Future<void> _finishQuiz() async {
    final profile = _buildDietProfile();

    if (!profile.isReadyForDietBaseline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please answer the food-frequency questions to build your diet baseline.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ClimaRepository.instance.saveDietProfile(profile);

      if (!mounted) {
        return;
      }

      log('Diet profile saved successfully.', name: 'DietQuizScreen');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your climate-diet profile is ready.')),
      );

      Navigator.of(context).pop(profile);
    } catch (e, stackTrace) {
      debugPrint('Diet profile save failed: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) {
        return;
      }

      log('Failed to save diet profile: $e', name: 'DietQuizScreen');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'We could not save your diet profile. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  List<String> _selectedValues(Question question) {
    final value = _answers[question.id];

    if (value is List<String>) {
      return value;
    }

    if (value is List) {
      return value.whereType<String>().toList();
    }

    return const [];
  }

  String _stringAnswer(String key) {
    return _answers[key] as String? ?? '';
  }

  double _doubleAnswer(String key) {
    return double.tryParse(_stringAnswer(key)) ?? 0;
  }

  double? _optionalDoubleAnswer(String key) {
    final value = _stringAnswer(key);

    if (value.isEmpty) {
      return null;
    }

    return double.tryParse(value);
  }

  int _intAnswer(String key, {int minimum = 0}) {
    final parsedValue = _doubleAnswer(key).round();

    if (parsedValue < minimum) {
      return minimum;
    }

    return parsedValue;
  }

  List<String> _listAnswer(String key) {
    final value = _answers[key];

    if (value is List<String>) {
      return List<String>.unmodifiable(value);
    }

    if (value is List) {
      return List<String>.unmodifiable(value.whereType<String>());
    }

    return const [];
  }

  List<String> _commaSeparatedAnswer(String key) {
    return _stringAnswer(key)
        .split(',')
        .map((ingredient) => ingredient.trim().toLowerCase())
        .where((ingredient) => ingredient.isNotEmpty)
        .toList();
  }

  DietProfile _buildDietProfile() {
    return DietProfile(
      profileVersion: 1,
      householdSize: _intAnswer('householdSize', minimum: 1),
      mealsPreparedAtHomePerWeek: _intAnswer('mealsPreparedAtHomePerWeek'),
      primaryGoal: _stringAnswer('primaryGoal'),
      currentDietPattern: _stringAnswer('currentDietPattern'),
      totalMealsEatenPerWeek: _intAnswer('totalMealsEatenPerWeek'),
      beefOrLambServingsPerWeek: _doubleAnswer('beefOrLambServingsPerWeek'),
      porkServingsPerWeek: _doubleAnswer('porkServingsPerWeek'),
      poultryServingsPerWeek: _doubleAnswer('poultryServingsPerWeek'),
      fishOrSeafoodServingsPerWeek: _doubleAnswer(
        'fishOrSeafoodServingsPerWeek',
      ),
      eggServingsPerWeek: _doubleAnswer('eggServingsPerWeek'),
      dairyServingsPerWeek: _doubleAnswer('dairyServingsPerWeek'),
      plantProteinServingsPerWeek: _doubleAnswer('plantProteinServingsPerWeek'),
      preferredCuisines: _listAnswer('preferredCuisines'),
      avoidedCuisines: _listAnswer('avoidedCuisines'),
      dislikedIngredients: _commaSeparatedAnswer('dislikedIngredients'),
      dietaryRestrictions: _listAnswer('dietaryRestrictions'),
      allergens: _listAnswer('allergens'),
      maxCookingTimeMinutes: _intAnswer('maxCookingTimeMinutes'),
      weeklyFoodBudgetUsd: _optionalDoubleAnswer('weeklyFoodBudgetUsd'),
      transitionPace: _stringAnswer('transitionPace'),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _currentQuestion;
    final progress = (_currentQuestionIndex + 1) / dietQuiz.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _QuizHeader(
              currentQuestion: _currentQuestionIndex + 1,
              totalQuestions: dietQuiz.length,
              progress: progress,
              onBackPressed: _goBack,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 112,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF74A97D), Color(0xFFA6D7B2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.eco_outlined,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      question.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF17231B),
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (question.helperText != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        question.helperText!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF5F6E63),
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    _buildQuestionInput(question),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _goNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF28A16),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            _currentQuestionIndex == dietQuiz.length - 1
                                ? 'Finish'
                                : 'Next',
                            style: const TextStyle(
                              fontSize: 16,

                              ///
                              /// [@var		string	fontWeight]
                              ///
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionInput(Question question) {
    if (question.type == QuestionType.textInput ||
        question.type == QuestionType.numberInput) {
      return TextField(
        controller: _inputController,
        keyboardType: question.type == QuestionType.numberInput
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        maxLines: question.type == QuestionType.textInput ? 3 : 1,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: question.inputHint ?? 'Enter your answer',
          hintStyle: const TextStyle(color: Color(0xFF8A938D)),
          filled: true,
          fillColor: const Color(0xFFF4F2EE),
          contentPadding: const EdgeInsets.all(18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      );
    }

    if (question.type == QuestionType.singleChoice) {
      final selectedValue = _answers[question.id] as String?;

      return Column(
        children: question.options.map((option) {
          return _OptionCard(
            option: option,
            selected: selectedValue == option.value,
            isMultipleChoice: false,
            onTap: () => _selectSingleChoice(option.value),
          );
        }).toList(),
      );
    }

    final selectedValues = _selectedValues(question);

    return Column(
      children: question.options.map((option) {
        return _OptionCard(
          option: option,
          selected: selectedValues.contains(option.value),
          isMultipleChoice: true,
          onTap: () => _toggleMultipleChoice(option.value),
        );
      }).toList(),
    );
  }
}

class _QuizHeader extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final double progress;
  final VoidCallback onBackPressed;

  const _QuizHeader({
    required this.currentQuestion,
    required this.totalQuestions,
    required this.progress,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBackPressed,
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              Expanded(
                child: Text(
                  'Build your climate diet',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF17231B),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '$currentQuestion/$totalQuestions',
                style: const TextStyle(
                  color: Color(0xFF5F6E63),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFE9ECE8),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFF28A16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final Option option;
  final bool selected;
  final bool isMultipleChoice;
  final VoidCallback onTap;

  const _OptionCard({
    required this.option,
    required this.selected,
    required this.isMultipleChoice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? const Color(0xFFF28A16)
        : const Color(0xFFE1E5E1);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFF4E6) : const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: selected ? 2 : 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.text,
                      style: const TextStyle(
                        color: Color(0xFF17231B),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (option.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        option.description!,
                        style: const TextStyle(
                          color: Color(0xFF5F6E63),
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (isMultipleChoice)
                Checkbox(
                  value: selected,
                  onChanged: (_) => onTap(),
                  activeColor: const Color(0xFFF28A16),
                )
              else
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected
                      ? const Color(0xFFF28A16)
                      : const Color(0xFF98A29B),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
