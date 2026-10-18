import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/haptics.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit(this._repository, this._haptics) : super(_repository.load()) {
    _haptics.enabled = state.vibration;
  }

  final SettingsRepository _repository;
  final Haptics _haptics;

  void setThemeMode(AppThemeMode mode) => _update(state.copyWith(themeMode: mode));

  void setSound(bool value) => _update(state.copyWith(sound: value));

  void setVibration(bool value) => _update(state.copyWith(vibration: value));

  void _update(AppSettings next) {
    _haptics.enabled = next.vibration;
    emit(next);
    _repository.save(next);
  }
}
