/// Defines the interaction control used to collect an onboarding answer.
enum QuestionType { singleChoice, multipleChoice, textInput, numberInput }

/// One selectable answer shown for a single-choice or multiple-choice question.
class Option {
  final String text; // Text shown to the user.

  /// Stable value stored in the diet profile or quiz-answer map.
  /// E.g. visible text Beef or lamb 3 to 4 times per week
  /// while the stored value is "3_to_4".
  final String value;

  final String?
  description; // Optional supporting detail shown below the main option text.

  const Option({required this.text, required this.value, this.description});
}

/// A single data-driven onboarding question.
class Question {
  final String
  id; // Stable answer key, such as 'householdSize' or 'preferredCuisines'.
  final String title; // Main prompt displayed on the question screen.
  final String?
  helperText; // Optional explanation that helps the user answer accurately.
  final QuestionType type; // Determines which input control the quiz renders.
  final List<Option>
  options; // Choice options. Text and number questions use an empty list.
  final bool isOptional; // True when the user may continue without answering.
  final String?
  inputHint; // Optional placeholder for text and numberic input fields.
  final String?
  headerImageAsset; // Optional local asset used as a visual banner for this question.

  const Question({
    required this.id,
    required this.title,
    required this.type,
    this.helperText,
    this.options = const [],
    this.isOptional = false,
    this.inputHint,
    this.headerImageAsset,
  });
}
