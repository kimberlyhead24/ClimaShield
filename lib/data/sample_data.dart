import '../models/climate_action.dart';
import '../models/community.dart';
import '../models/diet_entry.dart';
import '../models/solar.dart';

/// Curated seed content used when Firestore is unreachable or empty. Lets the
/// app feel populated on first launch and during offline development.
class SampleData {
  static final List<ClimateAction> actions = [
    const ClimateAction(
      id: 'a_led_swap',
      title: 'Swap remaining bulbs for LEDs',
      summary:
          'LEDs use ~80% less energy than incandescent bulbs and last 15-25 years.',
      category: ActionCategory.energy,
      co2eKgPerYear: 90,
      difficulty: 1,
      steps: [
        'Inventory remaining incandescent / halogen bulbs.',
        'Match base type (E26, E12, etc.) and lumen output.',
        'Recycle the old bulbs at a hardware store.',
      ],
    ),
    const ClimateAction(
      id: 'a_thermostat',
      title: 'Set thermostat 2°F closer to outside temp',
      summary:
          'Each degree shaved off heating/cooling drops home energy use ~3%.',
      category: ActionCategory.energy,
      co2eKgPerYear: 150,
      difficulty: 1,
    ),
    const ClimateAction(
      id: 'a_cold_wash',
      title: 'Wash laundry in cold water',
      summary: 'About 90% of laundry energy goes to heating water.',
      category: ActionCategory.energy,
      co2eKgPerYear: 150,
      difficulty: 1,
    ),
    const ClimateAction(
      id: 'a_carpool',
      title: 'Carpool or transit twice a week',
      summary:
          'Trading two solo car commutes a week typically removes ~500 kg CO2e/yr.',
      category: ActionCategory.transport,
      co2eKgPerYear: 500,
      difficulty: 2,
    ),
    const ClimateAction(
      id: 'a_skip_flight',
      title: 'Skip one short-haul flight this year',
      summary: 'One avoided short-haul round trip ≈ 250 kg CO2e.',
      category: ActionCategory.transport,
      co2eKgPerYear: 250,
      difficulty: 2,
    ),
    const ClimateAction(
      id: 'a_plantforward',
      title: 'Two plant-forward dinners a week',
      summary:
          'Replacing red-meat dinners with bean/lentil/tofu mains saves big.',
      category: ActionCategory.diet,
      co2eKgPerYear: 300,
      difficulty: 2,
    ),
    const ClimateAction(
      id: 'a_compost',
      title: 'Start composting food scraps',
      summary:
          'Diverts methane-producing waste from landfill and feeds your garden.',
      category: ActionCategory.waste,
      co2eKgPerYear: 90,
      difficulty: 2,
      steps: [
        'Pick a bin: countertop pail + outdoor tumbler or municipal pickup.',
        'Layer greens (scraps) with browns (cardboard, leaves).',
        'Turn weekly; harvest finished compost in 3-6 months.',
      ],
    ),
    const ClimateAction(
      id: 'a_native_garden',
      title: 'Plant a native pollinator patch',
      summary:
          'Native plants sequester carbon in soil and support local pollinators.',
      category: ActionCategory.gardening,
      co2eKgPerYear: 25,
      difficulty: 2,
    ),
    const ClimateAction(
      id: 'a_call_rep',
      title: 'Call a representative about a climate bill',
      summary:
          'Constituent calls are one of the highest-leverage individual climate actions.',
      category: ActionCategory.advocacy,
      co2eKgPerYear: 0,
      difficulty: 1,
    ),
    const ClimateAction(
      id: 'a_diy_window_film',
      title: 'DIY: window insulation film',
      summary:
          'Reduces winter heat loss through windows by ~30% for under \$30.',
      category: ActionCategory.diy,
      co2eKgPerYear: 120,
      difficulty: 2,
      steps: [
        'Measure each window pane.',
        'Clean glass and apply double-sided tape to frame.',
        'Stretch film over tape and shrink with a hair dryer.',
      ],
    ),
    const ClimateAction(
      id: 'a_diy_solar_phone',
      title: 'DIY: small solar charger for phones',
      summary:
          'A 10W panel + USB controller charges phones off-grid. No house wiring required.',
      category: ActionCategory.diy,
      co2eKgPerYear: 10,
      difficulty: 2,
      safetyNote:
          'Stay under 24V DC. Never connect homemade circuits to wall outlets.',
    ),
    const ClimateAction(
      id: 'a_heat_pump',
      title: 'Plan a heat pump upgrade',
      summary:
          'Heat pumps cut heating emissions ~50-70%. Requires sizing + electrical assessment.',
      category: ActionCategory.energy,
      co2eKgPerYear: 2200,
      difficulty: 5,
      requiresProfessional: true,
      safetyNote:
          'HVAC + electrical work must be done by licensed contractors with permits.',
    ),
  ];

  static final List<MealPreset> meals = [
    const MealPreset(
      id: 'm_lentil',
      name: 'Lentil curry & rice',
      emoji: '🍛',
      co2eKgPerServing: 0.4,
      tier: 'best',
    ),
    const MealPreset(
      id: 'm_tofu',
      name: 'Tofu stir-fry',
      emoji: '🥡',
      co2eKgPerServing: 0.5,
      tier: 'best',
    ),
    const MealPreset(
      id: 'm_bean_burrito',
      name: 'Bean burrito',
      emoji: '🌯',
      co2eKgPerServing: 0.7,
      tier: 'best',
    ),
    const MealPreset(
      id: 'm_oat_bowl',
      name: 'Oat & fruit bowl',
      emoji: '🥣',
      co2eKgPerServing: 0.3,
      tier: 'best',
    ),
    const MealPreset(
      id: 'm_veg_pasta',
      name: 'Veggie pasta',
      emoji: '🍝',
      co2eKgPerServing: 0.8,
      tier: 'good',
    ),
    const MealPreset(
      id: 'm_eggs',
      name: 'Eggs & toast',
      emoji: '🍳',
      co2eKgPerServing: 1.2,
      tier: 'good',
    ),
    const MealPreset(
      id: 'm_chicken',
      name: 'Chicken & vegetables',
      emoji: '🍗',
      co2eKgPerServing: 2.5,
      tier: 'fair',
    ),
    const MealPreset(
      id: 'm_fish',
      name: 'Pan-seared fish',
      emoji: '🐟',
      co2eKgPerServing: 3.0,
      tier: 'fair',
    ),
    const MealPreset(
      id: 'm_cheese',
      name: 'Grilled cheese',
      emoji: '🧀',
      co2eKgPerServing: 2.8,
      tier: 'fair',
    ),
    const MealPreset(
      id: 'm_beef',
      name: 'Beef burger',
      emoji: '🍔',
      co2eKgPerServing: 7.0,
      tier: 'high',
    ),
    const MealPreset(
      id: 'm_steak',
      name: 'Steak dinner',
      emoji: '🥩',
      co2eKgPerServing: 10.0,
      tier: 'high',
    ),
    const MealPreset(
      id: 'm_lamb',
      name: 'Lamb chops',
      emoji: '🍖',
      co2eKgPerServing: 12.0,
      tier: 'high',
    ),
  ];

  static List<CommunityPost> posts() => [
        CommunityPost(
          id: 'p1',
          authorName: 'Mira (parent, 2 kids)',
          body:
              'Made the LED swap this weekend — even the laundry room. Felt instantly cheaper.',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          likes: 14,
          tags: const ['energy', 'starter'],
        ),
        CommunityPost(
          id: 'p2',
          authorName: 'Devon',
          body:
              'Anyone else compost in an apartment? My countertop bin keeps fruit flies happy.',
          createdAt: DateTime.now().subtract(const Duration(hours: 9)),
          likes: 6,
          tags: const ['waste', 'question'],
        ),
        CommunityPost(
          id: 'p3',
          authorName: 'Sara',
          body:
              'First two solar panels arrived. Sticking to DC-only off-grid until I can get a licensed electrician for the breaker.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          likes: 22,
          tags: const ['solar', 'diy'],
        ),
        CommunityPost(
          id: 'p4',
          authorName: 'Jen',
          body:
              'Called my rep about HR-xxxx. Took 90 seconds, scripted call worked great.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          likes: 31,
          tags: const ['advocacy'],
        ),
      ];

  static List<Petition> petitions() => [
        const Petition(
          id: 'pt_transit',
          title: 'Expand bus service in our county',
          summary:
              'Funding for two new electric bus routes connecting low-income neighborhoods to job centers.',
          target: 'County Transit Authority',
          signatureGoal: 2500,
          signatureCount: 1840,
          tags: ['transport', 'local'],
        ),
        const Petition(
          id: 'pt_solar_rights',
          title: 'Right to install solar without HOA blocks',
          summary:
              'Codify a homeowner right to install rooftop or balcony solar regardless of HOA restrictions.',
          target: 'State Legislature',
          signatureGoal: 10000,
          signatureCount: 6210,
          tags: ['solar', 'policy'],
        ),
        const Petition(
          id: 'pt_school_garden',
          title: 'School garden program funding',
          summary:
              'Add gardening + climate literacy to K-8 curriculum with a per-school stipend.',
          target: 'School Board',
          signatureGoal: 1500,
          signatureCount: 980,
          tags: ['education', 'gardening'],
        ),
      ];

  static final List<SolarComponent> solarComponents = [
    const SolarComponent(
      id: 's_panel_100w',
      name: '100W monocrystalline panel',
      kind: SolarComponentKind.panel,
      estimatedCostUsd: 90,
      purpose:
          'First panel - powers small DC loads (lights, fans, phone charging).',
      safetyNotes:
          'Keep panels covered until wired. Even one panel can produce shock-level voltage in sunlight.',
      phaseOrder: 1,
    ),
    const SolarComponent(
      id: 's_charge_ctrl',
      name: '20A MPPT charge controller',
      kind: SolarComponentKind.chargeController,
      estimatedCostUsd: 70,
      purpose:
          'Protects the battery and converts panel voltage efficiently to charge it.',
      safetyNotes:
          'Always connect battery before panels. Reversed order can fry the controller.',
      phaseOrder: 2,
    ),
    const SolarComponent(
      id: 's_battery',
      name: '100Ah LiFePO4 battery',
      kind: SolarComponentKind.battery,
      estimatedCostUsd: 260,
      purpose: 'Stores energy for night/cloudy use. Safer chemistry than lead-acid.',
      safetyNotes:
          'Use a fused disconnect. Never short the terminals. Ventilation matters.',
      phaseOrder: 3,
    ),
    const SolarComponent(
      id: 's_fuses',
      name: 'Inline fuses, breakers, cabling',
      kind: SolarComponentKind.safetyGear,
      estimatedCostUsd: 60,
      purpose:
          'Required before energizing - protects wiring from fault currents.',
      safetyNotes:
          'Match fuse rating to wire gauge. Never skip the battery-side fuse.',
      phaseOrder: 4,
    ),
    const SolarComponent(
      id: 's_inverter',
      name: '1000W pure sine inverter',
      kind: SolarComponentKind.inverter,
      estimatedCostUsd: 180,
      purpose: 'Converts DC battery power to 120V AC for off-grid use.',
      safetyNotes:
          'Plug appliances directly into the inverter. Do NOT back-feed wall outlets - that is grid-tie and requires a licensed electrician + permit.',
      phaseOrder: 5,
    ),
    const SolarComponent(
      id: 's_more_panels',
      name: 'Add 2nd & 3rd 100W panels',
      kind: SolarComponentKind.panel,
      estimatedCostUsd: 180,
      purpose: 'Scales daily energy capture. Wire in parallel within controller limits.',
      safetyNotes: 'Recheck wire gauge and fuse sizing when adding capacity.',
      phaseOrder: 6,
    ),
    const SolarComponent(
      id: 's_mounting',
      name: 'Roof or ground mounting kit',
      kind: SolarComponentKind.mounting,
      estimatedCostUsd: 120,
      purpose: 'Permanent placement once design is stable.',
      safetyNotes:
          'Roof penetrations need correct flashing or you will get leaks. Consider a contractor.',
      phaseOrder: 7,
    ),
    const SolarComponent(
      id: 's_monitor',
      name: 'Shunt-based battery monitor',
      kind: SolarComponentKind.monitoring,
      estimatedCostUsd: 80,
      purpose: 'Tracks state of charge so you can size the system honestly.',
      safetyNotes: '',
      phaseOrder: 8,
    ),
  ];

  static final List<GardenPlant> gardenPlants = [
    const GardenPlant(
      id: 'g_tomato',
      name: 'Tomato',
      season: 'Late spring → fall',
      sunlight: 'Full sun (6-8h)',
      yieldNote: '2-4 kg per plant',
      tip: 'Mulch heavily to keep moisture even and prevent blossom-end rot.',
    ),
    const GardenPlant(
      id: 'g_kale',
      name: 'Kale',
      season: 'Spring + fall (cool seasons)',
      sunlight: 'Full to partial sun',
      yieldNote: 'Cut-and-come-again for months',
      tip: 'Sweetens after a light frost. Pick outer leaves first.',
    ),
    const GardenPlant(
      id: 'g_beans',
      name: 'Pole beans',
      season: 'Summer',
      sunlight: 'Full sun',
      yieldNote: 'High protein, low input',
      tip: 'Fixes nitrogen - great rotation crop after heavy feeders.',
    ),
    const GardenPlant(
      id: 'g_potato',
      name: 'Potatoes (bucket grow)',
      season: 'Spring planting',
      sunlight: 'Full sun',
      yieldNote: '2-5 kg per bucket',
      tip: 'Hill soil up the stem as it grows for more tubers.',
    ),
    const GardenPlant(
      id: 'g_herbs',
      name: 'Basil + parsley + mint',
      season: 'Year-round indoors',
      sunlight: 'Bright window or grow light',
      yieldNote: 'Replaces store-bought herbs (high embedded carbon)',
      tip: 'Keep mint in its own pot - it spreads aggressively.',
    ),
  ];
}
