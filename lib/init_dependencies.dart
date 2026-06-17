import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'core/app_user/presentation/cubit/current_user_cubit.dart';
import 'core/router/app_router.dart';
import 'core/theme/data/datasources/theme_local_data_source.dart';
import 'core/theme/data/datasources/theme_local_data_source_impl.dart';
import 'core/theme/data/repositories/theme_repository_impl.dart';
import 'core/theme/domain/repositories/theme_repository.dart';
import 'core/theme/presentation/bloc/theme_bloc.dart';
import 'features/feed/data/datasources/feed_remote_data_source.dart';
import 'features/feed/data/datasources/feed_remote_data_source_impl.dart';
import 'features/feed/data/repositories/feed_repository_impl.dart';
import 'features/feed/domain/repositories/feed_repository.dart';
import 'features/feed/domain/usecases/get_followed_users_posts.dart';
import 'features/feed/presentation/bloc/feed_bloc.dart';
import 'features/profile/data/datasources/profile_remote_data_source.dart';
import 'features/profile/data/datasources/profile_remote_data_source_impl.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/fetch_user_profile.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize local key-value storage engine synchronously
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);

  // Load localized environment configuration variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase instance using loaded configuration
  final supabase = await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    publishableKey: dotenv.get('SUPABASE_ANON_KEY'),
  );

  // Register global Supabase client singleton
  serviceLocator.registerLazySingleton(() => supabase.client);

  // Initialize Global Core User Session tracking state machine
  serviceLocator.registerLazySingleton(() => CurrentUserCubit());

  // Initialize Core Theme engine dependencies
  _initTheme();

  // Initialize Auth Feature dependencies
  _initAuth();

  _initProfile();

  _initFeed();

  // Register Global Core Router Singleton
  serviceLocator.registerSingleton<AppRouter>(
    AppRouter(authBloc: serviceLocator<AuthBloc>()),
  );
}

void _initTheme() {
  serviceLocator
    // Data Source
    ..registerFactory<ThemeLocalDataSource>(
      () => ThemeLocalDataSourceImpl(sharedPreferences: serviceLocator()),
    )
    // Repository
    ..registerFactory<ThemeRepository>(
      () => ThemeRepositoryImpl(localDataSource: serviceLocator()),
    )
    // Bloc (Registered as Singleton to protect the core visual stream state)
    ..registerSingleton<ThemeBloc>(
      ThemeBloc(themeRepository: serviceLocator()),
    );
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
        currentUserCubit: serviceLocator(),
      ),
    );
}

void _initProfile() {
  serviceLocator
    // Data Source
    ..registerFactory<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
    )
    // Repository
    ..registerFactory<ProfileRepository>(
      () => ProfileRepositoryImpl(serviceLocator()),
    )
    // Use Cases
    ..registerFactory(() => FetchUserProfile(serviceLocator()))
    // Bloc
    ..registerFactory(
      () => ProfileBloc(
        fetchUserProfile: serviceLocator(),
        currentUserCubit: serviceLocator(),
      ),
    );
}

void _initFeed() {
  serviceLocator
    // 1. Data Source: Injects the global SupabaseClient
    ..registerFactory<FeedRemoteDataSource>(
      () => FeedRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
    )
    // 2. Repository: Injects the FeedRemoteDataSource we just registered above
    ..registerFactory<FeedRepository>(
      () => FeedRepositoryImpl(serviceLocator<FeedRemoteDataSource>()),
    )
    // 3. Use Case: Injects the FeedRepository contract
    ..registerFactory(
      () => GetFollowedUsersPosts(serviceLocator<FeedRepository>()),
    )
    // 4. Bloc: Multi-instance factory binding the required use case and the global session cubit
    ..registerFactory(
      () => FeedBloc(
        getFollowedUsersPosts: serviceLocator(),
        currentUserCubit: serviceLocator(),
      ),
    );
}
