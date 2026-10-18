import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/theme/yq_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/yq_app_bar.dart';
import '../../../../core/widgets/yq_avatar.dart';
import '../../../../core/widgets/yq_brand.dart';
import '../../../../core/widgets/yq_button.dart';
import '../../../../core/widgets/yq_scaffold.dart';
import '../../../profile/domain/entities/player_profile.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';

/// 02 Home.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const double _wordmarkHeight = 34;
  static const double _avatarSize = 52;
  static const double _heroRadius = 28;
  static const double _heroIllustrationHeight = 214;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final profile = context.watch<ProfileCubit>().state;

    return YqScaffold(
      appBar: YqAppBar(
        leading: const YqWordmark(height: _wordmarkHeight),
        trailing: YqIconButton(
          icon: const Icon(Icons.tune_rounded),
          tooltip: 'home.settings'.tr(),
          onPressed: () => context.push(Routes.settings),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: YqSpace.x3),
          if (profile != null) _Greeting(profile: profile, avatarSize: _avatarSize),
          const SizedBox(height: YqSpace.x5),
          Container(
            padding: const EdgeInsetsDirectional.all(YqSpace.x5),
            decoration: BoxDecoration(
              color: c.inverse,
              borderRadius: YqRadius.all(_heroRadius),
              boxShadow: context.yqElevation.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: _heroIllustrationHeight.shrinkH,
                  width: double.infinity,
                  child: YqHeroIllustration(height: (_heroIllustrationHeight * 0.75).shrinkH),
                ),
                const SizedBox(height: YqSpace.x4),
                Text(
                  'home.hero_title'.tr(),
                  style: t.title.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: c.onInverse,
                  ),
                ),
                const SizedBox(height: YqSpace.x1),
                Text(
                  'home.hero_body'.tr(),
                  style: t.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.onInverse.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottom: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          YqButton(
            label: 'home.create'.tr(),
            icon: const Icon(Icons.add_rounded),
            onPressed: () => context.push(Routes.createRoom),
          ),
          const SizedBox(height: YqSpace.x3 + 2),
          YqButton.secondary(
            label: 'home.join'.tr(),
            icon: const YqDirectionalIcon(Icons.login_rounded),
            onPressed: () => context.push(Routes.joinRoom),
          ),
        ],
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.profile, required this.avatarSize});

  final PlayerProfile profile;
  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    return Row(
      children: [
        YqAvatar(seed: profile.avatarSeed, size: avatarSize),
        const SizedBox(width: YqSpace.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'home.hey'.tr(namedArgs: {'name': profile.name}),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.caption.copyWith(color: c.inkMuted),
              ),
              Text('home.ready'.tr(), style: t.title),
            ],
          ),
        ),
      ],
    );
  }
}
