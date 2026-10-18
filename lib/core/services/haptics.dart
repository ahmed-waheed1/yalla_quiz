import 'package:flutter/services.dart';

/// Haptic feedback that respects the Vibration setting.
class Haptics {
  bool enabled = true;

  void selection() {
    if (enabled) HapticFeedback.selectionClick();
  }

  void light() {
    if (enabled) HapticFeedback.lightImpact();
  }

  void medium() {
    if (enabled) HapticFeedback.mediumImpact();
  }

  void heavy() {
    if (enabled) HapticFeedback.heavyImpact();
  }
}
