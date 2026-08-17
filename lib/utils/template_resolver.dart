import 'package:cloud_firestore/cloud_firestore.dart';

class TemplateResolver {
  /// Fetches solar data for [stateCode] (e.g. "IL") and replaces
  /// {location}, {peak_sun_hours}, {annual_kwh}, {co2e_reduction_per_year_kg}
  /// in any string field of the action.
  static Future<String> resolve(String template, String stateCode) async {
    // If no placeholders exist, skip the Firestore call entirely
    if (!template.contains('{')) return template;

    final doc = await FirebaseFirestore.instance
        .collection('solar_data')
        .doc(stateCode)
        .get();

    if (!doc.exists) return template; // graceful fallback

    final data = doc.data()!;

    return template
        .replaceAll('{location}', '${data['state']}')
        .replaceAll('{peak_sun_hours}', '${data['peak_sun_hours']}')
        .replaceAll('{annual_kwh}', '${data['annual_kwh']}')
        .replaceAll(
          '{co2e_reduction_per_year_kg}',
          '${data['co2e_reduction_per_year_kg']}',
        );
  }
}
