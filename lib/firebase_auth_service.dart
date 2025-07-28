import 'dart:developer'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Signs up a user with email and password, then stores their data in Firestore.
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
    required String userType, // 'personal' or 'business'
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await _storeUserData(
          uid: userCredential.user!.uid,
          email: email,
          name: name,
          userType: userType,
        );
        return userCredential.user;
      }
    } on FirebaseAuthException catch (e) {
      log('Failed to sign up: ${e.message}', name: 'FirebaseAuthService');
      return null;
    } catch (e) {
      log('An unexpected error occurred: $e', name: 'FirebaseAuthService');
      return null;
    }
    return null;
  }

  /// Signs in a user with email and password.
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      log('Failed to sign in: ${e.message}', name: 'FirebaseAuthService');
      return null;
    } catch (e) {
      log('An unexpected error occurred: $e', name: 'FirebaseAuthService');
      return null;
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log('Error signing out: $e', name: 'FirebaseAuthService');
    }
  }

  /// Stores user data in a 'users' collection in Firestore.
  Future<void> _storeUserData({
    required String uid,
    required String email,
    required String name,
    required String userType,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'userType': userType,
        'createdAt': Timestamp.now(),
        'linkedAccountId': null,
      });
    } catch (e) {
      log('Failed to store user data: $e', name: 'FirebaseAuthService');
    }
  }
}

