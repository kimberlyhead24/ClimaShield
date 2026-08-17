import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase_auth_service.dart';
import '../utils/auth_error_message.dart';
import 'home_shell.dart';
import 'login_screen.dart';

class PersonalSignUpScreen extends StatefulWidget {
  const PersonalSignUpScreen({super.key});

  @override
  State<PersonalSignUpScreen> createState() => _PersonalSignUpScreenState();
}

class _PersonalSignUpScreenState extends State<PersonalSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = FirebaseAuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_isLoading) return;

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isLoading = true);

    try {
      final user = await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        userType: 'personal',
      );

      if (!mounted) return;

      if (user == null) {
        _showMessage(
          'Account creation did not return a user. Please try again.',
        );
        return;
      }

      log('Sign up successful: ${user.uid}', name: 'PersonalSignUpScreen');

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeShell()),
        (_) => false,
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      _showMessage(authErrorMessage(error.code, isSignUp: true));
    } catch (error, stackTrace) {
      log(
        'Unexpected signup error: $error',
        name: 'PersonalSignUpScreen',
        stackTrace: stackTrace,
      );

      if (!mounted) return;
      _showMessage('Account creation failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 260,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/earth.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Create your ClimaShield account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF0F1914),
                          fontSize: 26,
                          fontFamily: 'Be Vietnam Pro',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        controller: _nameController,
                        hintText: 'Full name',
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter your name.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          if (email.isEmpty) return 'Enter your email.';
                          if (!email.contains('@')) {
                            return 'Enter a valid email address.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        enableSuggestions: false,
                        autocorrect: false,
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if ((value ?? '').length < 6) {
                            return 'Use at least 6 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm password',
                        obscureText: _obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        enableSuggestions: false,
                        autocorrect: false,
                        onSubmitted: (_) => _signUp(),
                        suffixIcon: IconButton(
                          tooltip: _obscureConfirmPassword
                              ? 'Show password'
                              : 'Hide password',
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildButton(
                        text: _isLoading ? 'Creating account...' : 'Sign Up',
                        onPressed: _isLoading ? null : _signUp,
                        isPrimary: true,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF0F1914),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildButton(
                        text: 'Sign up with Google',
                        onPressed: _isLoading
                            ? null
                            : () async {
                                final user = await _authService
                                    .signInWithGoogle(
                                      isSignUp: true,
                                      userType: 'personal',
                                    );

                                if (!context.mounted || user == null) return;

                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const HomeShell(),
                                  ),
                                  (_) => false,
                                );
                              },
                        isPrimary: false,
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    bool obscureText = false,
    bool enableSuggestions = true,
    bool autocorrect = true,
    Widget? suffixIcon,
    ValueChanged<String>? onSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      onFieldSubmitted:
          onSubmitted ??
          (_) {
            if (textInputAction == TextInputAction.next) {
              FocusScope.of(context).nextFocus();
            }
          },
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF598C6D)),
        filled: true,
        fillColor: const Color(0xFFE8F2ED),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isPrimary,
    Widget? child,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? const Color(0xFF93E0B2)
              : const Color(0xFFE8F2ED),
          foregroundColor: const Color(0xFF0F1914),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        child:
            child ??
            Text(
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
