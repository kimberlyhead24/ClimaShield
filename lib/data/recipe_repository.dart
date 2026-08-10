import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/recipe_model.dart';

class RecipeRepository {
  RecipeRepository._();

  static final RecipeRepository instance = RecipeRepository._();

  FirebaseFirestore? get _db {
    try {
      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  bool get isAuthenticated {
    try {
      return FirebaseAuth.instance.currentUser != null;
    } catch (_) {
      return false;
    }
  }

  /// Loads every shared recipe from Firestore.
  ///
  /// Recipes are global read-only catalog content, not user-owned documents.
  Future<List<Recipe>> loadAllRecipes() async {
    if (_db == null) {
      throw StateError('Firebase is not available in this app session.');
    }

    if (!isAuthenticated) {
      throw StateError('No signed-in Firebase user was found.');
    }

    try {
      final snapshot = await _db!.collection('recipes').get();

      final recipes = snapshot.docs
          .map((document) => Recipe.fromMap(document.data(), id: document.id))
          .where((recipe) => recipe.title.isNotEmpty)
          .toList();

      recipes.sort((first, second) => first.title.compareTo(second.title));

      return recipes;
    } catch (error, stackTrace) {
      log(
        'loadAllRecipes failed: $error',
        name: 'RecipeRepository',
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  /// Returns one recipe using its Firestore document ID.
  Future<Recipe?> loadRecipeById(String recipeId) async {
    if (_db == null || !isAuthenticated || recipeId.isEmpty) {
      return null;
    }

    try {
      final document = await _db!.collection('recipes').doc(recipeId).get();

      if (!document.exists) {
        return null;
      }

      return Recipe.fromMap(
        document.data() ?? <String, dynamic>{},
        id: document.id,
      );
    } catch (error, stackTrace) {
      log(
        'loadRecipeById failed: $error',
        name: 'RecipeRepository',
        stackTrace: stackTrace,
      );

      return null;
    }
  }
}
