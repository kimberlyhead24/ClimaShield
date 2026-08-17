String authErrorMessage(String code, {required bool isSignUp}) {
  switch (code) {
    case 'email-already-in-use':
      return 'An account already exists for this email. Try logging in instead.';
    case 'weak-password':
      return 'Choose a stronger password with at least 6 characters.';
    case 'invalid-email':
      return 'Enter a valid email address.';
    case 'user-not-found':
      return 'No account was found for that email.';
    case 'wrong-password':
    case 'invalid-credential':
      return 'Incorrect email or password.';
    case 'network-request-failed':
      return 'Network error. Check your connection and try again.';
    case 'too-many-requests':
      return 'Too many attempts. Please wait a moment and try again.';
    default:
      return isSignUp
          ? 'Account creation failed. Please try again.'
          : 'Sign-in failed. Please try again.';
  }
}
