import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

enum AppThemeMode { light, dark, system }

/// Device-local preferences. Language is owned by easy_localization.
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(AppThemeMode.system) AppThemeMode themeMode,
    @Default(true) bool sound,
    @Default(true) bool vibration,
  }) = _AppSettings;
}
