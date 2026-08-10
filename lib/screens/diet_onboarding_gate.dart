import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../models/diet_profile.dart';
import 'diet_quiz_screen.dart';
import 'diet_screen.dart';

/// Decides whether a personal user needs diet onboarding.
///
/// Users without a saved DietProfile are sent to DietQuizScreen.
/// Users with a completed profile can use DietScreen normally.
class DietOnboardingGate extends StatefulWidget {
  const DietOnboardingGate({super.key});

  @override
  State<DietOnboardingGate> createState() => _DietOnboardingGateState();
}

class _DietOnboardingGateState extends State<DietOnboardingGate> {
  bool _isLoading = true;
  bool _quizWasLaunched = false;
  DietProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ClimaRepository.instance.loadDietProfile();

    if (!mounted) {
      return;
    }

    setState(() {
      _profile = profile;
      _isLoading = false;
    });

    if (profile == null && !_quizWasLaunched) {
      _quizWasLaunched = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _launchQuiz();
      });
    }
  }

  Future<void> _launchQuiz() async {
    final profile = await Navigator.of(context).push<DietProfile>(
      MaterialPageRoute(builder: (_) => const DietQuizScreen()),
    );

    if (!mounted) {
      return;
    }

    if (profile != null) {
      setState(() {
        _profile = profile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_profile == null) {
      return Center(
        child: ElevatedButton(
          onPressed: _launchQuiz,
          child: const Text('Build your climate diet'),
        ),
      );
    }

    return const DietScreen();
  }
}
