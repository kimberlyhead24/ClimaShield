import 'dart:developer';

import 'package:flutter/material.dart';

import '../data/carbon_math.dart';
import '../data/carbon_quiz_data.dart';
import '../data/repository.dart';
import '../models/footprint.dart';
import '../models/quiz_model.dart';
import 'home_shell.dart';

class CarbonQuizScreen extends StatefulWidget {
  const CarbonQuizScreen({super.key});

  @override
  State<CarbonQuizScreen> createState() => _CarbonQuizScreenState();
}

class _CarbonQuizScreenState extends State<CarbonQuizScreen> {
  final TextEditingController _inputController = TextEditingController();

  final Map<String, dynamic> _answers = <String, dynamic>{};

  int _currentQuestionIndex = 0;
  bool _isSaving = false;

  Question get _currentQuestion => carbonQuiz[_currentQuestionIndex];

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

  bool get _isWelcomeStep => _currentQuestion.id == 'welcome';

  bool get _isResultStep => _currentQuestion.id == 'results';

  List<Question> get _visibleQuestions {
    return carbonQuiz.where(_shouldShowQuestion).toList(growable: false);
  }

  Question get _visibleQuestion => _visibleQuestions[_currentQuestionIndex];

  bool _shouldShowQuestion(Question question) {
    if (question.id == 'carMilesPerWeek' || question.id == 'carMpg') {
      return _answers['usesCar'] != 'no';
    }

    if (question.id == 'electricityKwhPerMonth') {
      return _answers['electricityMode'] == 'exact';
    }

    if (question.id == 'electricityEstimate') {
      return _answers['electricityMode'] == 'estimate';
    }

    return true;
  }

  void _syncInputController() {
    final question = _visibleQuestion;

    if (question.type == QuestionType.numberInput ||
        question.type == QuestionType.textInput) {
      _inputController.text = _answers[question.id] as String? ?? '';
      return;
    }

    _inputController.clear();
  }

  void _selectSingleChoice(String value) {
    setState(() {
      _answers[_visibleQuestion.id] = value;
    });
  }

  void _saveCurrentTextValue() {
    final question = _visibleQuestion;

    if (question.type == QuestionType.numberInput ||
        question.type == QuestionType.textInput) {
      _answers[question.id] = _inputController.text.trim();
    }
  }

  bool get _canContinue {
    final question = _visibleQuestion;

    if (question.isOptional) {
      return true;
    }

    if (_isWelcomeStep || _isResultStep) {
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

    if (_isResultStep) {
      _openDashboard();
      return;
    }

    final isLastInputQuestion =
        _currentQuestionIndex == _visibleQuestions.length - 1;

    if (isLastInputQuestion) {
      await _calculateAndSave();
      return;
    }

    setState(() {
      _currentQuestionIndex++;
      _syncInputController();
    });
  }

  Future<void> _calculateAndSave() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final inputs = _buildInputs();
      final footprint = computeFootprint(inputs);

      await ClimaRepository.instance.saveCalculation(inputs, footprint);

      if (!mounted) {
        return;
      }

      log('Household carbon baseline saved.', name: 'CarbonQuizScreen');

      setState(() {
        _isSaving = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => _CarbonResultsScreen(footprint: footprint),
        ),
      );
    } catch (error, stackTrace) {
      log(
        'Carbon baseline save failed: $error',
        name: 'CarbonQuizScreen',
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'We could not save your household baseline. Please try again.',
          ),
        ),
      );
    }
  }

  CarbonCalculatorInputs _buildInputs() {
    final householdSize = _intAnswer('householdSize', fallback: 1);
    final usesCar = _stringAnswer('usesCar') != 'no';

    final electricityKwh = _stringAnswer('electricityMode') == 'exact'
        ? _doubleAnswer('electricityKwhPerMonth')
        : _doubleAnswer('electricityEstimate');

    return CarbonCalculatorInputs(
      householdSize: householdSize < 1 ? 1 : householdSize,
      carMilesPerWeek: usesCar ? _doubleAnswer('carMilesPerWeek') : 0,
      carMpg: usesCar ? _doubleAnswer('carMpg', fallback: 28) : 999,
      flightsShortHaulPerYear: _doubleAnswer('flightsShortHaulPerYear'),
      flightsLongHaulPerYear: _doubleAnswer('flightsLongHaulPerYear'),
      electricityKwhPerMonth: electricityKwh,
      naturalGasThermsPerMonth: _doubleAnswer('naturalGasThermsPerMonth'),
      dietType: _stringAnswer('dietType', fallback: 'average'),
      monthlyShoppingUsd: _doubleAnswer('monthlyShoppingUsd'),
    );
  }

  String _stringAnswer(String key, {String fallback = ''}) {
    final value = _answers[key];

    return value is String && value.isNotEmpty ? value : fallback;
  }

  double _doubleAnswer(String key, {double fallback = 0}) {
    return double.tryParse(_stringAnswer(key)) ?? fallback;
  }

  int _intAnswer(String key, {int fallback = 0}) {
    return _doubleAnswer(key, fallback: fallback.toDouble()).round();
  }

  void _openDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _visibleQuestion;
    final totalQuestions = _visibleQuestions.length;
    final progress = (_currentQuestionIndex + 1) / totalQuestions;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _CarbonQuizHeader(
              currentQuestion: _currentQuestionIndex + 1,
              totalQuestions: totalQuestions,
              progress: progress,
              onBackPressed: _goBack,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CarbonQuestionImage(
                      assetPath: question.headerImageAsset,
                      questionId: question.id,
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
                            _isWelcomeStep ? 'Build Your baseline' : 'Next',
                            style: const TextStyle(
                              fontSize: 16,
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
    if (_isWelcomeStep) {
      return const _HouseholdBaselinePreview();
    }

    if (question.type == QuestionType.numberInput ||
        question.type == QuestionType.textInput) {
      return TextField(
        controller: _inputController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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

    final selectedValue = _answers[question.id] as String?;

    return Column(
      children: question.options
          .map((option) {
            return _CarbonOptionCard(
              option: option,
              selected: selectedValue == option.value,
              onTap: () => _selectSingleChoice(option.value),
            );
          })
          .toList(growable: false),
    );
  }
}

class _CarbonQuizHeader extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final double progress;
  final VoidCallback onBackPressed;

  const _CarbonQuizHeader({
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
              const Expanded(
                child: Text(
                  'Build your household baseline',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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

class _CarbonQuestionImage extends StatelessWidget {
  final String? assetPath;
  final String questionId;

  const _CarbonQuestionImage({
    required this.assetPath,
    required this.questionId,
  });

  @override
  Widget build(BuildContext context) {
    final icon = switch (questionId) {
      'welcome' => Icons.family_restroom_outlined,
      'householdSize' => Icons.groups_outlined,
      'usesCar' ||
      'carMilesPerWeek' ||
      'carMpg' => Icons.directions_car_outlined,
      'flightsShortHaulPerYear' ||
      'flightsLongHaulPerYear' => Icons.flight_takeoff_outlined,
      'electricityMode' ||
      'electricityKwhPerMonth' ||
      'electricityEstimate' => Icons.bolt_outlined,
      'naturalGasThermsPerMonth' => Icons.local_fire_department_outlined,
      'dietType' => Icons.restaurant_outlined,
      'monthlyShoppingUsd' => Icons.shopping_bag_outlined,
      _ => Icons.eco_outlined,
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 180,
        child: assetPath == null
            ? _FallbackImage(icon: icon)
            : Image.asset(
                assetPath!,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (_, _, _) => _FallbackImage(icon: icon),
              ),
      ),
    );
  }
}

class _FallbackImage extends StatelessWidget {
  final IconData icon;

  const _FallbackImage({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF174C54), Color(0xFF79B8B6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(child: Icon(icon, size: 62, color: Colors.white)),
    );
  }
}

class _CarbonOptionCard extends StatelessWidget {
  final Option option;
  final bool selected;
  final VoidCallback onTap;

  const _CarbonOptionCard({
    required this.option,
    required this.selected,
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
                child: Text(
                  option.text,
                  style: const TextStyle(
                    color: Color(0xFF17231B),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
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

class _HouseholdBaselinePreview extends StatelessWidget {
  const _HouseholdBaselinePreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8F4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB9D9C1)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_graph_outlined, color: Color(0xFF197602)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'What we will estimate',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text('• Household transportation'),
          SizedBox(height: 4),
          Text('• Home electricity and natural gas'),
          SizedBox(height: 4),
          Text('• Food and shopping habits'),
          SizedBox(height: 12),
          Text(
            'You can update your household information later.',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _CarbonResultsScreen extends StatelessWidget {
  final CarbonFootprint footprint;

  const _CarbonResultsScreen({required this.footprint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            const _CarbonQuestionImage(
              assetPath: 'assets/images/onboarding/carbon_results.png',
              questionId: 'results',
            ),
            const SizedBox(height: 28),
            const Text(
              'Your household baseline is ready',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF17231B),
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This is an estimated annual household footprint based on the '
              'information you provided. You can update it anytime.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF5F6E63),
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F8F4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFB9D9C1)),
              ),
              child: Column(
                children: [
                  Text(
                    '${footprint.totalTonnes.toStringAsFixed(1)} t CO₂e',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF17231B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'estimated household footprint per year',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _ResultRow(label: 'Transportation', value: footprint.transportKg),
            _ResultRow(label: 'Home energy', value: footprint.homeEnergyKg),
            _ResultRow(label: 'Diet', value: footprint.dietKg),
            _ResultRow(label: 'Goods', value: footprint.goodsKg),
            const SizedBox(height: 24),
            const Text(
              'Your Diet tab can refine the food estimate and build a '
              'household meal plan. Logged meals and completed actions '
              'will later adjust your household progress.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF5F6E63),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeShell()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF28A16),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'View our dashboard',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final double value;

  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Text('${value.toStringAsFixed(0)} kg CO₂e'),
        ],
      ),
    );
  }
}
