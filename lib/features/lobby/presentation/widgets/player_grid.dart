import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/haptics.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/widgets/yq_player_tile.dart';
import '../../../room/domain/entities/room.dart';

/// Sizes for the phone grid (4 columns) and the host big screen (3+).
class PlayerGridMetrics {
  const PlayerGridMetrics({
    required this.columns,
    required this.gap,
    required this.tileHeight,
    required this.avatarSize,
    required this.nameSize,
    required this.badgeSize,
  });

  static const phone = PlayerGridMetrics(
    columns: 4,
    gap: YqSpace.x2,
    tileHeight: 92,
    avatarSize: 44,
    nameSize: 13,
    badgeSize: 22,
  );

  static const host = PlayerGridMetrics(
    columns: 3,
    gap: YqSpace.x5,
    tileHeight: 200,
    avatarSize: 96,
    nameSize: 24,
    badgeSize: 40,
  );

  PlayerGridMetrics withColumns(int value) => PlayerGridMetrics(
    columns: value,
    gap: gap,
    tileHeight: tileHeight,
    avatarSize: avatarSize,
    nameSize: nameSize,
    badgeSize: badgeSize,
  );

  final int columns;
  final double gap;
  final double tileHeight;
  final double avatarSize;
  final double nameSize;
  final double badgeSize;
}

/// Lobby players plus a ghost "Joining…" tile while the room isn't full.
/// Joiners pop in (0.6 → 1, `snap`) with a light haptic; leavers fade out.
class PlayerGrid extends StatefulWidget {
  const PlayerGrid({super.key, required this.room, required this.myUid, required this.metrics});

  final Room room;
  final String myUid;
  final PlayerGridMetrics metrics;

  @override
  State<PlayerGrid> createState() => _PlayerGridState();
}

class _Entry {
  _Entry(this.player, {this.animateIn = false});

  RoomPlayer player;
  final bool animateIn;
  bool leaving = false;
}

class _PlayerGridState extends State<PlayerGrid> {
  late List<_Entry> _entries = [for (final p in widget.room.players) _Entry(p)];
  final List<Timer> _timers = [];

  @override
  void didUpdateWidget(PlayerGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.room.players;
    final nextIds = {for (final p in next) p.uid};
    final known = {for (final e in _entries) e.player.uid: e};
    final merged = <_Entry>[];
    var joined = false;

    // Keep leavers in place (fading) and refresh everyone else's data.
    for (final e in _entries) {
      if (!nextIds.contains(e.player.uid) && !e.leaving) {
        e.leaving = true;
        final uid = e.player.uid;
        _timers.add(
          Timer(YqMotion.fast, () {
            if (mounted) {
              setState(() => _entries.removeWhere((x) => x.leaving && x.player.uid == uid));
            }
          }),
        );
      }
    }
    for (final p in next) {
      final existing = known[p.uid];
      if (existing != null && !existing.leaving) {
        existing.player = p;
      } else {
        joined = true;
      }
    }
    for (final e in _entries) {
      if (e.leaving || nextIds.contains(e.player.uid)) merged.add(e);
    }
    for (final p in next) {
      final existing = known[p.uid];
      if (existing == null || existing.leaving) {
        merged.add(_Entry(p, animateIn: true));
      }
    }
    _entries = merged;
    if (joined) getIt<Haptics>().light();
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.metrics;
    final reduced = MediaQuery.disableAnimationsOf(context);
    final tiles = <Widget>[
      for (final e in _entries)
        _AnimatedTile(
          key: ValueKey('${e.player.uid}-${e.leaving}'),
          animateIn: e.animateIn && !reduced,
          leaving: e.leaving,
          child: YqPlayerTile(
            name: e.player.name,
            nameSuffix: e.player.uid == widget.myUid ? 'lobby.you_suffix'.tr() : null,
            avatarSeed: e.player.avatarSeed,
            host: widget.room.isHost(e.player.uid),
            you: e.player.uid == widget.myUid,
            connected: e.player.connected,
            height: m.tileHeight,
            avatarSize: m.avatarSize,
            nameSize: m.nameSize,
            badgeSize: m.badgeSize,
          ),
        ),
      if (!widget.room.isFull)
        YqPlayerTile.joining(
          name: 'lobby.joining'.tr(),
          height: m.tileHeight,
          avatarSize: m.avatarSize,
          nameSize: m.nameSize,
        ),
    ];

    return Column(
      children: [
        for (var i = 0; i < tiles.length; i += m.columns) ...[
          if (i > 0) SizedBox(height: m.gap),
          Row(
            children: [
              for (var j = i; j < i + m.columns; j++) ...[
                if (j > i) SizedBox(width: m.gap),
                Expanded(child: j < tiles.length ? tiles[j] : const SizedBox.shrink()),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _AnimatedTile extends StatefulWidget {
  const _AnimatedTile({
    super.key,
    required this.animateIn,
    required this.leaving,
    required this.child,
  });

  final bool animateIn;
  final bool leaving;
  final Widget child;

  @override
  State<_AnimatedTile> createState() => _AnimatedTileState();
}

class _AnimatedTileState extends State<_AnimatedTile> with SingleTickerProviderStateMixin {
  late final AnimationController _in = AnimationController(
    vsync: this,
    duration: YqMotion.base,
    value: widget.animateIn ? 0 : 1,
  );
  late final Animation<double> _scale = Tween<double>(
    begin: 0.6,
    end: 1,
  ).animate(CurvedAnimation(parent: _in, curve: YqMotion.snap));

  @override
  void initState() {
    super.initState();
    if (widget.animateIn) _in.forward();
  }

  @override
  void dispose() {
    _in.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.leaving) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 1, end: 0),
        duration: YqMotion.fast,
        builder: (context, v, child) => Opacity(opacity: v, child: child),
        child: widget.child,
      );
    }
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}
