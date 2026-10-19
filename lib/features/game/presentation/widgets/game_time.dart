import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/game_cubit.dart';

/// Reads the server clock every frame and rebuilds only when [select]
/// returns something new. Timers are always derived from server timestamps;
/// this only decides when to repaint. [onChange] runs side effects (haptics,
/// sounds) when the value changes.
class GameTimeSelector<T> extends StatefulWidget {
  const GameTimeSelector({
    super.key,
    required this.select,
    required this.builder,
    this.onStart,
    this.onChange,
  });

  final T Function(int nowMs) select;
  final Widget Function(BuildContext context, T value) builder;

  /// Runs once with the first value (e.g. the countdown digit on screen when
  /// it appears).
  final void Function(T value)? onStart;
  final void Function(T previous, T next)? onChange;

  @override
  State<GameTimeSelector<T>> createState() => _GameTimeSelectorState<T>();
}

class _GameTimeSelectorState<T> extends State<GameTimeSelector<T>>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_tick);
  late T _value;

  int _now() => context.read<GameCubit>().serverNow();

  @override
  void initState() {
    super.initState();
    _value = widget.select(_now());
    widget.onStart?.call(_value);
    _ticker.start();
  }

  @override
  void didUpdateWidget(GameTimeSelector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A rebuild can land on the frame where the value changes; still report it.
    _update(rebuild: false);
  }

  void _tick(Duration _) => _update(rebuild: true);

  void _update({required bool rebuild}) {
    final next = widget.select(_now());
    if (next == _value) return;
    final previous = _value;
    if (rebuild) {
      setState(() => _value = next);
    } else {
      _value = next;
    }
    widget.onChange?.call(previous, next);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _value);
}
