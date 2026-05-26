import 'dart:developer';
import 'package:clima_shield/firebase_auth_service.dart';
import 'package:clima_shield/screens/home_shell.dart';
import 'package:clima_shield/screens/login_screen.dart';
import 'package:flutter/material.dart';

class PersonalSignUpScreen extends StatefulWidget {
  const PersonalSignUpScreen({super.key});

  @override
  State<PersonalSignUpScreen> createState() => _PersonalSignUpScreenState();
}

class _PersonalSignUpScreenState extends State<PersonalSignUpScreen> {
  // Controllers to get the text from the input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Instance of our authentication service
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    // Get the values from the text fields
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    // Call the signUp method from our service
    // We pass 'personal' as the userType
    final result = await _authService.signUp(
      email: email,
      password: password,
      name: name,
      userType: 'personal',
    );

    if (result != null) {
      log("Sign up successful! User ID: ${result.uid}", name: 'PersonalSignUpScreen');
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeShell()),
        (_) => false,
      );
    } else {
      log("Sign up failed.", name: 'PersonalSignUpScreen');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign up failed. Try a stronger password or different email.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This UI is assumed based on the business screen, replacing "Business Name" with "Full Name"
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
                  image: AssetImage("assets/images/earth.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Form Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Header Title
                  const Text(
                    'ClimaShield',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0F1914),
                      fontSize: 28,
                      fontFamily: 'Be Vietnam Pro',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Form Fields
                  _buildTextField(controller: _nameController, hintText: 'Full Name'),
                  const SizedBox(height: 16),
                  _buildTextField(controller: _emailController, hintText: 'Email', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _buildTextField(controller: _passwordController, hintText: 'Password', obscureText: true),
                  const SizedBox(height: 24),

                  // Action Buttons
                  _buildButton(text: 'Sign Up', onPressed: _signUp, isPrimary: true),
                  const SizedBox(height: 16),
                  _buildButton(
                    text: 'Sign up with Google',
                    onPressed: () async {
                      final user = await _authService.signInWithGoogle(
                        isSignUp: true,
                        userType: 'personal',
                      );
                      if (user != null && mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const HomeShell()),
                          (_) => false,
                        );
                      }
                    },
                    isPrimary: false,
                  ),
                  const SizedBox(height: 24),

                  // Login Link
                  TextButton(
                    onPressed: () {
                      // Navigate to the Login Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Already have an account? Log in',
                      style: TextStyle(
                        color: Color(0xFF598C6D),
                        fontSize: 14,
                        fontFamily: 'Be Vietnam Pro',
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

  // Helper method to build styled text fields to avoid repetition
  Widget _buildTextField({required TextEditingController controller, required String hintText, bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF598C6D)),
        filled: true,
        fillColor: const Color(0xFFE8F2ED),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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