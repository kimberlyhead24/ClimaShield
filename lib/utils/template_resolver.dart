import 'package:cloud_firestore/cloud_firestore.dart';

class TemplateResolver {
  /// Fetches solar data for [stateCode] (e.g. "IL") and replaces
  /// {location}, {peakSunHours}, {annualKwh}, {co2eReductionPerYearKg}
  /// in any string field of the action.
  static Future<String> resolve(String template, String stateCode) async {
    // If no placeholders exist, skip the Firestore call entirely
    if (!template.contains('{')) return template;

    final doc = await FirebaseFirestore.instance
        .collection('solarData')
        .doc(stateCode)
        .get();

    if (!doc.exists) return template; // graceful fallback

    final data = doc.data()!;

    return template
        .replaceAll('{location}', '${data['state']}')
        .replaceAll('{peakSunHours}', '${data['peakSunHours']}')
        .replaceAll('{annualKwh}', '${data['annualKwh']}')
        .replaceAll(
          '{co2eReductionPerYearKg}',
          '${data['co2eReductionPerYearKg']}',
        );
  }
}
