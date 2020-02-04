import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTrivaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test(
    'should be a subclass of NumberTriva entity',
    () async {
      expect(tNumberTrivaModel, isA<NumberTrivia>());
    },
  );
  group('fromJSon', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));
        final result = NumberTriviaModel.fromJson(jsonMap);

        expect(result, equals(tNumberTrivaModel));
      },
    );

    test(
      'should return a valid model when the JSON number is regarded as a double ',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));
        final result = NumberTriviaModel.fromJson(jsonMap);

        expect(result, tNumberTrivaModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        final result = tNumberTrivaModel.toJson();

        final exptectedMap = {
          "text": "Test Text",
          "number": 1,
        };

        expect(result, exptectedMap);
      },
    );
  });
}
