import 'dart:convert';

import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({
    required String text,
    required int number,
  }) : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json["text"],
      number: (json["number"] as num).toInt(),
    );
  }

  factory NumberTriviaModel.fromRawJson(String rawJson) {
    return NumberTriviaModel.fromJson(jsonDecode(rawJson));
  }

  Map<String, dynamic> toJson() => {"text": text, "number": number};
}
