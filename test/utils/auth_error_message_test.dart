import 'package:clima_shield/utils/auth_error_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('authErrorMessage', () {
    test('explains an already-used email during signup', () {
      expect(
        authErrorMessage('email-already-in-use', isSignUp: true),
        'An account already exists for this email. Try logging in instead.',
      );
    });

    test('explains a weak password during signup', () {
      expect(
        authErrorMessage('weak-password', isSignUp: true),
        'Choose a stronger password with at least 6 characters.',
      );
    });

    test('uses a safe generic signup message for unknown errors', () {
      expect(
        authErrorMessage('unknown-error', isSignUp: true),
        'Account creation failed. Please try again.',
      );
    });

    test('explains invalid credentials during login', () {
      expect(
        authErrorMessage('invalid-credential', isSignUp: false),
        'Incorrect email or password.',
      );
    });
  });
}
