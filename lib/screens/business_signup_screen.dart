import 'dart:developer'; // Import the developer library for logging
import 'package:clima_shield/screens/login_screen.dart'; // Import the login screen
import 'package:flutter/material.dart';
// CORRECTED IMPORT PATH:
// We are telling Flutter to look for the file in the main 'lib' folder
// by using the package name 'clima_shield'.
import 'package:clima_shield/firebase_auth_service.dart'; 

class BusinessSignUpScreen extends StatefulWidget {
  const BusinessSignUpScreen({super.key});

  @override
  State<BusinessSignUpScreen> createState() => _BusinessSignUpScreenState();
}

class _BusinessSignUpScreenState extends State<BusinessSignUpScreen> {
  // Controllers to get the text from the input fields
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Instance of our authentication service
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void dispose() {
    _businessNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    // Get the values from the text fields
    String businessName = _businessNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    // Call the signUp method from our service
    // We pass 'business' as the userType
    final result = await _authService.signUp(
      email: email,
      password: password,
      name: businessName,
      userType: 'business',
    );

    if (result != null) {
      // Navigate to home screen on success
      log("Sign up successful! User ID: ${result.uid}", name: 'BusinessSignUpScreen');
      // You would typically navigate to another screen here:
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      // Show an error message
      log("Sign up failed.", name: 'BusinessSignUpScreen');
      // You would show a dialog or a snackbar here
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
                  _buildTextField(controller: _businessNameController, hintText: 'Business Name'),
                  const SizedBox(height: 16),
                  _buildTextField(controller: _emailController, hintText: 'Email', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _buildTextField(controller: _passwordController, hintText: 'Password', obscureText: true),
                  const SizedBox(height: 24),

                  // Action Buttons
                  _buildButton(text: 'Sign Up', onPressed: _signUp, isPrimary: true),
                  const SizedBox(height: 16),
                  _buildButton(text: 'Sign up with Google', onPressed: () { /* TODO: Implement Google Sign In */ }, isPrimary: false),
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