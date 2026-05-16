/// Off-grid / educational solar component planner. ClimaShield never instructs
/// users on grid-tie, main-panel, or 240V wiring work; those steps point to
/// licensed electricians and local permitting.
enum SolarComponentKind {
  panel,
  chargeController,
  battery,
  inverter,
  wiring,
  mounting,
  safetyGear,
  monitoring,
}

class SolarComponent {
  final String id;
  final String name;
  final SolarComponentKind kind;
  final double estimatedCostUsd;
  final String purpose;
  final String safetyNotes;
  final int phaseOrder; // 1..n recommended purchase order

  const SolarComponent({
    required this.id,
    required this.name,
    required this.kind,
    required this.estimatedCostUsd,
    required this.purpose,
    required this.safetyNotes,
    required this.phaseOrder,
  });
}

class GardenPlant {
  final String id;
  final String name;
  final String season;
  final String sunlight;
  final String yieldNote;
  final String tip;

  const GardenPlant({
    required this.id,
    required this.name,
    required this.season,
    required this.sunlight,
    required this.yieldNote,
    required this.tip,
  });
}
