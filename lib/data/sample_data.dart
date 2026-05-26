import '../models/climate_action.dart';
import '../models/community.dart';
import '../models/diet_entry.dart';

/// Curated seed content used when Firestore is unreachable or empty. Lets the
/// app feel populated on first launch and during offline development.
class SampleData {
  static final List<ClimateAction> actions = [
    // ── Energy ──────────────────────────────────────────────────────────────
    const ClimateAction(
      id: 'a_led_swap',
      name: 'Swap remaining bulbs for LEDs',
      description:
          'LEDs use ~80% less energy than incandescent bulbs and last 15-25 years.',
      categories: [ActionCategory.energy],
      environmentalImpactAreas: ['Energy reduction', 'Cost savings'],
      costEstimate: r'$',
      difficulty: 'Easy',
      impactScore: ActionImpactScore(co2eReductionPerYearKg: 90),
      isMvpAction: true,
      stepByStepGuide: [
        'Inventory remaining incandescent / halogen bulbs.',
        'Match base type (E26, E12, etc.) and lumen output.',
        'Recycle the old bulbs at a hardware store.',
      ],
    ),
    const ClimateAction(
      id: 'a_thermostat',
      name: 'Set thermostat 2°F closer to outside temp',
      description:
          'Each degree shaved off heating/cooling drops home energy use ~3%.',
      categories: [ActionCategory.energy],
      environmentalImpactAreas: ['Energy reduction'],
      costEstimate: r'$',
      difficulty: 'Easy',
      impactScore: ActionImpactScore(co2eReductionPerYearKg: 150),
      isMvpAction: true,
    ),
    const ClimateAction(
      id: 'a_cold_wash',
      name: 'Wash laundry in cold water',
      description: 'About 90% of laundry energy goes to heating water.',
      categories: [ActionCategory.energy],
      environmentalImpactAreas: ['Energy reduction', 'Water savings'],
      costEstimate: r'$',
      difficulty: 'Easy',
      impactScore: ActionImpactScore(co2eReductionPerYearKg: 150),
      isMvpAction: true,
    ),
    const ClimateAction(
      id: 'a_heat_pump',
      name: 'Plan a heat pump upgrade',
      description:
          'Heat pumps cut heating emissions ~50-70%. Requires sizing + electrical assessment.',
      categories: [ActionCategory.energy],
      environmentalImpactAreas: ['Emissions reduction', 'Energy efficiency'],
      costEstimate: r'$$$$',
      difficulty: 'Hard',
      impactScore: ActionImpactScore(co2eReductionPerYearKg: 2200),
      requiresProfessional: true,
      safetyNote:
          'HVAC + electrical work must be done by licensed contractors with permits.',
    ),

    // ── Transport ────────────────────────────────────────────────────────────
    const ClimateAction(
      id: 'a_carpool',
      name: 'Carpool or transit twice a week',
      description:
          'Trading two solo car commutes a week typically removes ~500 kg CO2e/yr.',
      categories: [ActionCategory.transport],
      environmentalImpactAreas: ['Emissions reduction'],
      costEstimate: r'$',
      difficulty: 'Medium',
      impactScore: ActionImpactScore(co2eReductionPerYearKg: 500),
      isMvpAction: true,
    ),
    const ClimateAction(
      id: 'a_skip_flight',
      name: 'Skip one short-haul flight this year',
      description: 'One avoided short-haul round trip ≈ 250 kg CO2e.',
      categories: [ActionCategory.transport],
      environmentalImpactAreas: ['Emissions reduction'],
      costEstimate: r'$',
      difficulty: 'Medium',
      impactScore: ActionImpactScore(co2eReductionPerYearKg: 250),
    ),
    const ClimateAction(
      id: 'a_ev_switch',
      name: 'Switch to an EV or hybrid for next vehicle',
      description:
          'An average EV in the US saves ~1,500 kg CO2e per year vs. a gas car.',
      categories: [ActionCategory.transport],
      environmentalImpactAreas: ['Emissions reduction'],
      costEstimate: r'$$$$',
      difficulty: 'Hard',
      impactScore: ActionImpactScore(co2eReductionPerYearKg: 1500),
      scientificBasis:
          'Based on EPA average grid emissions and 12,000 miles/year driving.',
    ),

    // ── Diet ─────────────────────────────────────────────────────────────────
    const ClimateAction(
      id: 'a_plantforward',
      name: 'Two plant-forward dinners a week',
      description:
          'Replacing red-meat dinners with bean/lentil/tofu mains saves big.',
      categories: [ActionCategory.diet],
      environmentalImpactAreas: ['Emissions reduction', 'Land use'],
      costEstimate: r'$',
      difficulty: 'Medium',
      impactScore: ActionImpactScore(co2eReductionPerYearKg: 300),
      isMvpAction: true,
    ),
    const ClimateAction(
      id: 'a_food_waste',
      name: 'Cut household food waste by half',
      description:
          'The average US household wastes ~30% of food purchased. Meal planning cuts emissions and grocery bills.',
      categories: [ActionCategory.diet, ActionCategory.waste],
      environmentalImpactAreas: ['Waste diversion', 'Emissions reduction'],
      costEstimate: r'$',
      difficulty: 'Medium',
      impactScore: ActionImpactScore(
        co2eReductionPerYearKg: 200,
        wasteDivertedKg: 90,
      ),
      stepByStepGuide: [
        'Plan meals for the week before shopping.',
        'Store produce correctly to extend shelf life.',
        'Use "eat first" shelf in fridge for items near expiry.',
      ],
    ),

    // ── Waste ────────────────────────────────────────────────────────────────
    const ClimateAction(
      id: 'a_compost',
      name: 'Start composting food scraps',
      description:
          'Diverts methane-producing waste from landfill and feeds your garden.',
      categories: [ActionCategory.waste],
      environmentalImpactAreas: ['Waste diversion', 'Soil health'],
      costEstimate: r'$',
      difficulty: 'Medium',
      impactScore: ActionImpactScore(
        co2eReductionPerYearKg: 90,
        wasteDivertedKg: 50,
      ),
      stepByStepGuide: [
        'Pick a bin: countertop pail + outdoor tumbler or municipal pickup.',
        'Layer greens (scraps) with browns (cardboard, leaves).',
        'Turn weekly; harvest finished compost in 3-6 months.',
      ],
    ),
    const ClimateAction(
      id: 'a_zero_single_use',
      name: 'Eliminate single-use plastics at home',
      description:
          'Swap zip bags, cling wrap, and disposable cups for reusable alternatives.',
      categories: [ActionCategory.waste],
      environmentalImpactAreas: ['Waste diversion', 'Pollution reduction'],
      costEstimate: r'$',
      difficulty: 'Easy',
      impactScore: ActionImpactScore(
        co2eReductionPerYearKg: 30,
        wasteDivertedKg: 10,
      ),
    ),

    // ── Water ────────────────────────────────────────────────────────────────
    const ClimateAction(
      id: 'a_low_flow',
      name: 'Install low-flow showerhead & faucet aerators',
      description:
          'Cuts household water use ~30% with no change in daily routine.',
      categories: [ActionCategory.water],
      environmentalImpactAreas: ['Water savings', 'Energy reduction'],
      costEstimate: r'$',
      difficulty: 'Easy',
      impactScore: ActionImpactScore(
        co2eReductionPerYearKg: 40,
        waterSavedGallons: 8000,
      ),
      stepByStepGuide: [
        'Buy a WaterSense-certified showerhead (≤2.0 GPM).',
        'Screw on faucet aerators (1.0 GPM kitchen, 0.5 GPM bathroom).',
        'No plumber needed — basic wrench job.',
      ],
    ),
    const ClimateAction(
      id: 'a_rain_barrel',
      name: 'Set up a rain barrel for garden watering',
      description:
          'Captures roof runoff to irrigate plants, cutting municipal water use and stormwater runoff.',
      categories: [ActionCategory.water, ActionCategory.biodiversity],
      environmentalImpactAreas: ['Water savings', 'Soil health'],
      costEstimate: r'$$',
      difficulty: 'Easy',
      impactScore: ActionImpactScore(
        co2eReductionPerYearKg: 15,
        waterSavedGallons: 1300,
      ),
    ),

    // ── Biodiversity / Gardening ─────────────────────────────────────────────
    const ClimateAction(
      id: 'a_native_garden',
      name: 'Plant a native pollinator patch',
      description:
          'Native plants sequester carbon in soil and support local pollinators.',
      categories: [ActionCategory.biodiversity],
      environmentalImpactAreas: ['Biodiversity', 'Carbon sequestration'],
      costEstimate: r'$$',
      difficulty: 'Medium',
      impactScore: ActionImpactScore(
        co2eReductionPerYearKg: 25,
        pollinatorHabitatSqFt: 50,
      ),
      stepByStepGuide: [
        'Look up native plants for your zip code at the Audubon Society plant finder.',
        'Clear a 4×4 ft patch and amend soil with compost.',
        'Plant in fall or early spring for best establishment.',
      ],
    ),
    const ClimateAction(
      id: 'a_vegetable_garden',
      name: 'Grow a small vegetable garden',
      description:
          'Even a few containers of tomatoes, kale, or herbs cuts food miles and packaging.',
      categories: [ActionCategory.biodiversity, ActionCategory.diet],
      environmentalImpactAreas: ['Carbon sequestration', 'Food miles'],
      costEstimate: r'$$',
      difficulty: 'Medium',
      impactScore: ActionImpactScore(co2eReductionPerYearKg: 40),
      stepByStepGuide: [
        'Start with easy crops: tomatoes, kale, pole beans, herbs.',
        'Use containers if you have no ground space — 5-gallon buckets work well.',
        'Mulch to retain moisture and suppress weeds.',
        'Compost kitchen scraps to feed the soil.',
      ],
    ),
    const ClimateAction(
      id: 'a_lawn_to_clover',
      name: 'Replace lawn sections with clover or ground cover',
      description:
          'Clover fixes nitrogen, requires no mowing, and supports pollinators.',
      categories: [ActionCategory.biodiversity, ActionCategory.water],
      environmentalImpactAreas: ['Biodiversity', 'Water savings'],
      costEstimate: r'$',
      difficulty: 'Easy',
      impactScore: ActionImpactScore(
        co2eReductionPerYearKg: 20,
        pollinatorHabitatSqFt: 100,
        waterSavedGallons: 2000,
      ),
    ),

    // ── DIY + Solar (now as actions) ─────────────────────────────────────────
    const ClimateAction(
      id: 'a_diy_window_film',
      name: 'DIY: window insulation film',
      description:
          r'Reduces winter heat loss through windows by ~30% for under $30.',
      categories: [ActionCategory.diy, ActionCategory.energy],
      environmentalImpactAreas: ['Energy reduction'],
      costEstimate: r'$',
      difficulty: 'Easy',
      impactScore: ActionImpactScore(co2eReductionPerYearKg: 120),
      stepByStepGuide: [
        'Measure each window pane.',
        'Clean glass and apply double-sided tape to frame.',
        'Stretch film over tape and shrink with a hair dryer.',
      ],
    ),
    const ClimateAction(
      id: 'a_diy_solar_phone',
      name: 'DIY: small solar charger for phones',
      description:
          'A 10W panel + USB controller charges phones off-grid. No house wiring required.',
      categories: [ActionCategory.diy, ActionCategory.energy],
      environmentalImpactAreas: ['Energy reduction'],
      costEstimate: r'$$',
      difficulty: 'Medium',
      impactScore: ActionImpactScore(co2eReductionPerYearKg: 10),
      safetyNote:
          'Stay under 24V DC. Never connect homemade circuits to wall outlets.',
    ),
    const ClimateAction(
      id: 'a_diy_solar_offgrid',
      name: 'DIY: off-grid solar starter kit',
      description:
          'A 100W panel, MPPT charge controller, LiFePO4 battery, and inverter powers small appliances and lighting without grid connection.',
      categories: [ActionCategory.diy, ActionCategory.energy],
      environmentalImpactAreas: ['Energy reduction', 'Grid independence'],
      costEstimate: r'$$$',
      difficulty: 'Hard',
      impactScore: ActionImpactScore(co2eReductionPerYearKg: 180),
      isMvpAction: false,
      stepByStepGuide: [
        'Start with: 100W panel, 20A MPPT controller, 100Ah LiFePO4 battery, inline fuses.',
        'Always connect battery to controller BEFORE connecting panels.',
        'Add a 1000W pure sine inverter for AC appliances.',
        'Mount panels on roof or ground once design is stable.',
        'Add a shunt-based battery monitor to track state of charge.',
      ],
      safetyNote:
          'DC systems can produce dangerous currents. Never back-feed wall outlets — grid-tie requires a licensed electrician and permit.',
      scientificBasis:
          'A 100W panel in a 4-peak-sun region generates ~400 Wh/day, offsetting ~55 kg CO2e/yr at average US grid intensity.',
    ),
    const ClimateAction(
      id: 'a_rooftop_solar',
      name: 'Install rooftop solar (grid-tied)',
      description:
          'A professionally installed 6kW system covers most of an average home\'s electricity and earns net-metering credits.',
      categories: [ActionCategory.energy],
      environmentalImpactAreas: ['Emissions reduction', 'Grid independence'],
      costEstimate: r'$$$$',
      difficulty: 'Hard',
      impactScore: ActionImpactScore(co2eReductionPerYearKg: 3000),
      requiresProfessional: true,
      safetyNote:
          'Grid-tied systems require a licensed electrician, utility interconnection agreement, and permits. Never DIY grid-tie wiring.',
      stepByStepGuide: [
        'Get 3+ installer quotes and check SEIA certification.',
        'Review your utility\'s net metering policy.',
        'Apply for federal ITC (30% tax credit) and any state incentives.',
        'Confirm roof age and condition before installation.',
      ],
    ),

    // ── Advocacy ─────────────────────────────────────────────────────────────
    const ClimateAction(
      id: 'a_call_rep',
      name: 'Call a representative about a climate bill',
      description:
          'Constituent calls are one of the highest-leverage individual climate actions.',
      categories: [ActionCategory.advocacy],
      environmentalImpactAreas: ['Policy impact'],
      costEstimate: r'$',
      difficulty: 'Easy',
      impactScore: ActionImpactScore(co2eReductionPerYearKg: 0),
      isMvpAction: true,
      stepByStepGuide: [
        'Find your rep at usa.gov/elected-officials.',
        'Call the DC office (more weight than email).',
        'Give your name, zip code, and one specific ask.',
        '90 seconds is enough — scripted calls work great.',
      ],
    ),
    const ClimateAction(
      id: 'a_sign_petition',
      name: 'Sign and share a local climate petition',
      description:
          'Local petitions on transit, zoning, and clean energy often have outsized impact.',
      categories: [ActionCategory.advocacy],
      environmentalImpactAreas: ['Policy impact', 'Community'],
      costEstimate: r'$',
      difficulty: 'Easy',
      impactScore: ActionImpactScore(co2eReductionPerYearKg: 0),
    ),
  ];

  // ── Meals ─────────────────────────────────────────────────────────────────

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

  // ── Community posts ───────────────────────────────────────────────────────

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
              'Anyone else compost in an apartment? My countertop bin keeps fruit flies away with a tight lid.',
          createdAt: DateTime.now().subtract(const Duration(hours: 9)),
          likes: 6,
          tags: const ['waste', 'question'],
        ),
        CommunityPost(
          id: 'p3',
          authorName: 'Sara',
          body:
              'Got the off-grid solar starter kit running. Lights and phone charging on solar now. Next step: a licensed electrician for grid-tie.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          likes: 22,
          tags: const ['energy', 'diy'],
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
        CommunityPost(
          id: 'p5',
          authorName: 'Marcus',
          body:
              'Converted half my lawn to clover this spring. Zero mowing, bees everywhere. 10/10.',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          likes: 18,
          tags: const ['biodiversity'],
        ),
      ];

  // ── Petitions ─────────────────────────────────────────────────────────────

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
          tags: ['energy', 'policy'],
        ),
        const Petition(
          id: 'pt_school_garden',
          title: 'School garden program funding',
          summary:
              'Add gardening + climate literacy to K-8 curriculum with a per-school stipend.',
          target: 'School Board',
          signatureGoal: 1500,
          signatureCount: 980,
          tags: ['education', 'biodiversity'],
        ),
      ];
}