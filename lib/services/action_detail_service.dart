// lib/services/action_detail_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActionDetailService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetches the action and resolves all {{placeholder}} tokens
  /// using the user's state from their profile + the solar_data collection.
  Future<Map<String, dynamic>> getResolvedAction(String actionId) async {
    // 1. Load the action document
    final actionDoc = await _db.collection('actions').doc(actionId).get();
    if (!actionDoc.exists) throw Exception('Action not found: $actionId');
    final action = Map<String, dynamic>.from(actionDoc.data()!);

    // 2. Only resolve if this action uses location data
    if (action['uses_location_data'] != true) return action;

    // 3. Get user's state code from their profile
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return action; // not logged in — return raw

    final userDoc = await _db.collection('users').doc(uid).get();
    final stateCode = userDoc.data()?['state_code'] as String?;
    if (stateCode == null) return action; // no location set — return raw

    // 4. Load solar data for that state
    final solarDoc = await _db.collection('solar_data').doc(stateCode).get();
    if (!solarDoc.exists) return action;
    final solar = solarDoc.data()!;

    // 5. Build the replacement map
    final double peakSunHours = (solar['peak_sun_hours'] as num).toDouble();
    final double gridFactor = (solar['grid_emissions_factor'] as num)
        .toDouble();
    final int annualKwh = (solar['annual_kwh'] as num).toInt();
    final int co2ePerYear = (solar['co2e_reduction_per_year_kg'] as num)
        .toInt();
    final String stateName = solar['state'] as String;

    final replacements = {
      '{{state}}': stateName,
      '{{peak_sun_hours}}': peakSunHours.toStringAsFixed(1),
      '{{annual_kwh}}': annualKwh.toString(),
      '{{co2e_reduction_per_year_kg}}': co2ePerYear.toString(),
      '{{grid_emissions_factor}}': gridFactor.toStringAsFixed(3),
      '{{tilt_angle}}': _latitudeForState(stateCode).toStringAsFixed(0),
      '{{trees_equivalent}}': (co2ePerYear / 22).round().toString(),
      // Step 3: 200W panel daily output
      '{{step3_daily_wh}}': (peakSunHours * 200).round().toString(),
      // Step 4: 7kW system annual output and CO2e
      '{{step4_annual_kwh}}': (peakSunHours * 7000 * 0.365).round().toString(),
      '{{step4_co2e}}': ((peakSunHours * 7000 * 0.365) * gridFactor)
          .round()
          .toString(),
      // Example calculations for step-by-step guides
      '{{panels_needed_example}}': (30 / peakSunHours).toStringAsFixed(1),
      '{{system_size_example}}': (30 / peakSunHours).toStringAsFixed(1),
      '{{panel_count_example}}': ((30 / peakSunHours * 1000) / 400)
          .ceil()
          .toString(),
    };

    // 6. Resolve all string fields recursively
    return _resolveMap(action, replacements);
  }

  Map<String, dynamic> _resolveMap(
    Map<String, dynamic> map,
    Map<String, String> replacements,
  ) {
    return map.map((key, value) {
      if (value is String) {
        return MapEntry(key, _resolveString(value, replacements));
      } else if (value is List) {
        return MapEntry(key, _resolveList(value, replacements));
      } else if (value is Map<String, dynamic>) {
        return MapEntry(key, _resolveMap(value, replacements));
      }
      return MapEntry(key, value);
    });
  }

  List<dynamic> _resolveList(
    List<dynamic> list,
    Map<String, String> replacements,
  ) {
    return list.map((item) {
      if (item is String) return _resolveString(item, replacements);
      if (item is List) return _resolveList(item, replacements);
      if (item is Map<String, dynamic>) return _resolveMap(item, replacements);
      return item;
    }).toList();
  }

  String _resolveString(String text, Map<String, String> replacements) {
    String result = text;
    for (final entry in replacements.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }

  /// Approximate latitude per state for panel tilt angle recommendation.
  /// Tilt ≈ latitude for year-round optimization.
  double _latitudeForState(String code) {
    const latitudes = {
      'AL': 32.8,
      'AK': 64.2,
      'AZ': 34.0,
      'AR': 34.8,
      'CA': 36.8,
      'CO': 39.5,
      'CT': 41.6,
      'DE': 39.0,
      'FL': 27.8,
      'GA': 32.2,
      'HI': 20.8,
      'ID': 44.5,
      'IL': 40.6,
      'IN': 40.3,
      'IA': 42.0,
      'KS': 38.5,
      'KY': 37.8,
      'LA': 31.2,
      'ME': 45.3,
      'MD': 39.0,
      'MA': 42.3,
      'MI': 44.3,
      'MN': 46.4,
      'MS': 32.7,
      'MO': 38.4,
      'MT': 46.9,
      'NE': 41.5,
      'NV': 39.5,
      'NH': 43.7,
      'NJ': 40.1,
      'NM': 34.5,
      'NY': 42.9,
      'NC': 35.8,
      'ND': 47.5,
      'OH': 40.4,
      'OK': 35.6,
      'OR': 44.6,
      'PA': 41.2,
      'RI': 41.7,
      'SC': 33.8,
      'SD': 44.4,
      'TN': 35.9,
      'TX': 31.5,
      'UT': 39.3,
      'VT': 44.0,
      'VA': 37.8,
      'WA': 47.4,
      'WV': 38.6,
      'WI': 44.5,
      'WY': 43.0,
      'DC': 38.9,
    };
    return latitudes[code] ?? 40.0;
  }
}
