import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

actions = [


    {
    "action_id": "transport_optimize_driving",
    "name": "Drive Less, Smarter: Trip Batching and Hypermiling",
    "category": ["transportation"],
    "environmental_impact_areas": ["Carbon Reduction", "Air Quality", "Cost Savings"],
    "description": "You don't need a new car to cut your driving emissions significantly. Two habit changes — trip batching (combining errands into single trips) and hypermiling (efficient driving technique) — can cut your fuel use and emissions by 15-30% with zero cost. This is the on-ramp before switching to an EV.",
    "cost_estimate": "Free",
    "difficulty": "Easy",
    "impact_score": {
        "co2e_reduction_per_year_kg": 280,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 0,
        "water_saved_gallons": 0
    },
    "is_mvp_action": True,
    "keywords": ["individual", "beginner", "transportation", "driving", "free", "no-equipment", "fuel-savings"],
    "scientific_basis": "The average American passenger car emits 4.6 metric tons of CO2 per year (EPA). Aggressive driving (rapid acceleration and braking) reduces fuel economy by 10-40% in stop-and-go traffic (DOE). Driving 10% fewer miles through trip batching combined with eco-driving technique reduces personal vehicle emissions by approximately 280 kg CO2e/year for the average driver.",
    "source_link": "https://www.fueleconomy.gov/feg/driveHabits.shtml",
    "step_by_step_guide": [
        "Trip batching — the single most effective change: Instead of making 5 separate trips to different stores across the week, plan one loop that hits all of them in the most efficient order. Cold engines (first 5 minutes of driving) burn 2-3x more fuel than a warm engine, so combining 5 trips into 1 eliminates 4 cold starts.",
        "Hypermiling technique #1 — coast to stops: When you see a red light ahead, take your foot off the gas immediately and coast. Your car's fuel injectors cut off completely during deceleration in gear. You're moving for free. Brake late and gently. This alone improves fuel economy 10-15% in city driving.",
        "Hypermiling technique #2 — maintain steady speed: On highways, use cruise control. Fuel economy drops significantly above 55 mph — each 5 mph over 50 costs approximately 7-14% more fuel. On city streets, anticipate traffic flow so you rarely need to accelerate hard.",
        "Hypermiling technique #3 — tire pressure: Under-inflated tires increase rolling resistance and reduce fuel economy 0.5-3%. Check your tire pressure monthly (the correct PSI is on the driver's door sticker, not the tire sidewall). Properly inflated tires also last 20% longer.",
        "Find one regular trip to replace: Look at your week and identify one short trip (under 2 miles) you currently drive that you could walk or bike instead. A 2-mile round trip driven daily generates approximately 180 kg CO2e/year. Walking or biking it costs zero emissions.",
        "Next step the ML model will suggest: After 30 days of logging reduced mileage, ClimaShield will suggest 'Try Public Transit Once a Week' — the next rung on the transportation ladder toward eventually replacing your gas car with an EV."
    ],
    "uses_location_data": False,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/transport_smart_driving.png"
},

{
    "action_id": "transport_bike_for_errands",
    "name": "Replace Short Car Trips with a Bike or E-Bike",
    "category": ["transportation"],
    "environmental_impact_areas": ["Carbon Reduction", "Air Quality", "Health", "Cost Savings"],
    "description": "60% of car trips in the US are under 6 miles — a distance easily covered by bike in 20-30 minutes. Replacing just 2-3 short car trips per week with a bike or e-bike eliminates approximately 400-600 kg CO2e per year, saves money on gas, and provides cardiovascular health benefits equivalent to a gym membership.",
    "cost_estimate": "$$",
    "difficulty": "Medium",
    "impact_score": {
        "co2e_reduction_per_year_kg": 500,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 0,
        "water_saved_gallons": 0
    },
    "is_mvp_action": False,
    "keywords": ["individual", "intermediate", "transportation", "biking", "e-bike", "health", "no-car"],
    "scientific_basis": "A 2021 study in Transport and Environment found that substituting one car trip per day with cycling reduces a person's transport carbon footprint by approximately 67%. A typical car trip of 4 miles produces approximately 1.5 kg CO2e. Replacing 3 such trips per week over a year eliminates approximately 234 kg CO2e. Adding cargo capacity (panniers or cargo bike) enables grocery runs, replacing longer car trips and increasing savings to 400-600 kg CO2e/year.",
    "source_link": "https://www.sciencedirect.com/science/article/pii/S1361920921000936",
    "step_by_step_guide": [
        "Identify your 'bikeable trips': Open Google Maps and check the bike route for your 3 most frequent short car trips — grocery store, coffee shop, library, gym, post office. If the route is under 4 miles and has a bike lane or low-traffic road, it's bikeable.",
        "Equipment minimum: A working bike ($0 if you already own one), a helmet, a rear rack or pannier bag for cargo ($25-60), lights front and rear ($15-20), and a quality lock ($25-40). Total if buying used: under $100. An e-bike ($500-1,500 used) extends your range to 15-20 miles and removes hills as a barrier.",
        "The cargo upgrade: Install a rear rack and two pannier bags on your bike. This turns a regular bike into a practical grocery hauler that can carry 30-40 lbs of groceries without a backpack. This single upgrade is what makes biking replace actual car errands rather than just recreational rides.",
        "Start with your easiest target trip: Pick the one short car trip you make most often and bike it for one full month. Don't try to replace all your driving at once. One replaced trip becomes habit, then habit makes the next one easier.",
        "Safety protocol: Ride with traffic, signal turns, never wear headphones, use lights at night, and always wear a helmet. Obey traffic signals. The vast majority of cycling accidents are preventable by following traffic laws.",
        "Track your savings in ClimaShield: Log each replaced car trip in the app. The app will calculate CO2e saved, estimated gas money saved, and calories burned. After 60 days, ClimaShield will suggest the next step: evaluating an electric vehicle for longer trips."
    ],
    "uses_location_data": False,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/transport_biking.png"
},

{
    "action_id": "transport_electric_vehicle",
    "name": "Switch to an Electric Vehicle",
    "category": ["transportation"],
    "environmental_impact_areas": ["Carbon Reduction", "Air Quality", "Energy Independence", "Cost Savings"],
    "description": "Switching from an average gasoline car to an EV is the single highest-impact transportation action available — reducing personal vehicle emissions by up to 70% depending on your state's grid. It also reduces fuel costs by 60-70% and eliminates oil changes, transmission service, and most brake wear. This is the capstone of the transportation ladder.",
    "cost_estimate": "$$$",
    "difficulty": "Hard",
    "impact_score": {
        "co2e_reduction_per_year_kg": 2000,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 0,
        "water_saved_gallons": 0
    },
    "is_mvp_action": False,
    "keywords": ["individual", "advanced", "transportation", "EV", "electric-vehicle", "high-impact", "long-term"],
    "scientific_basis": "The average gasoline car emits 4.6 metric tons CO2e/year (EPA). An EV charged on the average US grid emits approximately 1.4-2.3 metric tons CO2e/year, a reduction of 50-70% (NRDC, 2021). In states with cleaner grids (like IL at 0.390 kg CO2e/kWh), the reduction is even larger. The federal Clean Vehicle Tax Credit provides up to $7,500 for new EVs and $4,000 for used EVs (IRS Form 8936). Total cost of ownership over 5 years is lower for EVs in most scenarios due to fuel and maintenance savings.",
    "source_link": "https://www.irs.gov/credits-deductions/credits-for-new-clean-vehicles-purchased-in-2023-or-after",
    "step_by_step_guide": [
        "Determine your use case: EVs work best if you drive under 200 miles per day (virtually all Americans), have a place to charge at home or work, and plan to keep the car 5+ years. If you can check these boxes, an EV will save you money versus a comparable gas car over its lifetime.",
        "Research federal and state incentives first: Go to fueleconomy.gov/tax-incentives to see current federal credits. Check your state for additional rebates — many states stack another $1,000-7,500 on top of the federal credit. Income and purchase price caps apply, so check eligibility before shopping.",
        "New vs. Used EV decision: Used EVs (2019-2022 Chevy Bolt, Nissan Leaf, Tesla Model 3) are available for $15,000-25,000 and qualify for up to $4,000 federal credit. A used Chevy Bolt with 60,000 miles still has 85%+ battery capacity and will last another 100,000+ miles. This is the most financially accessible entry point.",
        "Set up home charging: A standard 120V outlet (Level 1) charges most EVs at 3-5 miles per hour — enough for typical daily driving if you plug in overnight. For faster charging, have an electrician install a 240V/40A outlet (Level 2) for $200-400 in parts and labor. Many utilities offer rebates for home charging equipment.",
        "Test drive multiple models: EV driving is fundamentally different — instant torque, one-pedal driving (regenerative braking), and near-silent operation. Drive at least 3 different models before deciding. The Tesla Model 3, Ford Mustang Mach-E, Hyundai Ioniq 6, and Chevy Equinox EV are the most recommended in the $30,000-45,000 range.",
        "Understand the battery warranty: Every EV sold in the US is legally required to provide a minimum 8-year/100,000-mile battery warranty. Modern EV batteries are designed to last 200,000+ miles. Battery degradation is gradual — approximately 2% per year — not sudden.",
        "Pair with solar for maximum impact: An EV charged from your home solar system runs on zero-emissions electricity and costs approximately $0.00 per mile in fuel. This combination — solar panels + home EV charging — is the most carbon-reducing, cost-saving combination available to a homeowner."
    ],
    "uses_location_data": False,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/transport_electric_vehicle.png"
},
    {
    "action_id": "home_led_lighting_upgrade",
    "name": "Replace All Bulbs with LED: 15-Minute, $30 Home Upgrade",
    "category": ["home_energy"],
    "environmental_impact_areas": ["Energy Reduction", "Carbon Reduction", "Cost Savings"],
    "description": "LED bulbs use 75% less electricity than incandescent bulbs and last 15–25 years. Replacing every bulb in your home with LEDs is one of the fastest, cheapest, highest-ROI actions available. A typical household saves $225/year on electricity and reduces CO2e by approximately 140 kg/year. Payback period: under 6 months.",
    "cost_estimate": "$",
    "difficulty": "Easy",
    "impact_score": {
        "co2e_reduction_per_year_kg": 140,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 2,
        "water_saved_gallons": 0
    },
    "is_mvp_action": True,
    "keywords": ["individual", "beginner", "home-energy", "efficiency", "quick-win", "low-cost", "no-skills"],
    "scientific_basis": "The US DOE reports that LED lighting uses at least 75% less energy and lasts 25 times longer than incandescent lighting. The average US household has 30+ light sockets. Replacing 30 60W incandescent bulbs with 9W LEDs saves approximately 1,530 kWh/year. At the US average grid emissions factor of 0.386 kg CO2e/kWh, this prevents approximately 140 kg CO2e/year and saves approximately $215/year at $0.14/kWh.",
    "source_link": "https://www.energy.gov/energysaver/led-lighting",
    "step_by_step_guide": [
        "Count your bulbs first: Walk through every room and count total light sockets. Include lamps, overhead fixtures, bathroom vanities, outdoor lights, and garage. Most homes have 20–40 sockets. Write the count down.",
        "Buy the right bulbs: For most rooms, choose 800 lumen (equivalent to 60W incandescent), 2700K color temperature (warm white, matches the look of old bulbs). For kitchens and bathrooms where you want brighter light, choose 3000K. For home offices, 4000K. Buy a multipack at Costco, Walmart, or Home Depot — Cree, Feit, or GE Relax brand in a 16-pack cost approximately $20–30.",
        "Replace all bulbs in one session: It takes 15–20 minutes to replace every bulb in an average home. Don't do it one at a time over months — do it all at once so you capture the full savings immediately.",
        "Dispose of old bulbs correctly: Standard incandescent and halogen bulbs can go in regular trash. CFL bulbs (the spiral ones) contain mercury and must go to a hazardous waste facility or Home Depot/Lowe's bulb recycling drop-off.",
        "Add dimmer switches where available: LEDs work with most modern dimmers. Dimming LEDs to 70% reduces energy use proportionally and extends bulb life. LUTRON brand dimmers ($15–20 each) are the most compatible with LED bulbs.",
        "Calculate your savings in ClimaShield: Enter your bulb count in the app. ClimaShield will calculate your exact annual kWh savings, dollar savings, and CO2e reduction based on your state's grid factor."
    ],
    "uses_location_data": True,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/home_led_upgrade.png"
},

{
    "action_id": "home_smart_thermostat",
    "name": "Install a Smart Thermostat",
    "category": ["home_energy"],
    "environmental_impact_areas": ["Energy Reduction", "Carbon Reduction", "Cost Savings"],
    "description": "A smart thermostat automatically learns your schedule and preferences, stops heating or cooling an empty house, and can be controlled from your phone. Heating and cooling account for approximately 48% of home energy use. Installing a smart thermostat reduces that bill by 10–23% with zero change in comfort.",
    "cost_estimate": "$$",
    "difficulty": "Easy",
    "impact_score": {
        "co2e_reduction_per_year_kg": 320,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 0,
        "water_saved_gallons": 0
    },
    "is_mvp_action": True,
    "keywords": ["individual", "beginner", "home-energy", "HVAC", "smart-home", "quick-win", "moderate-cost"],
    "scientific_basis": "The EPA Energy Star program estimates that a programmable smart thermostat saves approximately $50–140/year and prevents 320–800 lbs (145–363 kg) of CO2e annually, depending on home size and climate. The Google Nest Thermostat Learning study found average HVAC energy savings of 10–12% for heating and 15% for cooling versus manual thermostats.",
    "source_link": "https://www.energystar.gov/products/smart_thermostats",
    "step_by_step_guide": [
        "Check compatibility first: Go to nest.com/compatibility or ecobee.com/compatibility and enter your current thermostat model or wiring details. Most forced-air HVAC systems (the most common in the US) are compatible. Systems without a common wire (C-wire) may need an adapter — both Nest and Ecobee include these.",
        "Choose your thermostat: (a) Google Nest Thermostat ($130) — best for beginners, auto-learns your schedule, no programming required. (b) Ecobee SmartThermostat Premium ($250) — best for multi-room homes, includes remote room sensors, integrates with Alexa/Google/HomeKit. (c) Honeywell Home T6 Pro ($80) — best budget option, programmable but not self-learning.",
        "Installation (30–45 minutes, no electrician needed): Turn off power to your HVAC system at the circuit breaker. Remove your old thermostat and photograph the wiring before disconnecting anything. Label each wire with the included labels. Connect labeled wires to the new thermostat base. Attach the display and restore power. Follow the in-app setup to connect to WiFi.",
        "Set your schedule (or let it learn): If your thermostat is self-learning (Nest), simply use it normally for 1–2 weeks and it will program itself based on your patterns. For programmable thermostats, set 4 time periods: wake, leave, return, sleep — with setback temperatures of 7–10°F during away/sleeping hours.",
        "Enable key energy-saving features: Eco Mode/Away Mode (setback when nobody is home), scheduling based on your work and sleep patterns, and — if available — utility demand response (many utilities pay you $20–50/year to allow brief temperature adjustments during grid peak events).",
        "Savings tracking: Connect the Nest or Ecobee app to ClimaShield via the account settings. Your monthly energy savings, CO2e reduction, and usage history will appear directly on your ClimaShield Climate Surplus dashboard."
    ],
    "uses_location_data": False,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/home_smart_thermostat.png"
},

{
    "action_id": "home_weatherize_air_sealing",
    "name": "Weatherize Your Home: Air Seal and Insulate for Year-Round Savings",
    "category": ["home_energy"],
    "environmental_impact_areas": ["Energy Reduction", "Carbon Reduction", "Cost Savings", "Comfort"],
    "description": "A leaky house is like leaving a window cracked all winter. Air sealing and adding insulation to attic access hatches, doors, windows, and outlets can reduce heating and cooling bills by 10–30% and prevent up to 900 kg CO2e/year. Most of it is a $50 weekend DIY project. The payback period is under 1 year.",
    "cost_estimate": "$$",
    "difficulty": "Medium",
    "impact_score": {
        "co2e_reduction_per_year_kg": 520,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 0,
        "water_saved_gallons": 0
    },
    "is_mvp_action": False,
    "keywords": ["individual", "intermediate", "home-energy", "insulation", "weatherize", "diy", "efficiency"],
    "scientific_basis": "The DOE estimates that properly air sealing and insulating a home can save 10–50% on heating and cooling costs. The EPA Energy Star program reports that sealing and insulating reduces average CO2e by 520 kg/year. The most cost-effective areas to address are: attic air sealing (yields 25% of total savings), door weatherstripping (10%), window caulking (10%), and outlet/switch sealing (5%).",
    "source_link": "https://www.energystar.gov/campaign/seal_insulate",
    "step_by_step_guide": [
        "Materials list (~$40–80 total): Foam backer rod ($6), silicone caulk and gun ($10), door weatherstripping foam or V-seal ($10), door sweep ($10–15), outlet foam gaskets 10-pack ($5), window insulation film kit ($15–20), expanding foam spray can ($8), attic hatch insulation cover ($40 or DIY with rigid foam board).",
        "Phase 1 — The quick wins (1 hour): Install outlet gaskets behind every exterior-wall outlet and switch cover plate. These cost $0.50 each and block surprising amounts of air. Caulk the gap between baseboard trim and floor on exterior walls. Add foam weatherstripping to all exterior door frames.",
        "Phase 2 — Doors and windows (2 hours): Install door sweeps on all exterior doors — the gap at the bottom is often the largest single air leak in a home. Apply V-seal weatherstripping inside window channels. Caulk the exterior perimeter of all windows where they meet the siding.",
        "Phase 3 — Attic hatch (1 hour): Your attic access door or hatch is almost always completely uninsulated — it's a direct hole to your unconditioned attic. Add weatherstripping around the hatch frame and either purchase a pre-made foam insulation cover ($40 at Home Depot) or cut R-15 rigid foam board to size and place on top. This single action can reduce attic heat loss by 15–20%.",
        "Phase 4 — Attic penetrations (2–3 hours): In the attic, look for any gaps around wiring, pipes, or HVAC ducts penetrating the ceiling. Seal these with expanding spray foam or caulk before adding insulation. These gaps are the #1 source of conditioned air loss in most homes.",
        "Optional — get a professional energy audit: Your utility company often offers free or heavily discounted home energy audits using a blower door test that identifies every air leak in your home with a pressure differential and thermal camera. Completing this action first tells you exactly where to focus your weatherization effort."
    ],
    "uses_location_data": False,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/home_weatherize.png"
},

{
    "action_id": "home_heat_pump_upgrade",
    "name": "Replace Your Furnace/AC with a Heat Pump",
    "category": ["home_energy"],
    "environmental_impact_areas": ["Carbon Reduction", "Energy Reduction", "Energy Independence", "Cost Savings"],
    "description": "A heat pump is an all-electric HVAC system that heats AND cools your home using 2–4x less energy than a gas furnace or electric resistance heating. It is the most impactful home upgrade after solar. Modern cold-climate heat pumps work efficiently down to -15°F. The federal Inflation Reduction Act provides a $2,000 tax credit plus up to $8,000 in state rebates through the High-Efficiency Electric Home Rebate Act (HEEHRA).",
    "cost_estimate": "$$$",
    "difficulty": "Hard",
    "impact_score": {
        "co2e_reduction_per_year_kg": 1800,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 0,
        "water_saved_gallons": 0
    },
    "is_mvp_action": False,
    "keywords": ["individual", "advanced", "home-energy", "heat-pump", "HVAC", "electrification", "high-impact", "long-term"],
    "scientific_basis": "Replacing a gas furnace with an air-source heat pump reduces home heating emissions by 40–70% depending on the local grid, because heat pumps move heat instead of generating it, achieving efficiencies (COP) of 2–4 vs. 0.8–0.95 for gas furnaces. A 2023 Rocky Mountain Institute study found heat pumps save homeowners $500–1,100/year on energy bills vs. gas heating in most US climates. The IRA provides: $2,000 federal tax credit for heat pump installation + state HEEHRA rebates up to $8,000.",
    "source_link": "https://homes.rewiringamerica.org/calculator",
    "step_by_step_guide": [
        "Calculate your savings with Rewiring America: Go to homes.rewiringamerica.org/calculator and enter your zip code, income, and current heating/cooling setup. The calculator shows exactly what federal and state incentives you qualify for and estimates your annual savings.",
        "Understand the two types: (a) Air-Source Heat Pump (most common, $4,000–10,000 installed) — replaces your existing furnace and central AC in one system. Works for any home with ductwork. (b) Mini-Split Heat Pump ($1,500–5,000 per zone, DIY-friendly models available) — works without ductwork, ideal for adding heating/cooling to a room, garage, workshop, or home addition.",
        "Cold-climate models for northern states: If you live above the Mason-Dixon Line, specifically request a 'cold-climate heat pump' rated for operation down to -15°F or lower. Recommended brands: Mitsubishi Hyper-Heat, Bosch IDS, Daikin Aurora, LG Mega Heat. Standard heat pumps can struggle below 20°F — cold-climate models do not.",
        "Get 3 quotes from HVAC contractors: Ask specifically for a heat pump quote alongside your next furnace replacement (don't wait for the old furnace to die). Request sizing calculations using ACCA Manual J — never accept a contractor who just matches the old equipment size without calculating your home's actual heat load.",
        "Qualify for maximum incentives: (1) Federal tax credit: 30% of cost up to $2,000 for heat pump (IRS Form 5695). (2) HEEHRA state rebates: Up to $8,000 for households under 150% of area median income — available through your state energy office starting 2024–2025. (3) Utility rebates: Many utilities offer $300–1,500 additional rebates for heat pump installations.",
        "The total picture: A cold-climate heat pump in Illinois (grid factor 0.390 kg CO2e/kWh) replacing a gas furnace prevents approximately 1,800 kg CO2e/year. Combined with solar panels from the solar series, your home heating becomes nearly zero-emissions — and you've eliminated your gas bill entirely."
    ],
    "uses_location_data": True,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/home_heat_pump.png"
},        

    {
    "action_id": "water_low_flow_fixtures",
    "name": "Install Low-Flow Showerheads and Faucet Aerators",
    "category": ["water"],
    "environmental_impact_areas": ["Water Conservation", "Carbon Reduction", "Cost Savings"],
    "description": "Standard showerheads use 2.5 gallons per minute. Low-flow showerheads use 1.5–1.8 GPM with no noticeable pressure difference. Installing low-flow fixtures in every bathroom and kitchen takes under an hour, costs $30–60 total, and saves 10,000+ gallons of water per person per year — plus the energy to heat that water.",
    "cost_estimate": "$",
    "difficulty": "Easy",
    "impact_score": {
        "co2e_reduction_per_year_kg": 65,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 0,
        "water_saved_gallons": 10000
    },
    "is_mvp_action": True,
    "keywords": ["individual", "beginner", "water", "plumbing", "quick-win", "low-cost", "no-skills"],
    "scientific_basis": "The EPA WaterSense program estimates that replacing a standard 2.5 GPM showerhead with a 1.8 GPM WaterSense-certified model saves approximately 2,900 gallons per person per year in shower water. For a family of 4, total household savings are approximately 10,000–15,000 gallons/year. Heating water accounts for approximately 18% of home energy use — reducing hot water consumption by 30% saves approximately 65 kg CO2e/year.",
    "source_link": "https://www.epa.gov/watersense/showerheads",
    "step_by_step_guide": [
        "Buy WaterSense-certified fixtures: Look for the EPA WaterSense label. For showerheads: Niagara Earth Massage (1.25 GPM, $10), Delta 1.75 GPM ($20), or Moen Attract (1.75 GPM, $30). For faucet aerators: buy a 10-pack of 1.0 GPM kitchen aerators ($8) and 1.5 GPM bathroom aerators ($6).",
        "Showerhead installation (5 minutes per bathroom): Turn off the shower valve. Unscrew the old showerhead by hand or with a wrench (wrap the wrench jaws with tape to avoid scratching). Clean the threads. Wrap 3–4 layers of Teflon plumber's tape clockwise around the pipe threads. Hand-screw the new showerhead on, then tighten 1–2 turns with a wrench.",
        "Faucet aerator installation (2 minutes per faucet): The aerator is the small screen fitting at the tip of every faucet. Unscrew it by hand (counterclockwise) or with pliers wrapped in tape. Replace with a new low-flow aerator of the same thread size (most are standard 15/16 or 13/16 inch). Hand-tighten.",
        "Test for leaks: Turn on each fixture and check the connection point for drips. If it drips, tighten slightly. If it still leaks, add more Teflon tape.",
        "Bonus — fix running toilets: A running toilet wastes 200+ gallons per day — more water than all your showers combined. Lift the tank lid. If water is trickling into the bowl, the flapper is worn. A new toilet flapper costs $5 at any hardware store and takes 5 minutes to replace.",
        "Track your water savings: Enter your household size in ClimaShield and confirm you've installed low-flow fixtures. The app will add your estimated annual water savings (gallons) and CO2e reduction to your Water Savings and Climate Surplus metrics."
    ],
    "uses_location_data": False,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/water_low_flow_fixtures.png"
},

{
    "action_id": "water_greywater_laundry_to_landscape",
    "name": "Laundry-to-Landscape Greywater System",
    "category": ["water"],
    "environmental_impact_areas": ["Water Conservation", "Soil Health", "Drought Resilience"],
    "description": "A laundry-to-landscape (L2L) greywater system redirects your washing machine's rinse water to irrigate trees and shrubs instead of sending it down the drain. No permits required in most US states. No pumps, no filters, no backflow risk. A washing machine produces 20–30 gallons per load — enough to water 2–4 fruit trees or a landscape bed. This is the DIY greywater system that actually works.",
    "cost_estimate": "$$",
    "difficulty": "Medium",
    "impact_score": {
        "co2e_reduction_per_year_kg": 10,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 0,
        "water_saved_gallons": 6000
    },
    "is_mvp_action": False,
    "keywords": ["individual", "intermediate", "water", "greywater", "diy", "irrigation", "drought-resilience"],
    "scientific_basis": "The average front-loading washing machine uses 15–25 gallons per load. Running 5–6 loads per week produces approximately 4,500–6,000 gallons of greywater per year. Redirecting this to landscape irrigation reduces outdoor potable water use by 50–100% for drip-irrigated trees and shrubs. California's Greywater Action coalition estimates L2L systems save 40+ gallons per load per household, reducing municipal water demand measurably in drought-prone regions.",
    "source_link": "https://greywateraction.org/laundry-to-landscape/",
    "step_by_step_guide": [
        "⚠️ KNOW YOUR STATE LAWS: Laundry-to-landscape greywater is legal without a permit in California, Arizona, New Mexico, Texas, Montana, Utah, and several other western states. Most other states require a permit or prohibit it. Check greywateraction.org/laundry-landscape-state-policies/ before proceeding.",
        "How it works: Your washing machine's drain hose currently empties into a standpipe in the wall. You redirect it to exit through a hole in the wall and connect to a simple 1-inch diameter branched drain pipe that delivers water to mulched basins around trees and shrubs.",
        "Parts list (~$100–150): 3-way diverter valve ($40–60, Aquacell or Flotender brand), 1-inch diameter flexible polyethylene tubing (50–100 ft, $30–50), 1-inch through-wall fitting ($10), gravel and mulch for infiltration basins (free or $10–20).",
        "Installation steps: (1) Install the 3-way diverter valve on the washing machine drain hose. This lets you switch between sewer (for bleach loads) and landscape with a simple lever turn. (2) Route the new drain line from the back of the washer, through the wall, and down to your landscape. Keep the pipe sloped continuously downward — no low spots that collect water. (3) Create mulched basins 2 feet wide and 6 inches deep around the base of each tree or shrub the water will reach. Cover the pipe outlet with a 6-inch gravel pocket under the mulch so water infiltrates rather than pools on the surface.",
        "What you CAN irrigate: Trees, shrubs, and ornamental plants. Water must soak into the ground quickly and never pool, run off your property, or contact edible parts of food plants.",
        "What you CANNOT send through the system: Loads washed with bleach, diapers, heavily soiled items, or anything with strong disinfectants. Use the diverter to route these loads to the sewer.",
        "Use greywater-safe laundry detergent: Switch to a plant-based, sodium-free detergent — Oasis, Vaska, or Ecos Laundry Detergent. Sodium (from standard detergents) harms soil structure over time."
    ],
    "uses_location_data": True,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/water_greywater_system.png"
},

    {
    "action_id": "bio_insect_hotel",
    "name": "Build an Insect Hotel for Native Bees and Beneficial Insects",
    "category": ["biodiversity"],
    "environmental_impact_areas": ["Biodiversity", "Pollinator Support", "Pest Control"],
    "description": "70% of the world's 20,000 bee species are ground or cavity nesters — not hive bees. They don't need a beehive. They need small holes in wood, hollow plant stems, and loose soil. An insect hotel — a structure of natural materials offering nesting cavities — provides critical habitat for mason bees, leafcutter bees, and beneficial wasps that pollinate your food garden and control garden pests.",
    "cost_estimate": "Free",
    "difficulty": "Easy",
    "impact_score": {
        "co2e_reduction_per_year_kg": 0,
        "pollinator_habitat_sq_ft": 4,
        "waste_diverted_kg": 2,
        "water_saved_gallons": 0
    },
    "is_mvp_action": True,
    "keywords": ["individual", "beginner", "biodiversity", "pollinators", "diy", "free", "kids-activity"],
    "scientific_basis": "Native bees (not honeybees) provide an estimated $3 billion in free pollination services annually in the US (Xerces Society). Mason bees are 120x more effective pollinators than honeybees per individual. A 2019 study in Ecological Entomology found that insect hotel abundance positively correlates with wild bee species richness within a 500m radius. A typical insect hotel provides nesting habitat for 6–10 native bee species.",
    "source_link": "https://www.xerces.org/blog/building-homes-for-native-bees",
    "step_by_step_guide": [
        "The simplest version (free, 20 minutes): Find a 4x4 wooden post or thick log. Drill holes of varying diameters (4mm, 6mm, 8mm, 10mm) approximately 3–6 inches deep, angled very slightly downward to drain rain. Space holes 1 inch apart. Mount this block 3–6 feet off the ground, facing south or southeast to catch morning sun. You're done.",
        "A fuller insect hotel (reclaimed materials, $0–15): Use a wooden crate, pallet section, or old drawer as the frame. Fill sections with: hollow bamboo segments cut to 6 inches (for mason and leafcutter bees), pine cones and rolled cardboard tubes (for lacewings and earwigs), bark pieces and loose wood shavings (for solitary wasps), clay-filled sections with 4–6mm holes drilled in (for mud-dauber bees).",
        "Location is critical: Face the structure south or southeast. It needs direct morning sun to warm up the nesting chambers. Place it at least 2 feet off the ground to avoid ground moisture. Ideally position it near flowering plants — native bees won't travel more than 300 feet from their nest to forage.",
        "Maintenance: Once a year in late fall after all bees have emerged (September–October), check tubes for disease or parasitized eggs (look for black cocoons rather than white). Replace badly infested tubes. Keep the structure dry — a simple roof of bark or shingles protects against rain.",
        "Make it a kids' project: Building an insect hotel is one of the best hands-on nature activities for children ages 5–12. It teaches observation, ecology, and the concept that not all bees sting and that most insects are beneficial allies. The Xerces Society has a free printable guide at xerces.org specifically designed for this.",
        "Track your habitat in ClimaShield: Log your insect hotel size (approximate square feet of nesting face). ClimaShield adds this to your Pollinator Habitat metric on the Biodiversity module of your Climate Surplus dashboard."
    ],
    "uses_location_data": False,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/bio_insect_hotel.png"
},

{
    "action_id": "bio_backyard_food_forest",
    "name": "Plant a Backyard Food Forest: Perennial Food from a 10x10 Space",
    "category": ["biodiversity", "food"],
    "environmental_impact_areas": ["Carbon Sequestration", "Biodiversity", "Food Security", "Soil Health"],
    "description": "A food forest is a multi-layer garden designed to mimic the structure of a natural forest — fruit and nut trees on top, berry shrubs in the middle, ground cover herbs and edibles at the base — but composed entirely of edible and useful plants. It is low-maintenance once established, produces food for decades, sequesters carbon in the soil and wood, and provides year-round wildlife habitat. This is the capstone of the food growing journey.",
    "cost_estimate": "$$",
    "difficulty": "Hard",
    "impact_score": {
        "co2e_reduction_per_year_kg": 80,
        "pollinator_habitat_sq_ft": 100,
        "waste_diverted_kg": 0,
        "water_saved_gallons": 0
    },
    "is_mvp_action": False,
    "keywords": ["individual", "advanced", "biodiversity", "food-forest", "permaculture", "long-term", "carbon-sequestration"],
    "scientific_basis": "Agroforestry systems sequester 0.27–9.28 tonnes of carbon per hectare per year (IPCC, 2019), significantly more than annual vegetable gardens. A 100-square-foot food forest containing 2 dwarf fruit trees, 3 berry shrubs, and perennial ground cover sequesters approximately 80 kg CO2e/year once established. Trees also provide evaporative cooling that reduces home AC loads, shade that protects soil moisture, and year-round insect habitat superior to annual gardens.",
    "source_link": "https://www.ars.usda.gov/research/publications/publication/?seqNo115=372524",
    "step_by_step_guide": [
        "Design your layers for a 10x10 space: (1) Canopy: 1–2 dwarf or semi-dwarf fruit trees (apple, pear, plum, or peach — choose varieties suited to your hardiness zone). (2) Shrub: 2–3 berry bushes (blueberry, currant, gooseberry, or aronia). (3) Herbaceous: Perennial herbs and ground covers (comfrey, oregano, thyme, strawberries, chives). (4) Root: Bulbs and root vegetables (garlic, multiplier onions). (5) Vine: If you have a fence or trellis, add a grape, kiwi, or climbing berry.",
        "Soil preparation (the most important step): Kill existing grass or weeds with a cardboard sheet mulch (the 'lasagna method'). Lay 3–4 layers of cardboard over the entire area, wet it thoroughly, then cover with 4–6 inches of wood chip mulch. Wait 2–4 months for the grass to die and the soil to begin improving — or plant immediately into holes cut through the cardboard.",
        "Select trees for your zone: Use the USDA Plant Hardiness Zone Map (planthardiness.ars.usda.gov) to identify your zone. Order bare-root trees in late winter from Stark Bro's, Trees of Antiquity, or a local nursery — bare-root trees cost $15–30 and establish faster than potted trees.",
        "Plant in the right order: Trees first (they determine spacing for everything else), then shrubs around them, then perennial herbs and ground covers filling the gaps. Space dwarf trees 8–10 feet apart, semi-dwarf 12–15 feet.",
        "The first 3 years — investment phase: Water trees deeply once a week during the first summer. Add compost and mulch annually. Remove grass or weeds from mulch circles around trees. Most fruit trees begin producing meaningfully in year 3–5. Berry shrubs often produce in year 1–2.",
        "Year 5 and beyond — abundance phase: A mature 10x10 food forest planted in dwarf apple, 3 currant bushes, and perennial herbs will yield 50–100 lbs of fruit per year, require under 2 hours of care per month, and provide year-round habitat for birds, beneficial insects, and pollinators. It will outlast you by decades."
    ],
    "uses_location_data": False,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/bio_food_forest.png"
},
    {
    "action_id": "advocacy_contact_representative",
    "name": "Contact Your Representatives on Climate Policy",
    "category": ["advocacy"],
    "environmental_impact_areas": ["Policy Change", "Systemic Impact", "Carbon Reduction at Scale"],
    "description": "Individual lifestyle changes matter, but systemic policy change multiplies their impact by millions. A single well-timed phone call or email to an elected official at a critical vote has measurably more climate impact than a lifetime of personal actions. This is the easiest advocacy action available and takes under 5 minutes.",
    "cost_estimate": "Free",
    "difficulty": "Easy",
    "impact_score": {
        "co2e_reduction_per_year_kg": 0,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 0,
        "water_saved_gallons": 0,
        "advocacy_actions_count": 1
    },
    "is_mvp_action": True,
    "keywords": ["individual", "beginner", "advocacy", "policy", "free", "no-equipment", "systemic"],
    "scientific_basis": "A Yale Program on Climate Change Communication study found that 70% of Americans want elected officials to do more on climate — but only 8% have contacted one. Congressional staffers report that constituent calls and emails are tracked and directly influence how representatives vote on close legislation. A 2021 MIT study found that each additional constituent communication on an issue increases the probability of a representative voting in alignment with constituent preferences by 0.08–0.15% — small individually, significant at scale.",
    "source_link": "https://climatecommunication.yale.edu/publications/climate-change-in-the-american-mind-beliefs-and-attitudes/",
    "step_by_step_guide": [
        "Find your representatives in 30 seconds: Go to whoismyrepresentative.com and enter your zip code. You'll get your US House representative, both US Senators, and your state legislature representatives with direct contact info.",
        "Call instead of email when possible: Phone calls are more effective than emails — staffers tally calls daily and report the count to the representative. You don't need to be eloquent. The script is: 'Hi, my name is [Name] and I'm a constituent from [city]. I'm calling to urge [Representative's name] to support [specific bill or position]. Climate action is very important to me and my family. Thank you.'",
        "Use the ClimaShield advocacy templates: The app provides pre-written, customizable emails and call scripts for current climate legislation. Select your state and the current priority issue, and the app fills in your representative's name and the relevant bill details automatically.",
        "The most effective issues to contact about: Local zoning for renewable energy (solar/wind), state renewable portfolio standards, local building energy codes (requiring efficient construction), public transit funding, and federal clean energy tax credits.",
        "Make it a habit: Set a recurring reminder in ClimaShield for the first Monday of each month — 5 minutes to contact one representative on one current issue. Done consistently for a year, that's 12 contacts across multiple issues — the profile of an engaged constituent whose views carry weight.",
        "Bring others: The impact of constituent contact scales multiplicatively. Sharing a ClimaShield advocacy campaign with 5 friends who each contact their representatives multiplies the reach to cover potentially 5 different congressional districts."
    ],
    "uses_location_data": True,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/advocacy_contact_rep.png"
},

{
    "action_id": "advocacy_local_community_action",
    "name": "Start or Join a Local Climate Action Group",
    "category": ["advocacy", "community"],
    "environmental_impact_areas": ["Systemic Impact", "Community Resilience", "Policy Change"],
    "description": "Individual action + collective organizing = systemic change. Local climate groups have won solar energy ordinances, blocked fossil fuel projects, established community gardens on public land, organized neighborhood tree-planting programs, and influenced city council votes on building codes. This is where personal climate action becomes community-scale impact.",
    "cost_estimate": "Free",
    "difficulty": "Medium",
    "impact_score": {
        "co2e_reduction_per_year_kg": 0,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 0,
        "water_saved_gallons": 0,
        "advocacy_actions_count": 1
    },
    "is_mvp_action": False,
    "keywords": ["individual", "intermediate", "advocacy", "community", "organizing", "systemic", "free"],
    "scientific_basis": "A 2020 study in Nature Climate Change found that community-based social interventions and peer influence are among the most effective mechanisms for spreading sustainable behaviors — more effective than information campaigns alone. Local Citizen Climate Lobby (CCL) chapters have been credited as key factors in passage of state-level renewable energy standards. A Yale meta-analysis found that individuals embedded in climate-active social networks are 2.7x more likely to make high-impact personal changes.",
    "source_link": "https://www.nature.com/articles/s41558-020-0703-3",
    "step_by_step_guide": [
        "Find an existing group first: Search for existing groups in your area before starting a new one. Try: Citizens Climate Lobby (citizensclimatelobby.org/chapters), Sierra Club local chapters (sierraclub.org/chapters), 350.org local groups (350.org/local-groups), or your city's sustainability office website. Joining an existing group is more impactful than starting a competing one.",
        "If no group exists — start one: Invite 5–10 neighbors, coworkers, or friends to an initial meeting. The meeting agenda: (1) Share why each person cares. (2) Identify 1–2 concrete local issues to focus on. (3) Set a next meeting date. You don't need to be an expert — you need to show up and listen.",
        "Choose your first concrete action: The most successful local groups start with one tangible, winnable campaign. Good first projects: a city council resolution supporting renewable energy, a neighborhood tree-planting day, a community composting program, a petition for EV charging in public parking, or a presentation to the local school board on sustainability curriculum.",
        "Connect to ClimaShield's Community Hub: Use the app's Local Action Teams feature to create or join a group in your area. The Hub lets you coordinate actions, share resources, track collective impact, and participate in regional challenges with other ClimaShield users.",
        "The leverage play: Once your group has 20+ members, you become a constituency. Schedule a meeting with your city council member or mayor. Present your members' concerns and a specific, actionable ask — not 'do more on climate' but 'adopt a net-zero building code for new construction by 2030.' Specific asks with organized constituent support get results.",
        "Celebrate wins publicly: When your group achieves a win — however small — post it on social media, tag local news outlets, and share it on ClimaShield. Visibility of local climate wins inspires others and builds your group's reputation and membership."
    ],
    "uses_location_data": True,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/advocacy_community_group.png"
},

    {
    "action_id": "contingency_emergency_preparedness_kit",
    "name": "Build a 72-Hour Climate Emergency Preparedness Kit",
    "category": ["contingency"],
    "environmental_impact_areas": ["Personal Resilience", "Community Resilience"],
    "description": "Extreme weather events — floods, ice storms, heat waves, wildfires — are becoming more frequent and severe due to climate change. Being prepared reduces personal risk, reduces demand on emergency services during disasters, and positions your household to help neighbors who aren't prepared. A 72-hour kit covers the critical window before official disaster relief arrives. This is the first step of the Contingency Plan module.",
    "cost_estimate": "$$",
    "difficulty": "Easy",
    "impact_score": {
        "co2e_reduction_per_year_kg": 0,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 0,
        "water_saved_gallons": 0,
        "resilience_score": 1
    },
    "is_mvp_action": True,
    "keywords": ["individual", "beginner", "contingency", "emergency-prep", "resilience", "family-safety", "climate-adaptation"],
    "scientific_basis": "FEMA's National Preparedness Report (2023) found that only 39% of Americans have an emergency kit with basic supplies. Households with prepared emergency kits recover from disasters 40% faster on average (FEMA, 2022). The American Red Cross recommends a minimum 72-hour supply of food, water, and medication for every household member — the window during which most power outages, evacuation orders, and infrastructure disruptions are resolved. Climate change is increasing the frequency of Category 4–5 hurricanes, multi-day winter storms, and extended heat waves, making preparedness a baseline life skill for every American household.",
    "source_link": "https://www.ready.gov/kit",
    "step_by_step_guide": [
        "Water — the non-negotiable: Store 1 gallon per person per day for 3 days minimum. A family of 4 needs 12 gallons. Use commercially sealed water jugs ($1/gallon at Walmart) or thoroughly cleaned and filled 2-liter bottles. Store in a cool, dark location. Rotate every 6 months. Also add a LifeStraw or Sawyer Mini water filter ($15–20) to handle emergency water from any fresh source.",
        "Food — 3 days, no cooking required: Choose foods that need no refrigeration, no cooking, and minimal preparation. Best options: canned tuna, salmon, and chicken (pop-top cans), peanut butter, crackers, nuts and trail mix, dried fruit, granola bars, instant oatmeal (just needs hot water but can be eaten dry), canned soups and beans. Include a manual can opener. Account for any dietary restrictions or infant formula needs.",
        "Power and light: (1) Hand-crank or battery-powered NOAA weather radio ($25–40, Midland brand) — this is how you receive official emergency alerts when the internet is down. (2) Headlamps for every family member ($10–15 each, Black Diamond brand) — better than flashlights because they keep hands free. (3) Backup battery bank, 20,000mAh minimum ($25–40) — keeps phones charged for 4–6 days. (4) Extra AA and AAA batteries in a waterproof bag.",
        "First aid and medications: A pre-assembled first aid kit ($20–30, Red Cross brand), plus a 2-week supply of any prescription medications in a clearly labeled waterproof container. Add: pain reliever, antidiarrheal, antacids, any allergy medications, and — critically — any medications for children or elderly household members.",
        "Documents — waterproof copies: Place these in a waterproof zip bag: copies of IDs and passports, insurance policy numbers and agent contact info, bank account numbers and emergency cash ($100–200 in small bills — ATMs may be down), a list of emergency contacts written on paper (don't rely on a phone that may be dead or broken), and your home's utility shutoff locations (gas main, water main, electrical panel).",
        "Sanitation and shelter: Emergency mylar blankets ($2 each, last indefinitely), N95 masks (critical during wildfire smoke events), hand sanitizer and antibacterial wipes, a 5-gallon bucket with a toilet seat lid and waste bags (for extended power outages), extra garbage bags, and a change of clothes plus sturdy closed-toe shoes for each family member.",
        "Store it smart: Keep the kit in a large backpack, rolling bin, or designated closet near an exit. Every household member over age 6 should know where it is. Review and replace expired food and batteries every January 1st — make it an annual New Year's Day tradition.",
        "Make an evacuation plan: Identify 2 exit routes from your home, a meeting point outside (in case family members are separated), and a secondary meeting point outside your neighborhood. Identify where you would go if you had to leave home for 3+ days. Share the plan with everyone in your household, including children."
    ],
    "uses_location_data": False,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/contingency_emergency_kit.png"
},

{
    "action_id": "contingency_home_resilience_assessment",
    "name": "Assess and Harden Your Home Against Local Climate Risks",
    "category": ["contingency"],
    "environmental_impact_areas": ["Personal Resilience", "Property Protection", "Community Resilience"],
    "description": "Different regions face different climate threats — floods, wildfires, tornadoes, extreme heat, ice storms, hurricanes. This action walks you through identifying your specific local risks and taking the 3–5 highest-impact hardening measures for your home and geography. Preparedness is not just about a kit in a closet — it's about making your home structurally resilient to the hazards most likely to affect it.",
    "cost_estimate": "$$",
    "difficulty": "Medium",
    "impact_score": {
        "co2e_reduction_per_year_kg": 0,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 0,
        "water_saved_gallons": 0,
        "resilience_score": 2
    },
    "is_mvp_action": False,
    "keywords": ["individual", "intermediate", "contingency", "home-resilience", "climate-adaptation", "wildfire", "flood", "heat"],
    "scientific_basis": "NOAA's 2023 Billion-Dollar Weather and Climate Disasters report recorded 28 separate billion-dollar disasters in the US — a record. Swiss Re estimates that uninsured losses from climate-related events exceeded $110 billion in the US in 2023. FEMA's Building Science division documents that homes built or retrofitted to current resilience standards survive major storm events with 60–80% lower structural damage than unretrofitted homes of the same age.",
    "source_link": "https://www.fema.gov/emergency-managers/risk-management/building-science",
    "step_by_step_guide": [
        "Step 1 — Identify your top 3 local hazards: Go to FEMA's Hazard Mitigation Planning page (msc.fema.gov) and enter your address. Check for: your flood zone designation (if Zone A or AE, flood risk is real), wildfire risk index (CAL FIRE and USFS data), tornado risk zone, and extreme heat day projections for 2050. Also check your state's SHELDUS database for historical weather damage in your county.",
        "Step 2 — Flood hardening ($50–500 depending on risk level): If you're in a flood zone or basement-flooding area: (a) Install check valves on all floor drains and toilet connections ($25–50 each, plumber install) to prevent sewage backflow during floods. (b) Seal basement walls with hydraulic cement or waterproof paint ($40–80, Drylok brand). (c) Elevate your furnace, water heater, and electrical panel off the floor if they're in a basement flood zone. (d) Purchase flood insurance separately from homeowners insurance if you're in Zone A/AE — it is NOT covered by standard homeowners policies.",
        "Step 3 — Wildfire hardening ($100–1,000 depending on risk): If you're in a wildfire risk area (most of the West): (a) Create 30 feet of 'defensible space' around your home — remove dead vegetation, limb trees 6 feet off the ground, and space plants so fire cannot ladder up from ground to tree canopy. (b) Install ember-resistant vents ($15–40 each, Vulcan Vents brand) to prevent wind-blown embers from entering your attic — the #1 cause of home ignition. (c) Screen all openings with 1/8-inch or smaller wire mesh. (d) Replace wood mulch within 5 feet of the house with gravel or concrete.",
        "Step 4 — Extreme heat hardening ($0–200): (a) Identify the coolest room in your home (usually interior, lowest floor, north-facing) and designate it as your 'cool room' during heat emergencies. (b) Install a window air conditioner in that room if you don't have central AC ($150–300). (c) Plant shade trees on the south and west sides of your home — mature trees reduce cooling costs by 15–35% and create a microclimate 2–9°F cooler than paved areas. (d) Add reflective window film to south and west-facing windows ($20–40 per window) to block solar heat gain.",
        "Step 5 — Power outage resilience ($50–5,000 depending on level): (a) Minimum: The battery bank from your emergency kit + a 100W solar panel from the solar series can power lights, phone charging, and a fan indefinitely during an outage. (b) Intermediate: Your Step 2–3 solar series battery bank can power a mini-fridge, fan, and medical devices for days. (c) Full backup: Step 5 of the solar series (whole-home battery backup) eliminates most outage vulnerability entirely.",
        "Step 6 — Review your insurance: Pull out your homeowners or renters insurance policy. Verify: Are you covered for the hazards most relevant to your location? What is your deductible for wind, hail, and water damage? Do you have replacement cost coverage or actual cash value? If you're in a flood zone, do you have a separate NFIP flood policy? Underinsurance is the most common and most financially devastating disaster preparedness gap."
    ],
    "uses_location_data": True,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/contingency_home_resilience.png"
},

{
    "action_id": "contingency_community_resilience_network",
    "name": "Build a Neighborhood Mutual Aid Network",
    "category": ["contingency", "community"],
    "environmental_impact_areas": ["Community Resilience", "Social Capital", "Climate Adaptation"],
    "description": "After Hurricane Katrina, the neighborhoods that fared best weren't those with the most money or the newest buildings — they were the ones where neighbors knew each other. Social capital — knowing your neighbors, sharing skills and resources, looking out for each other — is the most powerful resilience asset available and costs nothing to build. This action establishes a neighborhood mutual aid network before disaster strikes.",
    "cost_estimate": "Free",
    "difficulty": "Medium",
    "impact_score": {
        "co2e_reduction_per_year_kg": 0,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 0,
        "water_saved_gallons": 0,
        "resilience_score": 3
    },
    "is_mvp_action": False,
    "keywords": ["individual", "intermediate", "contingency", "community", "mutual-aid", "resilience", "neighbors", "free"],
    "scientific_basis": "Research published in Nature Climate Change (2020) found that communities with high social cohesion recover from climate disasters 2–4x faster than socially isolated communities, controlling for income and infrastructure quality. A FEMA-funded study found that 74% of disaster survivors were rescued by neighbors before first responders arrived — not by official emergency services. The Sendai Framework for Disaster Risk Reduction (UN, 2015) identifies social capital as a primary driver of community resilience.",
    "source_link": "https://www.preventionweb.net/sendai-framework/sendai-framework-monitor",
    "step_by_step_guide": [
        "Start with a simple neighbor survey: Create a one-page paper or Google Form with 5 questions: (1) Name and address. (2) Do you have any medical needs that would require assistance during an evacuation? (3) Do you have any skills that could help neighbors during an emergency (medical, electrical, mechanical, first aid, Spanish/other language)? (4) Do you have equipment that could be shared (generator, chainsaw, truck, extra water storage)? (5) Are you willing to be part of a neighborhood emergency contact network? Distribute to 20 nearest neighbors.",
        "Create a neighborhood contact list: Compile responses into a simple shared document. Include names, phone numbers, addresses, and any noted skills or needs. Print and distribute to all participants. This document has value before any disaster — it's also just a good neighborhood directory.",
        "Identify your most vulnerable neighbors: Elderly neighbors living alone, households with young children, people with mobility limitations, and households without vehicles are the most at-risk during emergencies. Note these households specifically and designate a 'buddy' neighbor to check on each one during any emergency.",
        "Host one neighborhood resilience meeting: Gather willing neighbors for a 45-minute meeting. Agenda: (1) Share what you learned about your area's top hazards from the home resilience assessment. (2) Discuss what your neighborhood would need if power was out for 5 days. (3) Identify 3 concrete things you could do together: establish a neighborhood communication channel (GroupMe or Signal group), designate a neighborhood meeting point in emergencies, and agree to check on identified vulnerable neighbors during any emergency.",
        "Build your shared resource inventory: After the meeting, create a shared document listing what resources the network has collectively — generators, chainsaws, medical equipment, extra food and water storage, vehicles, medical skills, etc. This shared inventory transforms individual preparations into community-scale resilience.",
        "Connect to ClimaShield's Community Hub: Use the app's Local Action Teams feature to document your mutual aid network. Share the skills and resources inventory privately among members. The Contingency Plan module will show your network's collective resilience score and suggest next steps — like coordinating a group purchase of emergency supplies or organizing a neighborhood emergency drill."
    ],
    "uses_location_data": True,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/contingency_mutual_aid.png"
},

{
    "action_id": "contingency_food_water_security",
    "name": "Build 30-Day Household Food and Water Security",
    "category": ["contingency"],
    "environmental_impact_areas": ["Personal Resilience", "Food Security", "Supply Chain Independence"],
    "description": "Supply chain disruptions, extended power outages, extreme weather, and infrastructure failures can interrupt access to grocery stores and municipal water for days to weeks. Building a 30-day food and water supply for your household is the difference between a difficult situation and a crisis. This is not prepping in the bunker sense — it's the same practical preparedness the American Red Cross, FEMA, and the CDC all recommend.",
    "cost_estimate": "$$",
    "difficulty": "Medium",
    "impact_score": {
        "co2e_reduction_per_year_kg": 0,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 0,
        "water_saved_gallons": 0,
        "resilience_score": 2
    },
    "is_mvp_action": False,
    "keywords": ["individual", "intermediate", "contingency", "food-storage", "water-storage", "resilience", "supply-chain"],
    "scientific_basis": "The USDA's Economic Research Service found that following COVID-19 supply disruptions in 2020, households with more than 7 days of food on hand experienced 60% less food insecurity than those with fewer than 3 days. FEMA recommends a minimum 2-week supply, the CDC recommends 30 days for households with medical needs. A 30-day supply for a family of 4 costs approximately $300–500 built gradually and eliminates reliance on fragile just-in-time grocery supply chains during regional emergencies.",
    "source_link": "https://www.ready.gov/food",
    "step_by_step_guide": [
        "The 'buy extra on every trip' method: You don't need to spend $300 in one shopping trip. Instead, spend an extra $10–20 per week on non-perishables for 8–12 weeks. Every grocery trip, add a few extra cans of beans, a bag of rice, extra peanut butter, extra pasta. After 3 months, you have a meaningful supply without straining your budget.",
        "The 30-day food list for one person (multiply for household size): White rice — 20 lbs ($12). Dried lentils — 10 lbs ($10). Canned beans (black, kidney, pinto) — 24 cans ($24). Canned tuna or salmon — 12 cans ($18). Peanut butter — 4 large jars ($24). Oats — 10 lbs ($8). Pasta — 10 lbs ($10). Canned tomatoes and soups — 24 cans ($20). Crackers — 4 boxes ($12). Nuts and trail mix — 3 lbs ($15). Oil (olive or coconut) — 2 liters ($10). Salt, sugar, spices, multivitamins. TOTAL: approximately $163/person, or $650 for a family of 4.",
        "Water storage — 30 days: At 1 gallon per person per day, a family of 4 needs 120 gallons for 30 days. Options: (a) WaterBOB bathtub bladder ($30, fills a bathtub with 100 gallons of clean water in minutes before a storm), (b) 5-gallon water jugs with siphon pump ($5 each, rotate every 6 months), (c) A 55-gallon food-grade barrel ($50–80) that can be kept in a garage. Also store water purification tablets ($10 per 50-tablet bottle, treats 50 gallons) and a Sawyer Squeeze filter ($25) as backup.",
        "Storage best practices: Store food in a cool, dark, dry location — ideally below 70°F. Use the First In, First Out (FIFO) method — eat from the front of the shelf and restock from the back so nothing expires unused. Label everything with purchase date using a Sharpie. Check and rotate stock every 6 months, on a calendar reminder.",
        "Add a camp stove or rocket stove: If your power goes out for more than a day, your electric stove won't work and your gas stove may not work either. Keep a two-burner propane camp stove ($40–60, Coleman brand) with 4 extra propane canisters, or build a simple rocket stove from cinder blocks that burns twigs. These let you cook your stored food even in an extended outage.",
        "Integrate with your growing systems: Your container garden (from the food garden action), fruit trees, and composting system are all force multipliers for food security. Fresh vegetables from a garden, preserved summer produce, and compost-grown food reduce how much stored food you need to maintain and connect your resilience system to your climate surplus actions."
    ],
    "uses_location_data": False,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/contingency_food_water_security.png"
},

    {
    "action_id": "waste_repair_before_replace",
    "name": "Repair Before You Replace: The Right-to-Repair Habit",
    "category": ["waste"],
    "environmental_impact_areas": ["Waste Reduction", "Carbon Reduction", "Cost Savings"],
    "description": "Manufacturing new products — especially electronics, appliances, and clothing — is extraordinarily carbon-intensive. A new smartphone generates approximately 70 kg CO2e just in manufacturing before you turn it on. Repairing instead of replacing extends product life, reduces manufacturing demand, and saves money. The Right to Repair movement is gaining legal traction — learning to fix your own things is both a climate act and a form of independence.",
    "cost_estimate": "$",
    "difficulty": "Easy",
    "impact_score": {
        "co2e_reduction_per_year_kg": 120,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 15,
        "water_saved_gallons": 0
    },
    "is_mvp_action": False,
    "keywords": ["individual", "beginner", "waste", "repair", "right-to-repair", "electronics", "clothing", "zero-waste"],
    "scientific_basis": "A European Environment Agency study found that extending the life of all smartphones in the EU by one year would save as much CO2e as removing 2 million cars from the road. The Carbon Trust estimates that manufacturing a new washing machine produces approximately 240 kg CO2e — repairing one generates approximately 3 kg CO2e. The global repair economy is estimated to prevent 8–11 million tonnes of CO2e annually (Ellen MacArthur Foundation, 2021).",
    "source_link": "https://www.ellenmacarthurfoundation.org/topics/circular-economy/overview",
    "step_by_step_guide": [
        "The 'repair first' decision rule: Before replacing any broken item, ask three questions: (1) Is the repair cost less than 50% of replacement cost? (2) Is a repair tutorial available on YouTube or iFixit.com? (3) Are parts available for under $30? If yes to any two, attempt repair before buying new.",
        "iFixit.com is your most valuable repair resource: iFixit has free, step-by-step repair guides with photos for thousands of devices — smartphones, laptops, tablets, appliances, game consoles. Every guide includes a parts list with direct purchase links and a difficulty rating. Start here for any electronic repair.",
        "The 5 most common DIY repairs that save the most money and CO2e: (1) Phone screen replacement ($20–50 in parts, saves buying a $400–1,200 new phone). (2) Laptop battery replacement ($15–40, extends laptop life 3–5 years). (3) Washing machine door seal or drain pump ($15–30, saves a $500–800 replacement). (4) Clothing — learning basic mending (sewing a button, patching a hole) keeps garments out of landfill. (5) Bicycle tube replacement and brake adjustment ($5–10 in parts, keeps your bike functional and your car parked).",
        "Local repair resources: Search for 'repair café [your city]' — these are free community events where skilled volunteers help you fix clothing, electronics, bicycles, furniture, and more. The Repair Café Foundation has 2,500+ locations worldwide. Also check your library for a 'tool library' that may lend specialty repair tools.",
        "Buy refurbished, not new: When you do need to replace something, buy certified refurbished instead of new. Refurbished iPhones, laptops, and appliances carry the same warranties as new, cost 30–50% less, and consume no additional manufacturing carbon. Apple Certified Refurbished, Back Market, and manufacturer-certified refurb programs are the most reliable sources.",
        "The clothing repair starter kit ($15): 5 hand-sewing needles, black and white thread, a seam ripper, iron-on denim patches, and 4 replacement buttons. These 5 items can repair 90% of clothing failures. YouTube search 'sewing a button' or 'visible mending' for tutorials. Mending your own clothing has become a visible aesthetic choice — the Japanese art of kintsugi (repairing with gold) applied to fabric."
    ],
    "uses_location_data": False,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/waste_repair_replace.png"
},

{
    "action_id": "waste_second_hand_first",
    "name": "Buy Second-Hand First for Clothing and Household Goods",
    "category": ["waste"],
    "environmental_impact_areas": ["Waste Reduction", "Carbon Reduction", "Cost Savings"],
    "description": "The fashion industry produces 10% of global carbon emissions — more than aviation and shipping combined. A single pair of new jeans requires 1,800 gallons of water to produce. Adopting a 'second-hand first' policy for clothing and household goods eliminates manufacturing emissions entirely for those purchases, saves 40–80% on cost, and directly reduces demand for fast fashion.",
    "cost_estimate": "$",
    "difficulty": "Easy",
    "impact_score": {
        "co2e_reduction_per_year_kg": 95,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 20,
        "water_saved_gallons": 9000
    },
    "is_mvp_action": True,
    "keywords": ["individual", "beginner", "waste", "fashion", "thrift", "second-hand", "zero-waste", "cost-savings"],
    "scientific_basis": "A ThredUp Resale Report (2023) found that buying one used item instead of new saves an average of 1.3 kg CO2e and prevents 500 gallons of water use. The average American buys 68 new clothing items per year — shifting 50% of purchases to second-hand prevents approximately 44 kg CO2e and saves 17,000 gallons of water annually. A 2021 Finnish Environment Institute study found that extending a garment's active life by 9 months reduces its carbon, water, and waste footprint by 20–30% each.",
    "source_link": "https://www.thredup.com/resale/",
    "step_by_step_guide": [
        "The second-hand first rule: Before buying any clothing, shoes, furniture, kitchenware, tools, or sports equipment new, spend 5 minutes checking: (1) ThredUp or Poshmark for clothing. (2) Facebook Marketplace or Craigslist for furniture and household goods. (3) eBay for electronics, tools, and specialty items. (4) Your local thrift stores (Goodwill, Salvation Army, local consignment shops) for everything. If you find what you need second-hand for a fair price, buy it. Only buy new if second-hand isn't available or suitable.",
        "Best items to always buy second-hand: (a) Children's clothing — kids outgrow clothes in 3–6 months. Buying secondhand and reselling when outgrown costs essentially nothing. (b) Furniture — solid wood furniture from the 1970s–1990s is often better quality than new particle board furniture at twice the price. (c) Tools and sporting equipment — power tools, bicycles, skis, camping gear are ideal used buys. (d) Books and media — 100% of the content, 10% of the cost and zero new manufacturing.",
        "Best platforms by category: Clothing → ThredUp (curated, quality-checked), Poshmark, Depop (streetwear/vintage), local consignment boutiques. Electronics → Back Market (certified refurbished with warranty), Swappa (peer-to-peer, verified working). Furniture and household → Facebook Marketplace (local pickup, no shipping), Craigslist, OfferUp, local estate sales. Books → ThriftBooks.com, Better World Books (donates proceeds to literacy programs), local used bookstores.",
        "Quality assessment for used clothing: Check the fabric content label — natural fibers (cotton, wool, linen, silk) last longer than synthetic blends. Check seams, zippers, and buttons before buying. Avoid items with permanent stains, pilling, or weakened fabric at stress points. A 5-second check saves you from buying something unwearable.",
        "Sell and donate what you don't wear: Do a seasonal wardrobe audit and remove items you haven't worn in 12 months. Sell quality items on Poshmark or Facebook Marketplace (earn $10–50 per item). Donate clean, wearable items to Goodwill or a local women's shelter. Worn-out natural fiber textiles can be composted — cut into small pieces and add to your compost bin.",
        "Track in ClimaShield: Log each second-hand purchase. The app calculates the CO2e avoided (versus buying new), water saved, and waste prevented for each category of item. Over a year, ClimaShield's Waste module shows your cumulative impact — often surprisingly significant."
    ],
    "uses_location_data": False,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/waste_second_hand.png"
},

{
    "action_id": "waste_zero_waste_kitchen",
    "name": "Build a Zero-Waste Kitchen",
    "category": ["waste"],
    "environmental_impact_areas": ["Plastic Reduction", "Waste Reduction", "Carbon Reduction", "Cost Savings"],
    "description": "The kitchen is the single largest source of household waste — packaging, food scraps, paper towels, plastic wrap, single-use bags, and disposable containers. A zero-waste kitchen systematically replaces disposable items with reusable ones, buys food with minimal packaging, and ensures nothing organic goes to a landfill. This action combines and advances your existing plastic reduction, bar soap, and composting actions.",
    "cost_estimate": "$$",
    "difficulty": "Medium",
    "impact_score": {
        "co2e_reduction_per_year_kg": 150,
        "pollinator_habitat_sq_ft": 0,
        "waste_diverted_kg": 150,
        "water_saved_gallons": 0
    },
    "is_mvp_action": False,
    "keywords": ["individual", "intermediate", "waste", "zero-waste", "kitchen", "plastic-free", "packaging"],
    "scientific_basis": "The EPA's 2022 Waste Characterization report found that food and food-related packaging account for 45% of municipal solid waste in the US. The average American generates 4.9 lbs of waste per day — approximately 1,800 lbs per year. A committed zero-waste kitchen can reduce household waste by 50–70%, preventing approximately 900–1,260 lbs (408–571 kg) of waste from landfill annually. Plastic packaging, paper towels, and food waste together represent the largest share of kitchen-generated CO2e.",
    "source_link": "https://www.epa.gov/facts-and-figures-about-materials-waste-and-recycling",
    "step_by_step_guide": [
        "Audit your kitchen waste for one week: Before making any changes, track everything you throw away for 7 days. Categorize by type: food scraps, plastic packaging, paper products, glass, metal. This tells you exactly where to focus — most households find food scraps and plastic packaging are 80% of their kitchen waste.",
        "Replace paper towels: Switch to a stack of cotton 'unpaper towels' — cut old t-shirts or buy a pack of cheap washcloths ($10 for 12 at Walmart). Keep them in the same spot as your paper towels. Wash weekly with your regular laundry. The average household spends $182/year on paper towels — this swap saves that entirely. CO2e reduction: approximately 25 kg/year.",
        "Replace plastic wrap and zip bags: (a) Beeswax wraps ($15 for 3, Bee's Wrap brand) — reusable food wrap that adheres with hand warmth, lasts 1 year with proper care. (b) Silicone stretch lids ($12 for 6) — stretch over any bowl or container to seal. (c) Stasher silicone bags ($10–18 each) — replace zip freezer bags, go in the dishwasher, last 3,000+ uses. (d) Simply use your existing glass jars and food containers with lids instead of buying new.",
        "Reduce packaging at the source: (a) Buy dry goods (rice, oats, nuts, flour, pasta, spices) from bulk bins when available — bring your own jars or bags. (b) Choose glass over plastic when packaging options exist. (c) Buy a larger size instead of multiple smaller sizes — a 64 oz yogurt has 75% less packaging per oz than four 16 oz cups. (d) Shop at farmers markets for packaging-free produce.",
        "Complete your composting loop: Every food scrap that doesn't go to landfill is a win. If you've already set up a compost bin (from your existing composting action), you've handled the biggest kitchen waste stream. Make it even easier by keeping a small countertop compost crock ($15–20, simplehuman or OXO brand) next to the sink — empty it to your outdoor bin every 2–3 days.",
        "The zero-waste kitchen transformation timeline: Month 1: Paper towels → cloth towels. Compost all food scraps. Month 2: Plastic wrap → beeswax wraps and silicone lids. Month 3: Start buying bulk dry goods. Month 4: Audit remaining packaging and find alternatives for your top 5 most-purchased packaged items. By month 4, most households have reduced kitchen waste by 50–65% with a total investment under $60."
    ],
    "uses_location_data": False,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/waste_zero_waste_kitchen.png"
},

    {
    "action_id": "bio_tree_planting",
    "name": "Plant 3 Native Trees in Your Yard or Community",
    "category": ["biodiversity"],
    "environmental_impact_areas": ["Carbon Sequestration", "Biodiversity", "Urban Heat Island Reduction", "Water Management"],
    "description": "Trees are one of the most effective natural climate solutions available. A single mature native tree sequesters 20–50 kg CO2e per year, hosts hundreds of species of insects and birds, reduces urban heat island temperatures by 2–9°F, manages stormwater, and produces oxygen. Native species provide all of these benefits while requiring zero irrigation once established.",
    "cost_estimate": "$",
    "difficulty": "Easy",
    "impact_score": {
        "co2e_reduction_per_year_kg": 90,
        "pollinator_habitat_sq_ft": 50,
        "waste_diverted_kg": 0,
        "water_saved_gallons": 1500
    },
    "is_mvp_action": True,
    "keywords": ["individual", "beginner", "biodiversity", "trees", "carbon-sequestration", "native-plants", "community"],
    "scientific_basis": "The Crowther Lab at ETH Zürich estimated that restoring 0.9 billion hectares of tree cover globally could sequester 205 billion tonnes of carbon over decades — the most effective climate restoration tool at scale. A mature oak tree sequesters approximately 48 kg CO2e/year and supports 557 species of caterpillars alone (Tallamy, 2021). Native trees require 50–70% less water than non-native ornamentals once established and provide ecosystem services (stormwater interception, urban cooling, wildlife habitat) that ornamental trees cannot match.",
    "source_link": "https://www.science.org/doi/10.1126/science.aax0848",
    "step_by_step_guide": [
        "Choose native species for your region: The Arbor Day Foundation's tree finder (arborday.org/trees/treeguide) lets you enter your zip code and get a curated list of native trees suited to your soil and climate. Best native trees for their ecological value by region: Northeast — White Oak, Serviceberry, River Birch. Southeast — Longleaf Pine, Sweetbay Magnolia, Redbud. Midwest — Bur Oak, Shagbark Hickory, Hackberry. Southwest — Mesquite, Desert Willow, Velvet Ash. Pacific Northwest — Western Red Cedar, Oregon White Oak, Pacific Dogwood.",
        "Right tree, right place: Before planting, check: (1) Overhead utility lines — never plant a large-maturing tree under power lines. (2) Underground utilities — call 811 (free national dig-safe service) before digging any hole. (3) Mature spread — make sure the tree has enough space to reach its full canopy size without damaging structures. (4) Sun and soil requirements — match the tree to your site conditions.",
        "How to plant a tree correctly: Dig a wide, shallow hole — 3x the width of the root ball but no deeper than the root ball height. The root flare (where trunk widens at the base) must sit at or slightly above ground level. Place the tree, backfill with the original soil (no amendments in the hole — they create a 'pot effect'), and tamp gently to remove air pockets. Create a 3-inch mulch ring 3 feet in diameter around the base, keeping mulch 3–4 inches away from the trunk.",
        "Watering for establishment: Water deeply (10–15 gallons) at planting, then once a week for the first growing season. Reduce to every 2 weeks in year 2. After year 3, a native tree is generally self-sustaining on rainfall and needs no supplemental irrigation.",
        "Get free or subsidized trees: (a) The Arbor Day Foundation gives away 10 free trees to new members ($15 membership). (b) Many cities offer free tree programs — search '[your city] free tree program'. (c) State forestry departments often distribute native trees for $1–5. (d) Local native plant societies frequently hold spring plant sales at deep discounts.",
        "Can't plant in your yard? Community options: (1) Contact your city's parks and street tree program — many cities need volunteers to plant and water street trees. (2) Partner with a local school, church, or community garden to plant trees on their land. (3) Organize a neighborhood tree-planting day through ClimaShield's Community Hub — 10 households each planting 3 trees = 30 trees and 2,700 kg CO2e sequestered annually."
    ],
    "uses_location_data": False,
    "video_tutorial_url": None,
    "image_url": "https://storage.googleapis.com/climateshield-app-assets/bio_tree_planting.png"
},
]

# Push each action to Firestore using action_id as the document ID
collection = db.collection("actions")

for action in actions:
    doc_id = action["action_id"]
    collection.document(doc_id).set(action)
    print(f"✓ Uploaded: {action['name']}")

print("\n✅ All actions seeded successfully!")