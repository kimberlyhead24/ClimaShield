import '../models/quiz_model.dart';

/// Reusable answer choices for weekly food-group servings.
///
/// Stored values are numeric strings so the completed quiz
/// can later convert them directly to double values for DietProfile.
const List<Option> _weeklyServingOptions = [
  Option(text: 'Never', value: '0'),
  Option(text: 'About once per week', value: '1'),
  Option(text: '2-3 times per week', value: '2.5'),
  Option(text: '4-5 times per week', value: '4.5'),
  Option(text: '6 or more times per week', value: '6'),
];

/// Questions used to build a user's DietProfile.
///
/// The diet quiz screen will later render these one at a time.
final List<Question> dietQuiz = [
  Question(
    id: 'primaryGoal',
    title: 'What is your main goal?',
    helperText:
        'We will use this to balance climate impact with your personal priorities.',
    type: QuestionType.singleChoice,
    options: [
      Option(text: 'Reduce my carbon footprint', value: 'footprint'),
      Option(text: 'Improve my overall health', value: 'health'),
      Option(text: 'Spend less on food', value: 'budget'),
      Option(text: 'Build muscle or increase protein', value: 'high_protein'),
      Option(text: 'Try new foods and recipes', value: 'explore'),
    ],
  ),
  Question(
    id: 'householdSize',
    title: 'How many people usually eat the meals you prepare?',
    helperText: 'Include yourself and anyone you regularly cook for.',
    type: QuestionType.numberInput,
    inputHint: 'Example: 2',
  ),
  Question(
    id: 'mealsPreparedAtHomePerWeek',
    title: 'How many meals do you usually prepare at home each week?',
    helperText:
        'An estimate is fine. Include meals you cook, assemble, or reheat at home.',
    type: QuestionType.numberInput,
    inputHint: 'Example: 10',
  ),
  Question(
    id: 'totalMealsEatenPerWeek',
    title: 'About how many meals do you eat in a typical week?',
    helperText: 'Three meals each day would be about 21 meals per week.',
    type: QuestionType.numberInput,
    inputHint: 'Example: 21',
  ),
  Question(
    id: 'currentDietPattern',
    title: 'What best describes your current diet?',
    helperText:
        'This helps us filter recipes that fit your current eating pattern.',
    type: QuestionType.singleChoice,
    options: [
      Option(text: 'I eat a mix of everything', value: 'omnivore'),
      Option(text: 'Flexitarian or mostly vegetarian', value: 'flexitarian'),
      Option(text: 'Pescatarian', value: 'pescatarian'),
      Option(text: 'Vegetarian', value: 'vegetarian'),
      Option(text: 'Vegan', value: 'vegan'),
    ],
  ),
  Question(
    id: 'beefOrLambServingsPerWeek',
    title: 'How often do you eat beef or lamb?',
    helperText:
        'Include burgers, steak, roast, tacos, lamb, and similar meals.',
    type: QuestionType.singleChoice,
    options: _weeklyServingOptions,
  ),
  Question(
    id: 'porkServingsPerWeek',
    title: 'How often do you eat pork?',
    helperText: 'Include bacon, sausage, ham, pork chops, and pulled pork.',
    type: QuestionType.singleChoice,
    options: _weeklyServingOptions,
  ),
  Question(
    id: 'poultryServingsPerWeek',
    title: 'How often do you eat poultry?',
    helperText:
        'Include chicken, turkey, and meals where poultry is the main protein.',
    type: QuestionType.singleChoice,
    options: _weeklyServingOptions,
  ),
  Question(
    id: 'fishOrSeafoodServingsPerWeek',
    title: 'How often do you eat fish or seafood?',
    helperText: 'Include fish, shrimp, shellfish, and other seafood meals.',
    type: QuestionType.singleChoice,
    options: _weeklyServingOptions,
  ),
  Question(
    id: 'eggServingsPerWeek',
    title: 'How often do you eat eggs as a main part of a meal?',
    helperText:
        'Examples include eggs for breakfast, omelets, quiche, or egg bowls.',
    type: QuestionType.singleChoice,
    options: _weeklyServingOptions,
  ),
  Question(
    id: 'dairyServingsPerWeek',
    title: 'How often do you eat dairy-heavy meals?',
    helperText:
        'Examples include cheese-based meals, yogurt bowls, pizza, or creamy dishes.',
    type: QuestionType.singleChoice,
    options: _weeklyServingOptions,
  ),
  Question(
    id: 'plantProteinServingsPerWeek',
    title: 'How often do you eat plant-protein meals?',
    helperText:
        'Examples include beans, lentils, tofu, tempeh, and plant-based meat alternatives.',
    type: QuestionType.singleChoice,
    options: _weeklyServingOptions,
  ),
  Question(
    id: 'preferredCuisines',
    title: 'Which cuisines do you enjoy?',
    helperText:
        'Select all that you would like to see in your meal suggestions.',
    type: QuestionType.multipleChoice,
    options: [
      Option(text: 'American', value: 'american'),
      Option(text: 'Mexican', value: 'mexican'),
      Option(text: 'Mediterranean', value: 'mediterranean'),
      Option(text: 'Greek', value: 'greek'),
      Option(text: 'Italian', value: 'italian'),
      Option(text: 'Indian', value: 'indian'),
      Option(text: 'Thai', value: 'thai'),
      Option(text: 'Chinese', value: 'chinese'),
      Option(text: 'Japanese', value: 'japanese'),
    ],
  ),
  Question(
    id: 'avoidedCuisines',
    title: 'Are there cuisines you would rather avoid?',
    helperText: 'This is optional. Select all that apply.',
    type: QuestionType.multipleChoice,
    isOptional: true,
    options: [
      Option(text: 'American', value: 'american'),
      Option(text: 'Mexican', value: 'mexican'),
      Option(text: 'Mediterranean', value: 'mediterranean'),
      Option(text: 'Greek', value: 'greek'),
      Option(text: 'Italian', value: 'italian'),
      Option(text: 'Indian', value: 'indian'),
      Option(text: 'Thai', value: 'thai'),
      Option(text: 'Chinese', value: 'chinese'),
      Option(text: 'Japanese', value: 'japanese'),
    ],
  ),
  Question(
    id: 'dislikedIngredients',
    title: 'Are there ingredients you dislike?',
    helperText:
        'This is optional. Separate ingredients with commas, such as mushrooms, olives, or cilantro.',
    type: QuestionType.textInput,
    isOptional: true,
    inputHint: 'Example: mushrooms, olives',
  ),
  Question(
    id: 'dietaryRestrictions',
    title: 'Do you follow any dietary restrictions?',
    helperText: 'Select all that apply.',
    type: QuestionType.multipleChoice,
    isOptional: true,
    options: [
      Option(text: 'Gluten-free', value: 'gluten_free'),
      Option(text: 'Dairy-free', value: 'dairy_free'),
      Option(text: 'Soy-free', value: 'soy_free'),
      Option(text: 'Low sodium', value: 'low_sodium'),
      Option(text: 'Low carbohydrate', value: 'low_carb'),
    ],
  ),
  Question(
    id: 'allergens',
    title: 'Do you have food allergies?',
    helperText:
        'Select all that apply. These will be treated as strict safety filters.',
    type: QuestionType.multipleChoice,
    isOptional: true,
    options: [
      Option(text: 'Peanut allergy', value: 'peanut_allergy'),
      Option(text: 'Tree-nut allergy', value: 'tree_nut_allergy'),
      Option(text: 'Shellfish allergy', value: 'shellfish_allergy'),
      Option(text: 'Fish allergy', value: 'fish_allergy'),
      Option(text: 'Egg allergy', value: 'egg_allergy'),
      Option(text: 'Milk allergy', value: 'milk_allergy'),
    ],
  ),
  Question(
    id: 'maxCookingTimeMinutes',
    title: 'What is the longest you would like a suggested recipe to take',
    helperText:
        'We will use this as a recipe suggestion limit. It does not describe every meal you cook, and you can change it later.',
    type: QuestionType.singleChoice,
    options: [
      Option(text: '15 minutes or less', value: '15'),
      Option(text: 'About 30 minutes', value: '30'),
      Option(text: 'About 45 minutes', value: '45'),
      Option(text: 'Up to an hour', value: '60'),
      Option(text: 'I enjoy longer cooking projects', value: '90'),
    ],
  ),
  Question(
    id: 'weeklyFoodBudgetUsd',
    title: 'What is your approximate weekly food budget?',
    helperText:
        'This is optional and used only to make recipe suggestions more practical.',
    type: QuestionType.numberInput,
    isOptional: true,
    inputHint: 'Example: 120',
  ),
  Question(
    id: 'transitionPace',
    title: 'How would you like to approach a climate-friendly diet?',
    helperText: 'You can change this preference later.',
    type: QuestionType.singleChoice,
    options: [
      Option(
        text: 'One step at a time',
        value: 'gradual',
        description: 'Small changes that feel easy to sustain.',
      ),
      Option(
        text: 'Steady progress',
        value: 'steady',
        description: 'Noticeable weekly changes toward lower-impact meals.',
      ),
      Option(
        text: 'All in',
        value: 'allIn',
        description: 'I am ready for major climate-diet changes now.',
      ),
    ],
  ),
];
