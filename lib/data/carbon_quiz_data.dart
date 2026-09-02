import '../models/quiz_model.dart';

final List<Question> carbonQuiz = [
  const Question(
    id: 'welcome',
    title: 'Build your household climate baseline',
    helperText:
        'Your answers help estimate your household’s annual climate footprint. '
        'The more accurately you answer, the more useful your climate plan will be.',
    type: QuestionType.singleChoice,
    headerImageAsset: 'assets/images/onboarding/carbon_welcome.png',
    options: [Option(text: 'Build Your baseline', value: 'continue')],
  ),

  const Question(
    id: 'householdSize',
    title: 'How many people are in your household?',
    helperText:
        'Include yourself and people whose shared meals, home energy, and'
        'household choices you manage.',
    type: QuestionType.singleChoice,
    headerImageAsset: 'assets/images/onboarding/carbon_household_size.png',
    options: [
      Option(text: 'Just me', value: '1'),
      Option(text: '2 people', value: '2'),
      Option(text: '3 people', value: '3'),
      Option(text: '4 people', value: '4'),
      Option(text: '5 or more people', value: '5'),
    ],
  ),

  const Question(
    id: 'usesCar',
    title: 'Does your household own or regularly use a car?',
    helperText:
        'Choose yes if anyone in your household regularly drives a personal vehicle.',
    type: QuestionType.singleChoice,
    headerImageAsset: 'assets/images/onboarding/carbon_transport.png',
    options: [
      Option(text: 'Yes', value: 'yes'),
      Option(text: 'No', value: 'no'),
    ],
  ),

  const Question(
    id: 'carMilesPerWeek',
    title: 'How much do you usually drive?',
    helperText:
        'An estimate is enough. Choose the closest description of your typical week.',
    type: QuestionType.singleChoice,
    headerImageAsset: 'assets/images/onboarding/carbon_miles.png',
    options: [
      Option(text: 'I rarely or never drive', value: '0'),
      Option(text: 'A few local trips', value: '25'),
      Option(text: 'Regular errands and commuting', value: '100'),
      Option(text: 'I commute most weekdays', value: '200'),
      Option(text: 'I drive long distances often', value: '350'),
    ],
  ),

  const Question(
    id: 'carMpg',
    title: 'What type of vehicle do you drive most often?',
    helperText: 'This helps estimate fuel use. Pick the closest match.',
    type: QuestionType.singleChoice,
    headerImageAsset: 'assets/images/onboarding/carbon_car_type.png',
    options: [
      Option(text: 'Electric vehicle or I do not drive', value: '999'),
      Option(text: 'Hybrid or very fuel-efficient car', value: '50'),
      Option(text: 'Typical compact or midsize car', value: '30'),
      Option(text: 'SUV, pickup, or larger vehicle', value: '20'),
      Option(text: 'I am not sure', value: '28'),
    ],
  ),

  const Question(
    id: 'flightsShortHaulPerYear',
    title: 'How many short flights do you take each year?',
    helperText:
        'Short flights are typically a few hours or less, including many domestic trips.',
    type: QuestionType.numberInput,
    headerImageAsset: 'assets/images/onboarding/carbon_flights.png',
    inputHint: 'Example: 2',
  ),

  const Question(
    id: 'flightsLongHaulPerYear',
    title: 'How many long flights do you take each year?',
    helperText:
        'Long flights are typically international or cross-continent trips.',
    type: QuestionType.numberInput,
    headerImageAsset: 'assets/images/onboarding/carbon_flights.png',
    inputHint: 'Example: 1',
  ),

  const Question(
    id: 'electricityMode',
    title:
        'Would you like to use your electric bill for a more precise estimate?',
    helperText: 'You can find “kWh used” on your monthly electricity bill.',
    type: QuestionType.singleChoice,
    headerImageAsset: 'assets/images/onboarding/carbon_electric_bill.png',
    options: [
      Option(text: 'Yes, I can enter my monthly kWh', value: 'exact'),
      Option(text: 'No, help me estimate it', value: 'estimate'),
    ],
  ),

  const Question(
    id: 'electricityKwhPerMonth',
    title: 'What is your monthly electricity use?',
    helperText:
        'Look for “kWh used” on your electric bill. Enter a monthly average if you have one.',
    type: QuestionType.numberInput,
    isOptional: true,
    headerImageAsset: 'assets/images/onboarding/carbon_electric_bill.png',
    inputHint: 'Example: 600',
  ),
  const Question(
    id: 'electricityEstimate',
    title: 'What best describes your home electricity use?',
    helperText:
        'Choose the closest answer if you do not have a bill available.',
    type: QuestionType.singleChoice,
    headerImageAsset: 'images/onboarding/carbon_home_energy.png',
    options: [
      Option(text: 'Low use: small home or careful energy use', value: '350'),
      Option(text: 'Typical use', value: '600'),
      Option(
        text: 'Higher use: larger home or high AC/heating use',
        value: '1000',
      ),
      Option(text: 'Very high use', value: '1500'),
    ],
  ),
  const Question(
    id: 'naturalGasThermsPerMonth',
    title: 'What is your monthly natural-gas use?',
    helperText:
        'Enter therms from your gas bill. Leave blank if you do not use natural gas or do not know.',
    type: QuestionType.numberInput,
    isOptional: true,
    headerImageAsset: 'assets/images/onboarding/carbon_natural_gas.png',
    inputHint: 'Example: 20',
  ),
  const Question(
    id: 'dietType',
    title: 'What best describes your current diet?',
    helperText:
        'This is a broad carbon-baseline estimate. Your Diet tab will collect more detail later.',
    type: QuestionType.singleChoice,
    headerImageAsset: 'images/onboarding/carbon_diet.png',
    options: [
      Option(text: 'I eat meat most days', value: 'meat_heavy'),
      Option(text: 'I eat a mix of everything', value: 'average'),
      Option(text: 'I limit meat most of the time', value: 'low_meat'),
      Option(text: 'I am vegetarian', value: 'vegetarian'),
      Option(text: 'I am vegan', value: 'vegan'),
    ],
  ),
  const Question(
    id: 'monthlyShoppingUsd',
    title: 'About how much do you spend on new non-food items each month?',
    helperText:
        'Include items such as clothing, home goods, electronics, and other purchases. Do not include food, rent, or utilities.',
    type: QuestionType.numberInput,
    isOptional: true,
    headerImageAsset: 'assets/images/onboarding/carbon_goods.png',
    inputHint: 'Example: 150',
  ),
];
