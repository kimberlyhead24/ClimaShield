import 'dart:developer';

import 'package:clima_shield/firebase_options.dart';
import 'package:clima_shield/screens/home_shell.dart';
import 'package:clima_shield/screens/welcome_screen.dart';
import 'package:clima_shield/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// Entry point.
///
/// We try to initialise Firebase, but if the platform isn't configured (e.g.
/// running on a fresh dev box without `flutterfire configure`) we still launch
/// the app in local-only mode rather than crashing. The repository layer
/// transparently falls back to in-memory sample data.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    log('Firebase init failed — running in local mode: $e', name: 'main');
  }
  runApp(const ClimaShieldApp());
}

class ClimaShieldApp extends StatelessWidget {
  const ClimaShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClimaShield',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: ClimaColors.bg,
        fontFamily: 'Be Vietnam Pro',
        colorScheme: ColorScheme.fromSeed(seedColor: ClimaColors.accent),
        useMaterial3: true,
      ),
      home: const AuthGate(),
      routes: {
        '/home': (_) => const HomeShell(),
        '/welcome': (_) => const WelcomeScreen(),
      }
    );
  }
}

/// Decides between welcome flow and the main app based on auth state. Uses a
/// stream so sign-in/sign-out updates the tree immediately. Falls back to
/// [WelcomeScreen] when Firebase isn't available.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    Stream<User?>? stream;
    try {
      stream = FirebaseAuth.instance.authStateChanges();
    } catch (_) {
      stream = null;
    }
    if (stream == null) {
      return const WelcomeScreen();
    }
    return StreamBuilder<User?>(
      stream: stream,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: ClimaColors.bg,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.data != null) return const HomeShell();
        return const WelcomeScreen();
      },
    );
  }
}
