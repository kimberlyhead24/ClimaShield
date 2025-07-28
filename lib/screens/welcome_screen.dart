import 'package:clima_shield/screens/business_signup_screen.dart';
import 'package:clima_shield/screens/login_screen.dart';
import 'package:clima_shield/screens/personal_signup_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Image Section
            Container(
              height: 320,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  // Using your final public URL
                  image: NetworkImage("https://storage.googleapis.com/climateshield-app-assets/world.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Content Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Header Title
                  const Text(
                    'Welcome to ClimaShield',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0F1914),
                      fontSize: 28,
                      fontFamily: 'Be Vietnam Pro',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Please select your account type to get started.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF598C6D),
                      fontSize: 16,
                      fontFamily: 'Be Vietnam Pro',
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  _buildButton(
                    text: "I'm a Business",
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const BusinessSignUpScreen()));
                    },
                    isPrimary: true,
                  ),
                  const SizedBox(height: 16),
                  _buildButton(
                    text: "I'm a Personal User",
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalSignUpScreen()));
                    },
                    isPrimary: false,
                  ),
                  const SizedBox(height: 24),

                  // Login Link
                  TextButton(
                    onPressed: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: const Text(
                      'Already have an account? Log in',
                      style: TextStyle(
                        color: Color(0xFF598C6D),
                        fontSize: 14,
                        fontFamily: 'Be Vietnam Pro',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build styled buttons
  Widget _buildButton({required String text, required VoidCallback onPressed, required bool isPrimary}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF93E0B2) : const Color(0xFFE8F2ED),
          foregroundColor: const Color(0xFF0F1914),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Be Vietnam Pro',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
