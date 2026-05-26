import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

actions = [
    {
        "action_id": "start_backyard_compost",
        "name": "Start a Backyard Compost System",
        "category": ["waste", "biodiversity"],
        "environmental_impact_areas": ["Soil Health", "Waste Reduction", "Carbon Sequestration"],
        "description": "Set up a simple compost bin or pile to turn kitchen scraps and yard waste into nutrient-rich soil amendment. Composting keeps organic matter out of landfills where it would produce methane, one of the most potent short-term greenhouse gases, and instead cycles those nutrients back into your land — exactly how natural ecosystems have always worked.",
        "cost_estimate": "$",
        "difficulty": "Easy",
        "impact_score": {
            "co2e_reduction_per_year_kg": 210,
            "pollinator_habitat_sq_ft": 0,
            "waste_diverted_kg": 182,
            "water_saved_gallons": 0
        },
        "is_mvp_action": True,
        "keywords": ["individual", "beginner", "zero-waste", "soil", "garden", "food-waste", "kid-friendly"],
        "scientific_basis": "Organic waste in landfills decomposes anaerobically and releases methane, a gas 84x more potent than CO₂ over 20 years. The EPA estimates the average household generates 650 lbs of compostable material annually. Home composting sequesters carbon in soil organic matter and eliminates associated methane.The compost also reduces the need for synthetic fertilizers, which have their own significant carbon cost.",
        "source_link": "https://www.epa.gov/recycle/composting-home",
        "step_by_step_guide": [
            "Choose a location: Pick a shaded spot in your yard at least 3 feet from your home. Good drainage is important — avoid low spots that pool water.",
            "Build or buy your bin: The cheapest option is a simple 3-foot wire mesh circle. You can also build a wooden pallet bin for free (pallets are usually free from hardware stores). Tumbler bins (~$50) are faster and pest-resistant if that is a concern.",
            "Layer your browns and greens: Browns are carbon-rich dry materials — cardboard, dried leaves, straw, newspaper. Greens are nitrogen-rich wet materials — vegetable scraps, fruit peels, coffee grounds, grass clippings. Aim for roughly 3 parts brown to 1 part green by volume.",
            "What to add: Vegetable and fruit scraps, coffee grounds and filters, tea bags (paper only), eggshells, yard trimmings, cardboard and paper (torn small), and hair or nail clippings.",
            "What NOT to add: Meat, fish, dairy, oils, pet waste, or diseased plants. These attract pests or introduce pathogens.",
            "Maintain moisture: The pile should feel like a wrung-out sponge — moist but not dripping. In dry weather, water lightly. In heavy rain, cover it.",
            "Turn regularly: Use a pitchfork or compost aerator to turn the pile every 1-2 weeks. This adds oxygen, speeds decomposition, and prevents odor.",
            "Harvest: After 2-6 months (faster in warm weather), the bottom of your pile will be dark, crumbly, earthy-smelling compost. Scoop it out and use it on your garden beds."
        ],
        "video_tutorial_url": None,
        "image_url": "https://storage.googleapis.com/climateshield-app-assets/backyard_compost_system.png"
    },
    {
        "action_id": "plant_native_pollinator_garden",
        "name": "Plant a Native Pollinator Garden",
        "category": ["biodiversity"],
        "environmental_impact_areas": ["Pollinator Habitat", "Biodiversity", "Carbon Sequestration", "Food Security"],
        "description": "Replace even a small section of lawn or empty bed with native flowering plants, shrubs, and grasses to create habitat for bees, butterflies, and other pollinators. Native plants evolved with local wildlife — they require no pesticides, little watering once established, and no fertilizer. This is the single most direct personal action to restore the living world around your home, consistent with a way of life that works with nature rather than against it. Native plants support the pollinators that are essential for 75% of the world's food crops and 90% of wild plants. Even a 100 sq ft patch can provide critical habitat in an increasingly inhospitable landscape and help reverse the catastrophic decline of pollinators.",
        "cost_estimate": "$",
        "difficulty": "Easy",
        "impact_score": {
            "co2e_reduction_per_year_kg": 45,
            "pollinator_habitat_sq_ft": 50,
            "waste_diverted_kg": 0,
            "water_saved_gallons": 2600
        },
        "is_mvp_action": True,
        "keywords": ["individual", "beginner", "biodiversity", "bees", "native-plants", "yard", "no-mow", "kid-friendly"],
        "scientific_basis": "Wild bee populations have declined by up to 35% in North America since 1974, primarily due to habitat loss from lawn monocultures and pesticide use. A study in the journal Science (Hallmann et al., 2017) found flying insect biomass has fallen by over 75% in protected areas over 27 years. Native plants support 4x more native bee species than non-native ornamentals (Tallamy, University of Delaware, 2020). A 50 sq ft native garden sequesters an estimated 45 kg CO₂e/yr in plant biomass and soil, while eliminating lawn mowing emissions and synthetic fertilizer needs.",
        "source_link": "https://www.xerces.org/pollinator-conservation/plant-lists",
        "step_by_step_guide": [
            "Find your region's native plants: Visit the Xerces Society plant database (xerces.org) or the National Wildlife Federation Native Plant Finder (nwf.org/NativePlantFinder). Enter your zip code for a tailored species list.",
            "Choose a mix of bloom times: Select plants that flower in early spring, summer, and fall so pollinators have food all season. Good starter choices for the Midwest (Peoria, IL): Purple Coneflower (Echinacea), Black-Eyed Susan, Wild Bergamot, Milkweed (for Monarchs), and Little Bluestem grass.",
            "Prepare your bed: Kill existing grass by laying cardboard over the area (sheet mulching) — completely free if you save boxes. Cover with 3 inches of wood chip mulch. Wait 4-6 weeks, or plant through holes cut in the cardboard.",
            "Plant in groups: Plant the same species in clusters of 3-5 rather than single specimens. Pollinators are more attracted to patches of color than isolated plants.",
            "Skip the pesticides entirely: Native plants attract beneficial insects that control pests naturally. Pesticide use — even organic ones — kills the pollinators you are trying to support.",
            "Add a simple bee hotel (optional, ~$10): Drill holes of varying sizes (3-10mm) into an untreated block of wood and mount in a sunny, south-facing spot. This provides nesting habitat for solitary bees.",
            "Leave the stems in fall: Do not cut back plants in autumn. Hollow and pithy stems are overwintering habitat for native bees. Cut them back in late spring once daytime temps are consistently above 50°F."
        ],
        "video_tutorial_url": None,
        "image_url": "https://storage.googleapis.com/climateshield-app-assets/native_pollinator_garden.png"
    },
    {
        "action_id": "install_rainwater_collection",
        "name": "Install a Rainwater Collection System",
        "category": ["water", "diy"],
        "environmental_impact_areas": ["Water Conservation", "Stormwater Management", "Energy Reduction"],
        "description": "Connect a rain barrel or cistern to your downspout to collect and store rainwater for garden irrigation, outdoor cleaning, and (with filtration) other uses. This action directly reduces your dependence on municipal treated water — water that required significant energy to pump, filter, and pressurize before reaching your home. It is one of the foundational steps toward the kind of water independence that characterized pre-industrial, land-based living.",
        "cost_estimate": "$$",
        "difficulty": "Easy",
        "impact_score": {
            "co2e_reduction_per_year_kg": 35,
            "pollinator_habitat_sq_ft": 0,
            "waste_diverted_kg": 0,
            "water_saved_gallons": 1300
        },
        "is_mvp_action": True,
        "keywords": ["individual", "diy", "water", "self-sufficiency", "yard", "garden", "beginner"],
        "scientific_basis": "A typical residential roof can collect approximately 600 gallons of water per 1,000 sq ft per inch of rainfall. The EPA estimates that 30% of average US household water use — approximately 9 billion gallons per day nationally — goes to outdoor watering. Municipal water treatment and distribution is energy-intensive, consuming ~2% of all US electricity (EPRI, 2002). Rainwater collection can eliminate 30-50% of summer outdoor water use, reducing both the water bill and associated energy/carbon emissions. Capturing stormwater also reduces erosion and local flooding.",
        "source_link": "https://www.epa.gov/soakuptherain/soak-rain-rain-barrels",
        "step_by_step_guide": [
            "Check local regulations first: Most US states permit rain barrels freely. A few (notably Colorado, historically) have had restrictions — verify at your state's environmental agency website before starting.",
            "Choose your barrel: A 55-gallon food-grade plastic barrel is the most common and affordable ($20-80). Many municipalities sell them subsidized. You can also upcycle free food barrels from local bakeries, breweries, or food distributors — call ahead and ask.",
            "Locate your downspout: Choose the downspout that drains the largest section of your roof and is closest to where you will use the water (garden, yard).",
            "Elevate the barrel: Place it on concrete blocks or a sturdy platform at least 12 inches off the ground. This provides enough pressure for a hose connection and makes the spigot easier to access.",
            "Modify the downspout: Using a hacksaw, cut the downspout approximately 6 inches above the barrel's opening. Install a flexible diverter kit ($15-20 from any hardware store) — this automatically redirects overflow back to the original downspout when the barrel is full, preventing overflow flooding.",
            "Add a screen: Cover the inlet with fine mesh window screen to prevent mosquito breeding and debris entry. Secure with a hose clamp or zip tie.",
            "Connect a spigot: Most barrels need a spigot drilled near the base. Use a 3/4-inch drill bit, a brass spigot ($5), a rubber washer, and plumber's tape for a watertight seal.",
            "Use it regularly: Connect a soaker hose or standard hose to the spigot for garden watering. In winter (frost climates), disconnect, drain fully, and store upside down to prevent cracking.",
            "Scale up (optional): Link two or more barrels in series with a connecting hose for 100+ gallon capacity. For serious water independence, research underground cisterns (500-2,500 gallon capacity) which are the next step up."
        ],
        "video_tutorial_url": None,
        "image_url": "https://storage.googleapis.com/climateshield-app-assets/rainwater_collection_system.png"
    },
    {
        "action_id": "diy_solar_phone_station",
        "name": "Build a Small Solar Charging Station (Energy Independence - Step 1)",
        "category": ["energy", "diy"],
        "environmental_impact_areas": ["Renewable Energy", "Energy Independence", "Carbon Reduction"],
        "description": "Build or buy a small portable solar panel system to charge phones, tablets, LED lights, and small devices without grid power. This is the entry point into energy independence — the first tangible proof that the sun can power your daily life. At the $$$ scale you want to work in, a well-designed small system is a powerful gateway to eventually powering your whole home off-grid, one step at a time.",
        "cost_estimate": "$$",
        "difficulty": "Medium",
        "impact_score": {
            "co2e_reduction_per_year_kg": 55,
            "pollinator_habitat_sq_ft": 0,
            "waste_diverted_kg": 0,
            "water_saved_gallons": 0
        },
        "is_mvp_action": False,
        "keywords": ["individual", "energy", "solar", "diy", "energy-independence", "off-grid", "intermediate"],
        "scientific_basis": "The US grid average emissions factor is approximately 0.386 kg CO₂e per kWh (EPA eGRID 2023). A 100W panel in {location} receives {peak_sun_hours} peak sun hours per day, generating {annual_kwh} kWh per year, avoiding {co2e_reduction_per_year_kg} kg CO₂e annually if displacing grid power. Small-scale solar also teaches the fundamentals of charge controllers, battery banks, and inverters — knowledge that scales directly to whole-home systems. Project Drawdown ranks distributed solar energy as a top-100 climate solution with gigaton-scale potential globally.",
        "source_link": "https://www.nrel.gov/docs/fy03osti/34279.pdf",
        "step_by_step_guide": [
            "Understand the four components: Every solar system has the same four parts — (1) a solar panel to collect energy, (2) a charge controller to regulate voltage into the battery, (3) a battery to store energy, and (4) a load (the devices you power). Start by learning these four before buying anything.",
            "Choose your panel: For a beginner charging station, a 50-100W rigid or flexible panel ($40-90) is ideal. Brands like Renogy, Rich Solar, or HQST are reputable starter options. A 100W panel is roughly the size of a small table.",
            "Choose your battery: A 20-50Ah lithium LiFePO4 battery ($60-150) is the modern standard — it is safer, lighter, more charge-cycle efficient, and longer-lasting than traditional lead-acid. Avoid cheap lead-acid batteries for indoor use (they off-gas). A 20Ah battery at 12V stores 240Wh — enough to charge a phone ~20 times or run an LED lamp for 24 hours.",
            "Buy a PWM or MPPT charge controller: A 10A PWM controller (~$15, Renogy or Victron) is sufficient for a 100W panel into a 50Ah battery. MPPT controllers are more efficient for larger systems. Wire the controller: battery first, then panel — in that order, always.",
            "Connect your load: The simplest load is a 12V USB charging hub ($10) connected directly to the battery terminals. This lets you charge phones and USB devices at 12V without an inverter. For 120V AC devices (laptop charger, small fan), add a 300W pure sine wave inverter ($30-50).",
            "Mount your panel: Angle the panel south-facing at a tilt roughly equal to your latitude (40° in Peoria). Even a flat-mounted panel will work. Secure it on a fence, roof, or ground mount with basic brackets.",
            "Safety: Fuse the wires between all components with an appropriately rated inline fuse (10-15A for a 100W system). Keep battery connections clean. Store batteries in a ventilated area away from heat.",
            "Document your system: Label all wires with colored electrical tape or a label maker. Draw a simple wiring diagram and keep it with the system. This habit becomes critical when you scale up.",
            "Expand over time: This starter system scales directly. Add a second panel and a larger battery next season. Eventually add more panels, a larger battery bank, and a 2000W+ inverter to power a refrigerator or power tools — the path to full energy independence follows the same principles, just at larger scale."
        ],
        "video_tutorial_url": None,
        "image_url": "https://storage.googleapis.com/climateshield-app-assets/solar_charging_station.png"  
    },
    {
        "action_id": "grow_food_container_garden",
        "name": "Start a Container or Raised Bed Food Garden",
        "category": ["diet", "biodiversity"],
        "environmental_impact_areas": ["Food Security", "Carbon Sequestration", "Biodiversity", "Waste Reduction"],
        "description": "Grow vegetables, herbs, and fruits at home using containers, raised beds, or in-ground beds. This is one of the most ancient and powerful acts of self-sufficiency — growing even a fraction of your own food eliminates the embodied carbon of transportation, packaging, refrigeration, and industrial agriculture for that food. Over time, a serious kitchen garden can supply meaningful portions of a household's calories and deepens the relationship between people and the living systems that sustain them.",
        "cost_estimate": "$$",
        "difficulty": "Easy",
        "impact_score": {
            "co2e_reduction_per_year_kg": 120,
            "pollinator_habitat_sq_ft": 20,
            "waste_diverted_kg": 25,
            "water_saved_gallons": 0
        },
        "is_mvp_action": True,
        "keywords": ["individual", "beginner", "food", "garden", "self-sufficiency", "diet", "biodiversity", "kid-friendly"],
        "scientific_basis": "The average meal in the US travels 1,500 miles from farm to table (Worldwatch Institute). Industrial food production accounts for approximately 26% of global greenhouse gas emissions (Poore & Nemecek, Science, 2018). Home-grown vegetables have near-zero food miles and generate soil-stored carbon if organic matter is added to beds. A well-managed 100 sq ft raised bed can produce 50-100 lbs of vegetables annually — equivalent to eliminating ~120 kg CO₂e when accounting for avoided packaging, transport, refrigeration, and synthetic fertilizer. Edible gardens also support pollinators with flowering herbs and vegetable blooms. Composting food scraps from the garden further reduces waste and methane emissions. The hands-on experience of growing food fosters a deeper connection to nature and the sources of our sustenance, which is essential for long-term cultural shifts toward sustainability.",
        "source_link": "https://www.nal.usda.gov/legacy/afsic/home-vegetable-gardening",
        "step_by_step_guide": [
            "Start with what you actually eat: Make a list of the top 5 vegetables and herbs you buy most often. These are your first crops — you will actually use them and notice the savings.",
            "Choose your format: (a) Containers (~$5-25 each): Best for renters or paved patios. 5-gallon buckets are free from bakeries. Grow tomatoes, peppers, herbs, lettuce. (b) Raised beds (~$40-100 for lumber + soil): Best for yards. Build a simple 4x8 ft frame from untreated 2x6 pine boards. Fill with a 60/40 mix of topsoil and compost. (c) In-ground beds (free): Dig directly into existing soil and amend with compost. Lowest cost, highest long-term productivity.",
            "Build great soil first: The single biggest factor in success is soil health. Add 3-4 inches of finished compost to any bed each spring. Healthy soil grows healthy plants that resist pests without chemicals.",
            "High-value beginner crops for the Midwest: Tomatoes, zucchini, green beans, kale, Swiss chard, lettuce (spring/fall), cucumbers, herbs (basil, parsley, chives), and garlic (planted in fall, harvested summer).",
            "Water deeply and less frequently: Water 1 inch per week, all at once, rather than daily light watering. Deep watering encourages deep root growth and drought resilience. A soaker hose from your rain barrel is ideal.",
            "Use companion planting: Plant basil near tomatoes (repels aphids), marigolds around the border (deters nematodes), and nasturtiums as a trap crop for aphids. These are free pest control strategies.",
            "Save seeds: At the end of the season, let one specimen of each open-pollinated variety (tomato, bean, zucchini) go fully to seed. Dry and store in a cool, dark place. Over years, your seeds adapt to your specific microclimate and become more productive — this is what native food cultures did for thousands of years.",
            "Track your harvest: Weigh or estimate what you harvest each week. Even rough numbers help you see the real-world impact and plan improvements for next season.",
            "Scale up each year: Year 1: containers or one 4x8 bed. Year 2: add a second bed and fruit bushes (blueberries, raspberries). Year 3: consider a fruit tree, a perennial herb garden, and garlic beds. Within 3-5 years, a dedicated home garden can supply 15-30% of a household's fresh produce."
        ],
        "video_tutorial_url": None,
        "image_url": "https://storage.googleapis.com/climateshield-app-assets/food_garden.png"
    }
]

# Push each action to Firestore using action_id as the document ID
collection = db.collection("actions")

for action in actions:
    doc_id = action["action_id"]
    collection.document(doc_id).set(action)
    print(f"✓ Uploaded: {action['name']}")

print("\n✅ All actions seeded successfully!")