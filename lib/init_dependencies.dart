import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yemengram/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:yemengram/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:yemengram/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:yemengram/features/auth/domain/repositories/auth_repository.dart';
import 'package:yemengram/features/auth/domain/usecases/get_current_user.dart';
import 'package:yemengram/features/auth/domain/usecases/user_sign_in.dart';
import 'package:yemengram/features/auth/domain/usecases/user_sign_up.dart';
import 'package:yemengram/features/auth/domain/usecases/user_sign_out.dart';
import 'package:yemengram/features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // 1. Load localized environment configuration variables
  await dotenv.load(fileName: ".env");

  // 2. Initialize Supabase instance using loaded configuration
  final supabase = await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    publishableKey: dotenv.get('SUPABASE_ANON_KEY'),
  );

  // 3. Register global Supabase client singleton
  serviceLocator.registerLazySingleton(() => supabase.client);

  // 4. Initialize Auth Feature dependencies
  _initAuth();
}

void _initAuth() {
  serviceLocator
    // Data Source
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()),
    )
    // Use Cases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserSignIn(serviceLocator()))
    ..registerFactory(() => GetCurrentUser(serviceLocator()))
    ..registerFactory(() => UserSignOut(serviceLocator()))
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        getCurrentUser: serviceLocator(),
        userSignOut: serviceLocator(),
      ),
    );
}