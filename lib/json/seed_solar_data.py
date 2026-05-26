import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# Source: NREL PVWatts national averages per state
# peak_sun_hours = average daily peak sun hours for a south-facing 40° tilt panel
# annual_kwh = 100W panel output per year
# co2e_kg = annual_kwh * state grid emissions factor (EPA eGRID 2023)
# grid_emissions_factor = kg CO2e per kWh for that state's grid

solar_data = [
    {"state": "Alabama", "code": "AL", "peak_sun_hours": 4.7, "annual_kwh": 172, "co2e_reduction_per_year_kg": 71, "grid_emissions_factor": 0.413},
    {"state": "Alaska", "code": "AK", "peak_sun_hours": 3.1, "annual_kwh": 113, "co2e_reduction_per_year_kg": 57, "grid_emissions_factor": 0.505},
    {"state": "Arizona", "code": "AZ", "peak_sun_hours": 6.5, "annual_kwh": 237, "co2e_reduction_per_year_kg": 87, "grid_emissions_factor": 0.367},
    {"state": "Arkansas", "code": "AR", "peak_sun_hours": 4.7, "annual_kwh": 172, "co2e_reduction_per_year_kg": 72, "grid_emissions_factor": 0.419},
    {"state": "California", "code": "CA", "peak_sun_hours": 5.6, "annual_kwh": 204, "co2e_reduction_per_year_kg": 44, "grid_emissions_factor": 0.215},
    {"state": "Colorado", "code": "CO", "peak_sun_hours": 5.5, "annual_kwh": 201, "co2e_reduction_per_year_kg": 91, "grid_emissions_factor": 0.453},
    {"state": "Connecticut", "code": "CT", "peak_sun_hours": 4.2, "annual_kwh": 153, "co2e_reduction_per_year_kg": 44, "grid_emissions_factor": 0.288},
    {"state": "Delaware", "code": "DE", "peak_sun_hours": 4.4, "annual_kwh": 161, "co2e_reduction_per_year_kg": 58, "grid_emissions_factor": 0.360},
    {"state": "Florida", "code": "FL", "peak_sun_hours": 5.2, "annual_kwh": 190, "co2e_reduction_per_year_kg": 77, "grid_emissions_factor": 0.405},
    {"state": "Georgia", "code": "GA", "peak_sun_hours": 4.9, "annual_kwh": 179, "co2e_reduction_per_year_kg": 68, "grid_emissions_factor": 0.380},
    {"state": "Hawaii", "code": "HI", "peak_sun_hours": 5.8, "annual_kwh": 212, "co2e_reduction_per_year_kg": 128, "grid_emissions_factor": 0.604},
    {"state": "Idaho", "code": "ID", "peak_sun_hours": 4.9, "annual_kwh": 179, "co2e_reduction_per_year_kg": 26, "grid_emissions_factor": 0.145},
    {"state": "Illinois", "code": "IL", "peak_sun_hours": 4.5, "annual_kwh": 164, "co2e_reduction_per_year_kg": 64, "grid_emissions_factor": 0.390},
    {"state": "Indiana", "code": "IN", "peak_sun_hours": 4.4, "annual_kwh": 161, "co2e_reduction_per_year_kg": 89, "grid_emissions_factor": 0.553},
    {"state": "Iowa", "code": "IA", "peak_sun_hours": 4.5, "annual_kwh": 164, "co2e_reduction_per_year_kg": 57, "grid_emissions_factor": 0.347},
    {"state": "Kansas", "code": "KS", "peak_sun_hours": 5.1, "annual_kwh": 186, "co2e_reduction_per_year_kg": 76, "grid_emissions_factor": 0.409},
    {"state": "Kentucky", "code": "KY", "peak_sun_hours": 4.4, "annual_kwh": 161, "co2e_reduction_per_year_kg": 88, "grid_emissions_factor": 0.547},
    {"state": "Louisiana", "code": "LA", "peak_sun_hours": 4.9, "annual_kwh": 179, "co2e_reduction_per_year_kg": 76, "grid_emissions_factor": 0.425},
    {"state": "Maine", "code": "ME", "peak_sun_hours": 4.2, "annual_kwh": 153, "co2e_reduction_per_year_kg": 26, "grid_emissions_factor": 0.170},
    {"state": "Maryland", "code": "MD", "peak_sun_hours": 4.5, "annual_kwh": 164, "co2e_reduction_per_year_kg": 54, "grid_emissions_factor": 0.329},
    {"state": "Massachusetts", "code": "MA", "peak_sun_hours": 4.2, "annual_kwh": 153, "co2e_reduction_per_year_kg": 44, "grid_emissions_factor": 0.288},
    {"state": "Michigan", "code": "MI", "peak_sun_hours": 4.1, "annual_kwh": 150, "co2e_reduction_per_year_kg": 64, "grid_emissions_factor": 0.427},
    {"state": "Minnesota", "code": "MN", "peak_sun_hours": 4.5, "annual_kwh": 164, "co2e_reduction_per_year_kg": 62, "grid_emissions_factor": 0.378},
    {"state": "Mississippi", "code": "MS", "peak_sun_hours": 4.8, "annual_kwh": 175, "co2e_reduction_per_year_kg": 73, "grid_emissions_factor": 0.417},
    {"state": "Missouri", "code": "MO", "peak_sun_hours": 4.7, "annual_kwh": 172, "co2e_reduction_per_year_kg": 82, "grid_emissions_factor": 0.477},
    {"state": "Montana", "code": "MT", "peak_sun_hours": 5.0, "annual_kwh": 183, "co2e_reduction_per_year_kg": 58, "grid_emissions_factor": 0.317},
    {"state": "Nebraska", "code": "NE", "peak_sun_hours": 5.0, "annual_kwh": 183, "co2e_reduction_per_year_kg": 72, "grid_emissions_factor": 0.394},
    {"state": "Nevada", "code": "NV", "peak_sun_hours": 6.4, "annual_kwh": 234, "co2e_reduction_per_year_kg": 76, "grid_emissions_factor": 0.325},
    {"state": "New Hampshire", "code": "NH", "peak_sun_hours": 4.2, "annual_kwh": 153, "co2e_reduction_per_year_kg": 35, "grid_emissions_factor": 0.229},
    {"state": "New Jersey", "code": "NJ", "peak_sun_hours": 4.5, "annual_kwh": 164, "co2e_reduction_per_year_kg": 52, "grid_emissions_factor": 0.317},
    {"state": "New Mexico", "code": "NM", "peak_sun_hours": 6.3, "annual_kwh": 230, "co2e_reduction_per_year_kg": 97, "grid_emissions_factor": 0.422},
    {"state": "New York", "code": "NY", "peak_sun_hours": 4.2, "annual_kwh": 153, "co2e_reduction_per_year_kg": 31, "grid_emissions_factor": 0.203},
    {"state": "North Carolina", "code": "NC", "peak_sun_hours": 4.8, "annual_kwh": 175, "co2e_reduction_per_year_kg": 58, "grid_emissions_factor": 0.332},
    {"state": "North Dakota", "code": "ND", "peak_sun_hours": 4.8, "annual_kwh": 175, "co2e_reduction_per_year_kg": 81, "grid_emissions_factor": 0.463},
    {"state": "Ohio", "code": "OH", "peak_sun_hours": 4.2, "annual_kwh": 153, "co2e_reduction_per_year_kg": 74, "grid_emissions_factor": 0.484},
    {"state": "Oklahoma", "code": "OK", "peak_sun_hours": 5.3, "annual_kwh": 193, "co2e_reduction_per_year_kg": 74, "grid_emissions_factor": 0.383},
    {"state": "Oregon", "code": "OR", "peak_sun_hours": 4.5, "annual_kwh": 164, "co2e_reduction_per_year_kg": 26, "grid_emissions_factor": 0.159},
    {"state": "Pennsylvania", "code": "PA", "peak_sun_hours": 4.3, "annual_kwh": 157, "co2e_reduction_per_year_kg": 62, "grid_emissions_factor": 0.395},
    {"state": "Rhode Island", "code": "RI", "peak_sun_hours": 4.2, "annual_kwh": 153, "co2e_reduction_per_year_kg": 43, "grid_emissions_factor": 0.281},
    {"state": "South Carolina", "code": "SC", "peak_sun_hours": 5.0, "annual_kwh": 183, "co2e_reduction_per_year_kg": 57, "grid_emissions_factor": 0.311},
    {"state": "South Dakota", "code": "SD", "peak_sun_hours": 5.0, "annual_kwh": 183, "co2e_reduction_per_year_kg": 50, "grid_emissions_factor": 0.273},
    {"state": "Tennessee", "code": "TN", "peak_sun_hours": 4.7, "annual_kwh": 172, "co2e_reduction_per_year_kg": 47, "grid_emissions_factor": 0.273},
    {"state": "Texas", "code": "TX", "peak_sun_hours": 5.5, "annual_kwh": 201, "co2e_reduction_per_year_kg": 80, "grid_emissions_factor": 0.398},
    {"state": "Utah", "code": "UT", "peak_sun_hours": 5.8, "annual_kwh": 212, "co2e_reduction_per_year_kg": 88, "grid_emissions_factor": 0.415},
    {"state": "Vermont", "code": "VT", "peak_sun_hours": 4.1, "annual_kwh": 150, "co2e_reduction_per_year_kg": 15, "grid_emissions_factor": 0.100},
    {"state": "Virginia", "code": "VA", "peak_sun_hours": 4.6, "annual_kwh": 168, "co2e_reduction_per_year_kg": 56, "grid_emissions_factor": 0.333},
    {"state": "Washington", "code": "WA", "peak_sun_hours": 4.2, "annual_kwh": 153, "co2e_reduction_per_year_kg": 17, "grid_emissions_factor": 0.111},
    {"state": "West Virginia", "code": "WV", "peak_sun_hours": 4.3, "annual_kwh": 157, "co2e_reduction_per_year_kg": 101, "grid_emissions_factor": 0.643},
    {"state": "Wisconsin", "code": "WI", "peak_sun_hours": 4.4, "annual_kwh": 161, "co2e_reduction_per_year_kg": 65, "grid_emissions_factor": 0.404},
    {"state": "Wyoming", "code": "WY", "peak_sun_hours": 5.3, "annual_kwh": 193, "co2e_reduction_per_year_kg": 96, "grid_emissions_factor": 0.497},
    {"state": "Washington DC", "code": "DC", "peak_sun_hours": 4.5, "annual_kwh": 164, "co2e_reduction_per_year_kg": 54, "grid_emissions_factor": 0.329},
]

collection = db.collection("solar_data")

for entry in solar_data:
    collection.document(entry["code"]).set(entry)
    print(f"✓ {entry['state']} ({entry['code']})")

print("\n✅ Solar data seeded for all 50 states + DC!")