import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/game/data/datasources/question_asset_data_source.dart';
import '../../features/game/data/repositories/question_repository_impl.dart';
import '../../features/game/domain/repositories/question_repository.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/room/data/datasources/room_remote_data_source.dart';
import '../../features/room/data/repositories/room_repository_impl.dart';
import '../../features/room/domain/repositories/room_repository.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../constants/app_constants.dart';
import '../services/auth_service.dart';
import '../services/clock.dart';
import '../services/haptics.dart';
import '../services/server_clock.dart';
import '../services/sound_service.dart';

final GetIt getIt = GetIt.instance;

/// Call once after `Firebase.initializeApp`.
Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  // Always use this registered instance; never `FirebaseDatabase.instance`.
  final database = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: kDatabaseUrl);
  final auth = FirebaseAuth.instance;
  if (kUseFirebaseEmulators) {
    database.useDatabaseEmulator(kEmulatorHost, 9000);
    await auth.useAuthEmulator(kEmulatorHost, 9099);
  }

  getIt
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerSingleton<FirebaseDatabase>(database)
    ..registerSingleton<FirebaseAuth>(auth)
    ..registerLazySingleton<AuthService>(() => AuthService(getIt()))
    ..registerLazySingleton<ServerClock>(() => ServerClock(getIt())..start())
    ..registerLazySingleton<Clock>(() => getIt<ServerClock>())
    ..registerLazySingleton<Scheduler>(() => const TimerScheduler())
    ..registerLazySingleton<Haptics>(Haptics.new)
    ..registerLazySingleton<SoundService>(SoundService.new)
    // Data sources
    ..registerLazySingleton<RoomRemoteDataSource>(() => RoomRemoteDataSource(getIt()))
    ..registerLazySingleton<QuestionAssetDataSource>(() => QuestionAssetDataSource(rootBundle))
    // Repositories
    ..registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(getIt()))
    ..registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(getIt()))
    ..registerLazySingleton<QuestionRepository>(() => QuestionRepositoryImpl(getIt()))
    ..registerLazySingleton<RoomRepository>(() => RoomRepositoryImpl(getIt(), getIt()))
    // App-wide cubits
    ..registerLazySingleton<ProfileCubit>(() => ProfileCubit(getIt())..load())
    ..registerLazySingleton<SettingsCubit>(() => SettingsCubit(getIt(), getIt(), getIt()));
}
