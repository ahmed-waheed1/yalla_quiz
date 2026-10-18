import 'package:wakelock_plus/wakelock_plus.dart';

import '../utils/log.dart';

/// Keeps the display on (wakelock_plus). Failures are logged, never thrown:
/// a screen that dims is an annoyance, not an error.
class ScreenAwake {
  Future<void> set(bool on) async {
    try {
      await WakelockPlus.toggle(enable: on);
    } on Object catch (e) {
      log.w('Wakelock ${on ? 'enable' : 'release'} failed', error: e);
    }
  }
}
