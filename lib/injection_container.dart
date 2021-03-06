import 'package:connection_checker/connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/reopsitories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final locator = GetIt.instance;
Future<void> init() async {
  //! Features - Number Trivia
  locator.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: locator(),
      getRandomNumberTrivia: locator(),
      inputConverter: locator(),
    ),
  );

  // Use cases
  locator.registerLazySingleton(() => GetConcreteNumberTrivia(locator()));
  locator.registerLazySingleton(() => GetRandomNumberTrivia(locator()));

  // Repository
  locator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  // Data sources
  locator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: locator()),
  );

  locator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: locator()),
  );

  //! Core
  locator.registerLazySingleton(() => InputConverter());
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => ConnectionChecker());
}
