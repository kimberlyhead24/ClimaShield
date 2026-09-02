import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/carbon_calculation_record.dart';
import '../models/climate_action.dart';
import '../models/community.dart';
import '../models/diet_entry.dart';
import '../models/diet_profile.dart';
import '../models/footprint.dart';
import '../models/recipe_model.dart';
import '../models/weekly_meal_plan.dart';

import '../services/meal_plan_generator.dart';
import '../services/diet_baseline_savings.dart';

class ClimaRepository {
  ClimaRepository._();

  static final ClimaRepository instance = ClimaRepository._();

  final List<CompletedAction> _localCompletedActions = [];
  final List<DietLogEntry> _localDietLogs = [];
  final Map<String, WeeklyMealPlan> _localMealPlans = {};
  final List<CommunityPost> _localPosts = [];

  CarbonCalculatorInputs? _localInputs;
  CarbonFootprint? _localFootprint;
  DietProfile? _localDietProfile;

  FirebaseFirestore? get _database {
    try {
      if (Firebase.apps.isEmpty) {
        return null;
      }

      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  String? get _userId {
    try {
      return FirebaseAuth.instance.currentUser?.uid;
    } catch (_) {
      return null;
    }
  }

  bool get isAuthenticated => _userId != null;

  bool get isRemoteAvailable => _database != null && _userId != null;

  DocumentReference<Map<String, dynamic>>? get _userDocument {
    final database = _database;
    final userId = _userId;

    if (database == null || userId == null) {
      return null;
    }

    return database.collection('users').doc(userId);
  }

  Future<List<ClimateAction>> loadActions() async {
    final database = _database;

    if (database == null) {
      return const [];
    }

    try {
      final snapshot = await database
          .collection('actions')
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((document) {
            return ClimateAction.fromMap(document.data(), id: document.id);
          })
          .toList(growable: false);
    } catch (error, stackTrace) {
      log(
        'loadActions failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      return const [];
    }
  }

  Future<List<CompletedAction>> completedActions() async {
    final userDocument = _userDocument;

    if (userDocument == null) {
      return List.unmodifiable(_localCompletedActions);
    }

    try {
      final snapshot = await userDocument
          .collection('completedActions')
          .orderBy('completedAt', descending: true)
          .get();

      return snapshot.docs
          .map((document) {
            return CompletedAction.fromMap(document.data(), id: document.id);
          })
          .toList(growable: false);
    } catch (error, stackTrace) {
      log(
        'completedActions failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      return List.unmodifiable(_localCompletedActions);
    }
  }

  Future<void> markActionComplete(ClimateAction action) async {
    final entry = CompletedAction(
      actionId: action.id,
      completedAt: DateTime.now(),
      annualCo2eReductionKg: action.co2eKgPerYear,
      category: action.primaryCategory.name,
    );

    _localCompletedActions.removeWhere(
      (completedAction) => completedAction.actionId == action.id,
    );
    _localCompletedActions.insert(0, entry);

    final userDocument = _userDocument;

    if (userDocument == null) {
      return;
    }

    try {
      await userDocument.collection('completedActions').doc(action.id).set({
        'actionId': action.id,
        'category': action.primaryCategory.name,
        'annualCo2eReductionKg': action.co2eKgPerYear,
        'completedAt': FieldValue.serverTimestamp(),
      });
    } catch (error, stackTrace) {
      log(
        'markActionComplete failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<double> totalNonDietActionSavingsKg() async {
    final entries = await completedActions();

    return entries
        .where((entry) => entry.category != 'diet')
        .fold<double>(0, (total, entry) => total + entry.annualCo2eReductionKg);
  }

  Future<Map<String, double>> co2eSavedByCategory() async {
    final entries = await completedActions();
    final totals = <String, double>{};

    for (final entry in entries) {
      final category = entry.category.isEmpty ? 'other' : entry.category;

      totals[category] = (totals[category] ?? 0) + entry.annualCo2eReductionKg;
    }

    return totals;
  }

  Future<CarbonCalculatorInputs?> loadInputs() async {
    final userDocument = _userDocument;

    if (userDocument == null) {
      return _localInputs;
    }

    try {
      final document = await userDocument
          .collection('meta')
          .doc('inputs')
          .get();

      if (!document.exists) {
        return _localInputs;
      }

      return CarbonCalculatorInputs.fromMap(document.data() ?? {});
    } catch (error, stackTrace) {
      log(
        'loadInputs failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      return _localInputs;
    }
  }

  Future<CarbonFootprint?> loadFootprint() async {
    final userDocument = _userDocument;

    if (userDocument == null) {
      return _localFootprint;
    }

    try {
      final document = await userDocument
          .collection('meta')
          .doc('footprint')
          .get();

      if (!document.exists) {
        return _localFootprint;
      }

      return CarbonFootprint.fromMap(document.data() ?? {});
    } catch (error, stackTrace) {
      log(
        'loadFootprint failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      return _localFootprint;
    }
  }

  Future<void> saveCalculation(
    CarbonCalculatorInputs inputs,
    CarbonFootprint footprint,
  ) async {
    _localInputs = inputs;
    _localFootprint = footprint;

    final database = _database;
    final userDocument = _userDocument;

    if (database == null || userDocument == null) {
      return;
    }

    try {
      final batch = database.batch();

      batch.set(userDocument.collection('meta').doc('inputs'), inputs.toMap());
      batch.set(
        userDocument.collection('meta').doc('footprint'),
        footprint.toMap(),
      );

      await batch.commit();
    } catch (error, stackTrace) {
      log(
        'saveCalculation failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> clearFootprintData() async {
    _localInputs = null;
    _localFootprint = null;

    final database = _database;
    final userDocument = _userDocument;

    if (database == null || userDocument == null) {
      return;
    }

    try {
      final batch = database.batch();

      batch.delete(userDocument.collection('meta').doc('inputs'));
      batch.delete(userDocument.collection('meta').doc('footprint'));

      await batch.commit();
    } catch (error, stackTrace) {
      log(
        'clearFootprintData failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> saveCalculationWithRecord(
    CarbonCalculatorInputs inputs,
    CarbonFootprint footprint,
    CarbonCalculationRecord record,
  ) async {
    _localInputs = inputs;
    _localFootprint = footprint;

    final database = _database;
    final userDocument = _userDocument;

    if (database == null || userDocument == null) {
      return;
    }

    try {
      final batch = database.batch();

      batch.set(userDocument.collection('meta').doc('inputs'), inputs.toMap());
      batch.set(
        userDocument.collection('meta').doc('footprint'),
        footprint.toMap(),
      );
      batch.set(
        userDocument.collection('carbonCalculations').doc(record.calculationId),
        record.toMap(),
      );

      await batch.commit();
    } catch (error, stackTrace) {
      log(
        'saveCalculationWithRecord failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> saveCarbonCalculation(CarbonCalculationRecord record) async {
    final userDocument = _userDocument;

    if (userDocument == null) {
      return;
    }

    try {
      await userDocument
          .collection('carbonCalculations')
          .doc(record.calculationId)
          .set(record.toMap());
    } catch (error, stackTrace) {
      log(
        'saveCarbonCalculation failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<CarbonCalculationRecord?> loadLatestCarbonCalculation() async {
    final userDocument = _userDocument;

    if (userDocument == null) {
      return null;
    }

    try {
      final snapshot = await userDocument
          .collection('carbonCalculations')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final document = snapshot.docs.first;

      return CarbonCalculationRecord.fromMap({
        ...document.data(),
        'calculationId': document.id,
      });
    } catch (error, stackTrace) {
      log(
        'loadLatestCarbonCalculation failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<List<CarbonCalculationRecord>> loadCarbonCalculationHistory({
    int limit = 20,
  }) async {
    final userDocument = _userDocument;

    if (userDocument == null) {
      return const [];
    }

    try {
      final snapshot = await userDocument
          .collection('carbonCalculations')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((document) {
            return CarbonCalculationRecord.fromMap({
              ...document.data(),
              'calculationId': document.id,
            });
          })
          .toList(growable: false);
    } catch (error, stackTrace) {
      log(
        'loadCarbonCalculationHistory failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      return const [];
    }
  }

  Future<DietProfile?> loadDietProfile() async {
    final userDocument = _userDocument;

    if (userDocument == null) {
      return _localDietProfile;
    }

    try {
      final document = await userDocument
          .collection('dietProfile')
          .doc('current')
          .get();

      if (!document.exists) {
        return _localDietProfile;
      }

      final profile = DietProfile.fromMap(document.data() ?? {});

      _localDietProfile = profile;
      return profile;
    } catch (error, stackTrace) {
      log(
        'loadDietProfile failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      return _localDietProfile;
    }
  }

  Future<void> saveDietProfile(DietProfile profile) async {
    _localDietProfile = profile;

    final userDocument = _userDocument;

    if (userDocument == null) {
      return;
    }

    try {
      await userDocument
          .collection('dietProfile')
          .doc('current')
          .set(profile.toMap());
    } catch (error, stackTrace) {
      log(
        'saveDietProfile failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<List<DietLogEntry>> dietLog({int? days}) async {
    final cutoff = days == null
        ? null
        : DateTime.now().subtract(Duration(days: days));

    final userDocument = _userDocument;

    if (userDocument == null) {
      return _localDietLogs
          .where((entry) => cutoff == null || entry.loggedAt.isAfter(cutoff))
          .toList(growable: false);
    }

    try {
      final snapshot = await userDocument
          .collection('dietLog')
          .orderBy('loggedAt', descending: true)
          .limit(200)
          .get();

      return snapshot.docs
          .map((document) {
            return DietLogEntry.fromMap(document.data(), id: document.id);
          })
          .where((entry) {
            return cutoff == null || entry.loggedAt.isAfter(cutoff);
          })
          .toList(growable: false);
    } catch (error, stackTrace) {
      log(
        'dietLog failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      return List.unmodifiable(_localDietLogs);
    }
  }

  Future<void> logRecipeMeal(
    Recipe recipe, {
    required int servings,
    DateTime? plannedForDate,
  }) async {
    final safeServings = servings < 1 ? 1 : servings;

    final profile = await loadDietProfile();
    final footprint = await loadFootprint();

    if (profile == null || footprint == null) {
      throw StateError(
        'Complete your diet quiz and carbon calculation before logging a meal.',
      );
    }

    final baselineCo2eKgPerServing =
        DietBaselineSavings.baselineCo2eKgPerServing(
          annualDietCo2eKg: footprint.dietKg,
          totalMealsEatenPerWeek: profile.totalMealsEatenPerWeek,
          householdSize: profile.householdSize,
        );

    final recipeCo2eKgPerServing = recipe.climateImpact.co2eKgPerServing ?? 0;

    final creditableServings = DietBaselineSavings.creditableServings(
      servingsLogged: safeServings,
      householdSize: profile.householdSize,
    );

    final estimatedSavingsKg = DietBaselineSavings.estimatedCo2eSavingsKg(
      baselineCo2eKgPerServing: baselineCo2eKgPerServing,
      recipeCo2eKgPerServing: recipeCo2eKgPerServing,
      servingsLogged: safeServings,
      householdSize: profile.householdSize,
    );

    final estimatedSavingsKgPerServing = creditableServings == 0
        ? 0.0
        : estimatedSavingsKg / creditableServings;

    final entry = DietLogEntry(
      recipeId: recipe.id,
      recipeName: recipe.title,
      servings: creditableServings,
      estimatedSavingsKgPerServing: estimatedSavingsKgPerServing,
      estimatedSavingsKg: estimatedSavingsKg,
      comparisonBaseline:
          'Your household’s average diet baseline of '
          '${baselineCo2eKgPerServing.toStringAsFixed(2)} kg CO₂e per serving',
      plannedForDate: plannedForDate,
      loggedAt: DateTime.now(),
    );

    _localDietLogs.insert(0, entry);

    final userDocument = _userDocument;

    if (userDocument == null) {
      return;
    }

    try {
      await userDocument.collection('dietLog').add(entry.toMap());
    } catch (error, stackTrace) {
      log(
        'logRecipeMeal failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<double> totalDietSavingsKg({int? days}) async {
    final entries = await dietLog(days: days);

    return entries.fold<double>(
      0,
      (total, entry) => total + entry.estimatedSavingsKg,
    );
  }

  DateTime mondayFor(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);

    return normalized.subtract(
      Duration(days: normalized.weekday - DateTime.monday),
    );
  }

  String weekPlanId(DateTime weekStart) {
    final year = weekStart.year.toString().padLeft(4, '0');
    final month = weekStart.month.toString().padLeft(2, '0');
    final day = weekStart.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Future<WeeklyMealPlan?> loadWeeklyMealPlan({DateTime? date}) async {
    final weekStart = mondayFor(date ?? DateTime.now());
    final planId = weekPlanId(weekStart);

    final userDocument = _userDocument;

    if (userDocument == null) {
      return _localMealPlans[planId];
    }

    try {
      final document = await userDocument
          .collection('mealPlans')
          .doc(planId)
          .get();

      if (!document.exists) {
        return _localMealPlans[planId];
      }

      final plan = WeeklyMealPlan.fromMap(
        document.data() ?? <String, dynamic>{},
        id: document.id,
      );

      _localMealPlans[planId] = plan;
      return plan;
    } catch (error, stackTrace) {
      log(
        'loadWeeklyMealPlan failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      return _localMealPlans[planId];
    }
  }

  Future<bool> saveWeeklyMealPlan(WeeklyMealPlan plan) async {
    _localMealPlans[plan.id] = plan;

    final userDocument = _userDocument;

    if (userDocument == null) {
      return true;
    }

    try {
      await userDocument.collection('mealPlans').doc(plan.id).set(plan.toMap());

      return true;
    } catch (error, stackTrace) {
      log(
        'saveWeeklyMealPlan failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<MealPlanGenerationResult> generateWeeklyMealPlan({
    required List<Recipe> recipes,
    required DateTime date,
  }) async {
    final profile = await loadDietProfile();

    if (profile == null) {
      throw StateError('Complete the diet quiz before generating a meal plan.');
    }

    final weekStart = mondayFor(date);

    final result = MealPlanGenerator.generate(
      recipes: recipes,
      profile: profile,
      weekStart: weekStart,
    );

    final saved = await saveWeeklyMealPlan(result.plan);

    if (!saved) {
      throw StateError(
        'Your meal plan was generated but could not be saved. Please try again.',
      );
    }

    return result;
  }

  Future<List<CommunityPost>> communityPosts() async {
    final database = _database;

    if (database == null) {
      return List.unmodifiable(_localPosts);
    }

    try {
      final snapshot = await database
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(100)
          .get();

      return snapshot.docs
          .map((document) {
            return CommunityPost.fromMap(document.data(), id: document.id);
          })
          .toList(growable: false);
    } catch (error, stackTrace) {
      log(
        'communityPosts failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      return List.unmodifiable(_localPosts);
    }
  }

  Future<CommunityPost> createPost(
    String body, {
    required String authorName,
    List<String> tags = const [],
  }) async {
    final localPost = CommunityPost(
      id: 'local${DateTime.now().millisecondsSinceEpoch}',
      authorName: authorName,
      authorId: _userId,
      body: body,
      createdAt: DateTime.now(),
      tags: tags,
    );

    _localPosts.insert(0, localPost);

    final database = _database;

    if (database == null) {
      return localPost;
    }

    try {
      final reference = await database
          .collection('posts')
          .add(localPost.toMap());

      return localPost.copyWith(id: reference.id);
    } catch (error, stackTrace) {
      log(
        'createPost failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
      return localPost;
    }
  }

  Future<void> likePost(String postId) async {
    final localIndex = _localPosts.indexWhere((post) => post.id == postId);

    if (localIndex >= 0) {
      _localPosts[localIndex] = _localPosts[localIndex].copyWith(
        likes: _localPosts[localIndex].likes + 1,
      );
    }

    final database = _database;

    if (database == null) {
      return;
    }

    try {
      await database.collection('posts').doc(postId).update({
        'likes': FieldValue.increment(1),
      });
    } catch (error, stackTrace) {
      log(
        'likePost failed: $error',
        name: 'ClimaRepository',
        stackTrace: stackTrace,
      );
    }
  }
}
