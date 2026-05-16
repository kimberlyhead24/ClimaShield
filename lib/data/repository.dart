import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/climate_action.dart';
import '../models/community.dart';
import '../models/diet_entry.dart';
import '../models/footprint.dart';
import 'sample_data.dart';

/// Thin data layer with two modes:
/// - Firestore (when a user is signed in and Firebase initialized OK)
/// - In-memory fallback seeded from [SampleData] for offline / dev runs
///
/// All UI talks to a single [ClimaRepository] instance via the static
/// [ClimaRepository.instance] so screens stay simple. Reads always succeed -
/// fallback data fills in when remote calls fail or auth is missing.
class ClimaRepository {
  ClimaRepository._();
  static final ClimaRepository instance = ClimaRepository._();

  FirebaseFirestore? get _db {
    try {
      return Firebase.apps.isEmpty ? null : FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  String? get _uid {
    try {
      return FirebaseAuth.instance.currentUser?.uid;
    } catch (_) {
      return null;
    }
  }

  bool get isAuthenticated => _uid != null;
  bool get isRemoteAvailable => _db != null && isAuthenticated;

  // --- In-memory caches used when offline / unauthenticated ---
  final List<CompletedAction> _localCompleted = [];
  final List<DietLogEntry> _localDietLog = [];
  CarbonCalculatorInputs? _localInputs;
  CarbonFootprint? _localFootprint;
  late final List<CommunityPost> _localPosts = SampleData.posts();
  late final List<Petition> _localPetitions = SampleData.petitions();
  final Set<String> _signedPetitions = {};

  // ----- Actions -----
  List<ClimateAction> allActions() => SampleData.actions;

  Future<List<CompletedAction>> completedActions() async {
    if (!isRemoteAvailable) return List.unmodifiable(_localCompleted);
    try {
      final snap = await _db!
          .collection('users')
          .doc(_uid)
          .collection('completedActions')
          .orderBy('completedAt', descending: true)
          .get();
      return snap.docs.map((d) => CompletedAction.fromMap(d.data())).toList();
    } catch (e) {
      log('completedActions remote failed: $e', name: 'ClimaRepository');
      return List.unmodifiable(_localCompleted);
    }
  }

  Future<void> markActionComplete(ClimateAction a) async {
    final entry = CompletedAction(
      actionId: a.id,
      completedAt: DateTime.now(),
      co2eKgSaved: a.co2eKgPerYear,
    );
    _localCompleted.insert(0, entry);
    if (!isRemoteAvailable) return;
    try {
      await _db!
          .collection('users')
          .doc(_uid)
          .collection('completedActions')
          .add(entry.toMap());
    } catch (e) {
      log('markActionComplete remote failed: $e', name: 'ClimaRepository');
    }
  }

  // ----- Footprint -----
  Future<CarbonCalculatorInputs?> loadInputs() async {
    if (!isRemoteAvailable) return _localInputs;
    try {
      final doc =
          await _db!.collection('users').doc(_uid).collection('meta').doc('inputs').get();
      if (!doc.exists) return _localInputs;
      return CarbonCalculatorInputs.fromMap(doc.data() ?? {});
    } catch (e) {
      log('loadInputs failed: $e', name: 'ClimaRepository');
      return _localInputs;
    }
  }

  Future<CarbonFootprint?> loadFootprint() async {
    if (!isRemoteAvailable) return _localFootprint;
    try {
      final doc = await _db!
          .collection('users')
          .doc(_uid)
          .collection('meta')
          .doc('footprint')
          .get();
      if (!doc.exists) return _localFootprint;
      return CarbonFootprint.fromMap(doc.data() ?? {});
    } catch (e) {
      log('loadFootprint failed: $e', name: 'ClimaRepository');
      return _localFootprint;
    }
  }

  Future<void> saveCalculation(
      CarbonCalculatorInputs inputs, CarbonFootprint footprint) async {
    _localInputs = inputs;
    _localFootprint = footprint;
    if (!isRemoteAvailable) return;
    try {
      final batch = _db!.batch();
      final inputsRef =
          _db!.collection('users').doc(_uid).collection('meta').doc('inputs');
      final fpRef =
          _db!.collection('users').doc(_uid).collection('meta').doc('footprint');
      batch.set(inputsRef, inputs.toMap());
      batch.set(fpRef, footprint.toMap());
      await batch.commit();
    } catch (e) {
      log('saveCalculation remote failed: $e', name: 'ClimaRepository');
    }
  }

  // ----- Diet -----
  Future<List<DietLogEntry>> dietLog({int? days}) async {
    final cutoff = days == null
        ? null
        : DateTime.now().subtract(Duration(days: days));
    if (!isRemoteAvailable) {
      return _localDietLog
          .where((e) => cutoff == null || e.loggedAt.isAfter(cutoff))
          .toList();
    }
    try {
      final snap = await _db!
          .collection('users')
          .doc(_uid)
          .collection('dietLog')
          .orderBy('loggedAt', descending: true)
          .limit(200)
          .get();
      return snap.docs.map((d) => DietLogEntry.fromMap(d.data())).where((e) {
        return cutoff == null || e.loggedAt.isAfter(cutoff);
      }).toList();
    } catch (e) {
      log('dietLog remote failed: $e', name: 'ClimaRepository');
      return List.unmodifiable(_localDietLog);
    }
  }

  Future<void> logMeal(MealPreset preset) async {
    final entry = DietLogEntry(
      mealPresetId: preset.id,
      name: preset.name,
      co2eKg: preset.co2eKgPerServing,
      loggedAt: DateTime.now(),
    );
    _localDietLog.insert(0, entry);
    if (!isRemoteAvailable) return;
    try {
      await _db!
          .collection('users')
          .doc(_uid)
          .collection('dietLog')
          .add(entry.toMap());
    } catch (e) {
      log('logMeal remote failed: $e', name: 'ClimaRepository');
    }
  }

  // ----- Community -----
  Future<List<CommunityPost>> communityPosts() async {
    if (!isRemoteAvailable) return List.unmodifiable(_localPosts);
    try {
      final snap = await _db!
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(100)
          .get();
      if (snap.docs.isEmpty) return List.unmodifiable(_localPosts);
      return snap.docs.map((d) => CommunityPost.fromMap(d.data())).toList();
    } catch (e) {
      log('communityPosts remote failed: $e', name: 'ClimaRepository');
      return List.unmodifiable(_localPosts);
    }
  }

  Future<CommunityPost> createPost(String body, {required String authorName, List<String> tags = const []}) async {
    final post = CommunityPost(
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      authorName: authorName,
      authorId: _uid,
      body: body,
      createdAt: DateTime.now(),
      tags: tags,
    );
    _localPosts.insert(0, post);
    if (isRemoteAvailable) {
      try {
        await _db!.collection('posts').add(post.toMap());
      } catch (e) {
        log('createPost remote failed: $e', name: 'ClimaRepository');
      }
    }
    return post;
  }

  Future<void> likePost(String id) async {
    final idx = _localPosts.indexWhere((p) => p.id == id);
    if (idx >= 0) {
      _localPosts[idx] = _localPosts[idx].copyWith(likes: _localPosts[idx].likes + 1);
    }
    if (isRemoteAvailable) {
      try {
        await _db!.collection('posts').doc(id).update({
          'likes': FieldValue.increment(1),
        });
      } catch (_) {/* local-only post or offline */}
    }
  }

  // ----- Petitions -----
  Future<List<Petition>> petitions() async {
    if (!isRemoteAvailable) return List.unmodifiable(_localPetitions);
    try {
      final snap = await _db!.collection('petitions').get();
      if (snap.docs.isEmpty) return List.unmodifiable(_localPetitions);
      return snap.docs.map((d) => Petition.fromMap(d.data())).toList();
    } catch (e) {
      log('petitions remote failed: $e', name: 'ClimaRepository');
      return List.unmodifiable(_localPetitions);
    }
  }

  bool hasSigned(String petitionId) => _signedPetitions.contains(petitionId);

  Future<void> signPetition(Petition p) async {
    if (_signedPetitions.contains(p.id)) return;
    _signedPetitions.add(p.id);
    final idx = _localPetitions.indexWhere((q) => q.id == p.id);
    if (idx >= 0) {
      _localPetitions[idx] =
          _localPetitions[idx].copyWith(signatureCount: _localPetitions[idx].signatureCount + 1);
    }
    if (isRemoteAvailable) {
      try {
        await _db!.collection('petitions').doc(p.id).update({
          'signatureCount': FieldValue.increment(1),
        });
        await _db!
            .collection('users')
            .doc(_uid)
            .collection('signedPetitions')
            .doc(p.id)
            .set({'signedAt': Timestamp.now()});
      } catch (e) {
        log('signPetition remote failed: $e', name: 'ClimaRepository');
      }
    }
  }

  /// Computes lifetime kg saved by completed actions (annualized estimate).
  Future<double> totalCo2eSavedKg() async {
    final list = await completedActions();
    return list.fold<double>(0, (acc, c) => acc + c.co2eKgSaved);
  }
}
