// An enum to define the type of question. This helps the UI know how to build itself.
enum QuestionType {
  singleChoice,
  multipleChoice,
  textInput,
}

// Option class remains the same for now.
// We can use the 'value' to store what this choice means for the algorithm.
class Option {
  final String text;
  final String value;

  Option({required this.text, required this.value});
}

class Question {
  final String id; // A unique identifier for each question
  final String text;
  final QuestionType type;
  final List<Option>? options; // Options are only needed for choice questions

  Question({
    required this.id,
    required this.text,
    required this.type,
    this.options,
  });
}
