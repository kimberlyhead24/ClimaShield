import 'package:flutter/material.dart';

import '../data/repository.dart';
import 'carbon_quiz_screen.dart';
import 'home_shell.dart';

class CarbonOnboardingGate extends StatefulWidget {
  const CarbonOnboardingGate({super.key});

  @override
  State<CarbonOnboardingGate> createState() => _CarbonOnboardingGateState();
}

class _CarbonOnboardingGateState extends State<CarbonOnboardingGate> {
  bool _isLoading = true;
  bool _quizWasLaunched = false;

  @override
  void initState() {
    super.initState();
    _checkForSavedFootprint();
  }

  Future<void> _checkForSavedFootprint() async {
    final footprint = await ClimaRepository.instance.loadFootprint();

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    if (footprint == null && !_quizWasLaunched) {
      _quizWasLaunched = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openQuiz();
      });
    }
  }

  Future<void> _openQuiz() async {
    final completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const CarbonQuizScreen()),
    );

    if (!mounted) {
      return;
    }

    if (completed == true) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeShell()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _openQuiz,
          child: const Text('Build my carbon baseline'),
        ),
      ),
    );
  }
}