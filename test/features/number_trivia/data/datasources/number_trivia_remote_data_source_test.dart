import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:tdd/core/error/exceptions.dart';
import 'package:tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataScourceImpl dataScource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataScource = NumberTriviaRemoteDataScourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group(
    'getConcreteNumberTrivia',
    () {
      final tNumber = 1;
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
      test(
        'should perform a GET request on a URL with number '
        'being the endpoint and with appilcation/json header',
        () async {
          setUpMockHttpClientSuccess200();

          dataScource.getConcreteNumberTrivia(tNumber);

          verify(mockHttpClient.get(
            'http://numbersapi.com/$tNumber',
            headers: {
              'Content-Type': 'application/json',
            },
          ));
        },
      );

      test('should return NumberTrivia when response code is 200', () async {
        //arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('trivia.json'), 200));
        //act
        final result = await dataScource.getConcreteNumberTrivia(tNumber);
        //assert
        expect(result, equals(tNumberTriviaModel));
      });

      test(
          'should throw a ServerException when the response code is 404 or other',
          () async {
        setUpMockHttpClientFailure404();

        final call = dataScource.getConcreteNumberTrivia;

        expect(() => call(tNumber), throwsA(isInstanceOf<ServerException>()));
      });
    },
  );

  group(
    'getRandomNumberTrivia',
    () {
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
      test(
        'should perform a GET request on a URL with number '
        'being the endpoint and with appilcation/json header',
        () async {
          setUpMockHttpClientSuccess200();

          dataScource.getRandomNumberTrivia();

          verify(mockHttpClient.get(
            'http://numbersapi.com/random',
            headers: {
              'Content-Type': 'application/json',
            },
          ));
        },
      );

      test('should return NumberTrivia when response code is 200', () async {
        //arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('trivia.json'), 200));
        //act
        final result = await dataScource.getRandomNumberTrivia();
        //assert
        expect(result, equals(tNumberTriviaModel));
      });

      test(
          'should throw a ServerException when the response code is 404 or other',
          () async {
        setUpMockHttpClientFailure404();

        final call = dataScource.getRandomNumberTrivia;

        expect(() => call(), throwsA(isInstanceOf<ServerException>()));
      });
    },
  );
}
