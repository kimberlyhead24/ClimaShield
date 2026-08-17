import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:developer';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// TODO: Structure will be changed to class GooglesignInResult {
  /// final User? user;
  /// final bool wasCancelled;
  /// final String? errorCode;
  ///
  /// const GoogleSignInResult.success(this.user)
  ///   : wasCanclled = false,
  ///     errorCode = null;
  /// const GoogleSignInResult.cancelled()
  ///   : user = null,
  ///     wasCancelled = true,
  ///     errorCode = null;
  /// const GogleSignInResult.failure(this.errorCode)
  ///   : user = null,
  ///     wasCancelled = false;
  /// }
  ///
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Email/password sign up — used by Personal and Business screens
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
    required String userType, // 'personal' or 'business'
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = credential.user;
      if (user == null) return null;

      await user.updateDisplayName(name);

      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'photoUrl': '',
        'userType': userType,
        'createdAt': FieldValue.serverTimestamp(),
        'dietaryPreferences': [],
        'allergens': [],
        'savedActions': [],
        'savedRecipes': [],
      });

      return user;
    } on FirebaseAuthException catch (e) {
      log('[FirebaseAuthService] signUp Firebase error: ${e.code}', error: e);
      rethrow;
    } catch (error, stackTrace) {
      log(
        '[FirebaseAuthService] signUp unexpected error: $error',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Google sign in OR sign up — used by login_screen.dart
  /// and the Google buttons on personal/business signup screens
  Future<User?> signInWithGoogle({
    bool isSignUp = false,
    String userType = 'personal',
  }) async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithProvider(googleProvider);
      }

      final User? user = userCredential.user;
      if (user == null) return null;

      await _createOrUpdateUserDocument(
        user,
        userType: userType,
        forceCreate: isSignUp,
      );

      return user;
    } catch (e) {
      log('[FirebaseAuthService] signInWithGoogle error: $e');
      return null;
    }
  }

  Future<void> _createOrUpdateUserDocument(
    User user, {
    String userType = 'personal',
    bool forceCreate = false,
  }) async {
    final docRef = _db.collection('users').doc(user.uid);
    final docSnap = await docRef.get();

    if (!docSnap.exists) {
      await docRef.set({
        'uid': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'photoUrl': user.photoURL ?? '',
        'userType': userType,
        'createdAt': FieldValue.serverTimestamp(),
        'dietaryPreferences': [],
        'allergens': [],
        'savedActions': [],
        'savedRecipes': [],
      });
    } else {
      await docRef.update({
        'name': user.displayName ?? '',
        'photoUrl': user.photoURL ?? '',
      });
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
