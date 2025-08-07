import '../models/quiz_model.dart';

final List<Question> dietQuiz = [
  Question(
    id: 'goal',
    text: "What is your main goal?",
    type: QuestionType.singleChoice,
    options: [
      Option(text: "Improve my overall health", value: "health"),
      Option(text: "Reduce my carbon footprint", value: "footprint"),
      Option(text: "Build muscle (High Protein)", value: "high_protein"),
      Option(text: "Lose weight", value: "weight_loss"),
      Option(text: "Try new foods and recipes", value: "explore"),
    ],
  ),
  Question(
    id: 'current_diet',
    text: "How would you describe your current diet?",
    type: QuestionType.singleChoice,
    options: [
      Option(text: "I eat pretty much everything", value: "omnivore"),
      Option(text: "Flexitarian (mostly vegetarian)", value: "flexitarian"),
      Option(text: "Pescatarian (no meat, but fish)", value: "pescatarian"),
      Option(text: "Vegetarian (no meat or fish)", value: "vegetarian"),
      Option(text: "Keto (low-carb, high-fat)", value: "keto"),
      Option(text: "Vegan (no animal products)", value: "vegan"),
    ],
  ),
  Question(
    id: 'red_meat_freq',
    text: "In a typical week, how often do you eat red meat (like beef or lamb)?",
    type: QuestionType.singleChoice,
    options: [
      Option(text: "5+ times a week", value: "5_plus"),
      Option(text: "3-4 times a week", value: "3_to_4"),
      Option(text: "1-2 times a week", value: "1_to_2"),
      Option(text: "Rarely", value: "rarely"),
      Option(text: "Never", value: "never"),
    ],
  ),
  Question(
    id: 'household',
    text: "Who are you cooking for?",
    type: QuestionType.singleChoice,
    options: [
      Option(text: "Just for me", value: "single"),
      Option(text: "Me and a partner", value: "couple"),
      Option(text: "A family with kids", value: "family"),
    ],
  ),
    Question(
    id: 'cooking_style',
    text: "What's your cooking style?",
    type: QuestionType.singleChoice,
    options: [
      Option(text: "Quick & Easy (under 30 mins)", value: "quick_easy"),
      Option(text: "I enjoy cooking (30-60 mins)", value: "standard"),
      Option(text: "Aspiring Chef (love complex recipes)", value: "complex"),
    ],
  ),
  Question(
    id: 'cuisines',
    text: "Which cuisines do you enjoy?",
    type: QuestionType.multipleChoice,
    options: [
      Option(text: "American", value: "american"),
      Option(text: "Mexican", value: "mexican"),
      Option(text: "Mediterranean", value: "mediterranean"),
      Option(text: "Greek", value: "greek"),
      Option(text: "Italian", value: "italian"),
      Option(text: "Indian", value: "indian"),
      Option(text: "Thai", value: "thai"),
      Option(text: "Chinese", value: "chinese"),
      Option(text: "Japanese", value: "japanese"),
    ],
  ),
  Question(
    id: 'disliked_ingredients',
    text: "Are there any ingredients you dislike? List them, separated by commas.",
    type: QuestionType.textInput,
    // No options needed for a text input question
  ),
  Question(
    id: 'allergies',
    text: "Do you have any dietary restrictions or allergies?",
    type: QuestionType.multipleChoice,
    options: [
      Option(text: "Gluten-free", value: "gluten_free"),
      Option(text: "Dairy-free", value: "dairy_free"),
      Option(text: "Nut allergy", value: "nut_allergy"),
      Option(text: "Soy-free", value: "soy_free"),
      Option(text: "Shellfish allergy", value: "shellfish_allergy"),
    ],
  ),
  Question(
    id: 'pace',
    text: "How would you like to approach your new climate-healthy diet?",
    type: QuestionType.singleChoice,
    options: [
      Option(text: "One Step at a Time (small, gradual changes)", value: "gradual"),
      Option(text: "Steady Progress (noticeable weekly changes)", value: "steady"),
      Option(text: "All In (ready for a big change now)", value: "all_in"),
    ],
  ),
];