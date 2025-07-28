import 'dart:developer';
import 'package:clima_shield/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    final result = await _authService.signIn(email: email, password: password);

    if (result != null) {
      log("Login successful! User ID: ${result.uid}", name: 'LoginScreen');
      // TODO: Navigate to the main app screen (e.g., HomeScreen)
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      log("Login failed.", name: 'LoginScreen');
      // TODO: Show an error dialog to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 320,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://storage.googleapis.com/climateshield-app-assets/world.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
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
                  _buildTextField(controller: _emailController, hintText: 'Email', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _buildTextField(controller: _passwordController, hintText: 'Password', obscureText: true),
                  const SizedBox(height: 24),
                  _buildButton(text: 'Log In', onPressed: _login, isPrimary: true),
                  const SizedBox(height: 16),
                  _buildButton(text: 'Sign in with Google', onPressed: () {}, isPrimary: false),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      // Pop back to the welcome screen
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      "Don't have an account? Sign up",
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
