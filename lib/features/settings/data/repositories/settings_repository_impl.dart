import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/prefs_keys.dart';
import '../../../../core/utils/failure.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  AppSettings load() {
    final mode = AppThemeMode.values.asNameMap()[_prefs.getString(PrefsKeys.themeMode)];
    return AppSettings(
      themeMode: mode ?? AppThemeMode.system,
      sound: _prefs.getBool(PrefsKeys.sound) ?? true,
      vibration: _prefs.getBool(PrefsKeys.vibration) ?? true,
    );
  }

  @override
  Future<Either<Failure, Unit>> save(AppSettings settings) async {
    try {
      await Future.wait([
        _prefs.setString(PrefsKeys.themeMode, settings.themeMode.name),
        _prefs.setBool(PrefsKeys.sound, settings.sound),
        _prefs.setBool(PrefsKeys.vibration, settings.vibration),
      ]);
      return right(unit);
    } on Object catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }
}
