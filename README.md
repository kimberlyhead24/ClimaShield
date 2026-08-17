# ClimaShield
Mobile app for empowering individuals and businesses to achieve a climate surplus and to help with a contingency plan to live with climate change.

# clima_shield

A new Flutter project. Link to research that will update as I move along. This is everything I have researched to produce the app thus far, including legal implications and the entire SDLC: 
Feel free to commentate in the file!!!
https://docs.google.com/document/d/1Bsqx4cjmXpvdEfrPsIFvL7L0WR3IsXAoFIzQYx0KPno/edit?usp=sharing

# Personalized Low-Impact Meal Plan Optimizer

The system filters recipes using non-negotiable dietary, allergen,
time, and budget constraints. It then ranks eligible recipes using
an interpretable multi-objective score covering cost, nutritional
fit, climate impact, cuisine preferences, and weekly variety.

The architecture records recommendation outcomes and is designed
to support a future supervised personalized-ranking model.

Engineering standards:
• Design for correctness, readability, security, and appropriate time/space complexity.
• Consider Big-O complexity before implementing data processing, ranking, filtering, and aggregation.
• Prefer O(n) passes and indexed lookups; avoid nested loops when a Set or Map removes unnecessary repeated work.
• Write tests before implementation for all new business logic.
• Add unit tests for pure models, utilities, filtering, scaling, ranking, and calculations.
• Add widget/integration tests for important user flows: signup, login, quiz completion, meal-plan generation, recipe scaling, and meal logging.
• Add regression tests whenever a bug is fixed.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
