import 'package:cloud_firestore/cloud_firestore.dart';

import 'footprint.dart';

class CarbonCalculationRecord {
  final String calculationId;
  final int schemaVersion;
  final String modelVersion;
  final String factorVersion;
  final CarbonCalculatorInputs inputs;
  final CarbonFootprint footprint;
  final double grossKgCo2e;
  final double removalsKgCo2e;
  final double netKgCo2e;
  final double uncertaintyLowKgCo2e;
  final double uncertaintyHighKgCo2e;
  final DateTime createdAt;

  const CarbonCalculationRecord({
    required this.calculationId,
    required this.schemaVersion,
    required this.modelVersion,
    required this.factorVersion,
    required this.inputs,
    required this.footprint,
    required this.grossKgCo2e,
    required this.removalsKgCo2e,
    required this.netKgCo2e,
    required this.uncertaintyLowKgCo2e,
    required this.uncertaintyHighKgCo2e,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'schemaVersion': schemaVersion,
      'modelVersion': modelVersion,
      'factorVersion': factorVersion,
      'inputs': inputs.toMap(),
      'footprint': footprint.toMap(),
      'grossKgCo2e': grossKgCo2e,
      'removalsKgCo2e': removalsKgCo2e,
      'netKgCo2e': netKgCo2e,
      'uncertaintyLowKgCo2e': uncertaintyLowKgCo2e,
      'uncertaintyHighKgCo2e': uncertaintyHighKgCo2e,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory CarbonCalculationRecord.fromMap(
    Map<String, dynamic> map, {
    String? calculationId,
  }) {
    return CarbonCalculationRecord(
      calculationId: calculationId ?? map['calculationId'] as String? ?? '',
      schemaVersion: (map['schemaVersion'] as num?)?.toInt() ?? 1,
      modelVersion: map['modelVersion'] as String? ?? 'baseline-v1',
      factorVersion: map['factorVersion'] as String? ?? 'hardcoded-v1',
      inputs: CarbonCalculatorInputs.fromMap(_mapValue(map['inputs'])),
      footprint: CarbonFootprint.fromMap(_mapValue(map['footprint'])),
      grossKgCo2e: (map['grossKgCo2e'] as num?)?.toDouble() ?? 0.0,
      removalsKgCo2e: (map['removalsKgCo2e'] as num?)?.toDouble() ?? 0.0,
      netKgCo2e: (map['netKgCo2e'] as num?)?.toDouble() ?? 0.0,
      uncertaintyLowKgCo2e:
          (map['uncertaintyLowKgCo2e'] as num?)?.toDouble() ?? 0.0,
      uncertaintyHighKgCo2e:
          (map['uncertaintyHighKgCo2e'] as num?)?.toDouble() ?? 0.0,
      createdAt: _dateFromMap(map['createdAt']),
    );
  }

  static Map<String, dynamic> _mapValue(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  static DateTime _dateFromMap(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}