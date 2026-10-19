import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/haptics.dart';
import '../../../../core/services/sound_service.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit(this._repository, this._haptics, this._sound) : super(_repository.load()) {
    _haptics.enabled = state.vibration;
    _sound
      ..enabled = state.sound
      ..voiceEnabled = state.voice;
  }

  final SettingsRepository _repository;
  final Haptics _haptics;
  final SoundService _sound;

  void setThemeMode(AppThemeMode mode) => _update(state.copyWith(themeMode: mode));

  void setSound(bool value) => _update(state.copyWith(sound: value));

  void setVoice(bool value) => _update(state.copyWith(voice: value));

  void setVibration(bool value) => _update(state.copyWith(vibration: value));

  void _update(AppSettings next) {
    _haptics.enabled = next.vibration;
    _sound
      ..enabled = next.sound
      ..voiceEnabled = next.voice;
    emit(next);
    _repository.save(next);
  }
}
