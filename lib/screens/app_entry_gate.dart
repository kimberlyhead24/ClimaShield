import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../firebase_auth_service.dart';
import 'carbon_onboarding_gate.dart';
import 'home_shell.dart';
import 'welcome_screen.dart';

class AppEntryGate extends StatelessWidget {
  const AppEntryGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuthService().authStateChanges,
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const _AppLoadingScreen();
        }

        if (!authSnapshot.hasData) {
          return const WelcomeScreen();
        }

        return const _FootprintGate();
      },
    );
  }
}

class _FootprintGate extends StatefulWidget {
  const _FootprintGate();

  @override
  State<_FootprintGate> createState() => _FootprintGateState();
}

class _FootprintGateState extends State<_FootprintGate> {
  bool _isLoading = true;
  bool _hasFootprint = false;

  @override
  void initState() {
    super.initState();
    _loadFootprint();
  }

  Future<void> _loadFootprint() async {
    final footprint = await ClimaRepository.instance.loadFootprint();

    if (!mounted) {
      return;
    }

    setState(() {
      _hasFootprint = footprint != null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const _AppLoadingScreen();
    }

    return _hasFootprint
        ? const HomeShell()
        : const CarbonOnboardingGate();
  }
}

class _AppLoadingScreen extends StatelessWidget {
  const _AppLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}