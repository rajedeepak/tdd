import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataScource{
/// Gets the cached [NumberTriviaModel] which was gotten the last time
///  the user had an internet connection.
/// 
/// Throws [CacheException] if no cache data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}