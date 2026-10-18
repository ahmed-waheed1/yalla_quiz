import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/theme/yq_typography.dart';
import '../../../../core/widgets/yq_app_bar.dart';
import '../../../../core/widgets/yq_avatar.dart';
import '../../../../core/widgets/yq_card.dart';
import '../../../../core/widgets/yq_scaffold.dart';
import '../../../../core/widgets/yq_segmented.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../domain/entities/app_settings.dart';
import '../cubit/settings_cubit.dart';

/// 12 Settings.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const double _cardIcon = 22;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final settings = context.watch<SettingsCubit>().state;
    final cubit = context.read<SettingsCubit>();
    final profile = context.watch<ProfileCubit>().state;

    Widget cardHeader(IconData icon, String label) => Row(
          children: [
            Icon(icon, size: _cardIcon, color: c.ink),
            const SizedBox(width: YqSpace.x2 + 2),
            Expanded(child: Text(label, style: t.titleSm.copyWith(fontSize: 16))),
          ],
        );

    return YqScaffold(
      appBar: YqAppBar.back(context, title: 'settings.title'.tr()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: YqSpace.x5),
          YqCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                cardHeader(Icons.language_rounded, 'settings.language'.tr()),
                const SizedBox(height: YqSpace.x3),
                YqSegmented<String>(
                  semanticLabel: 'settings.language'.tr(),
                  value: context.locale.languageCode,
                  segments: [
                    YqSegment('en', 'languages.en'.tr()),
                    YqSegment('ar', 'languages.ar'.tr()),
                  ],
                  onChanged: (code) => context.setLocale(Locale(code)),
                ),
                const SizedBox(height: YqSpace.x2 + 2),
                Text('settings.language_hint'.tr(), style: t.caption.copyWith(color: c.inkMuted)),
              ],
            ),
          ),
          const SizedBox(height: YqSpace.x3 + 2),
          YqCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                cardHeader(Icons.dark_mode_outlined, 'settings.theme'.tr()),
                const SizedBox(height: YqSpace.x3),
                YqSegmented<AppThemeMode>(
                  semanticLabel: 'settings.theme'.tr(),
                  value: settings.themeMode,
                  segments: [
                    YqSegment(AppThemeMode.light, 'settings.light'.tr(), icon: Icons.light_mode_outlined),
                    YqSegment(AppThemeMode.dark, 'settings.dark'.tr(), icon: Icons.dark_mode_outlined),
                    YqSegment(AppThemeMode.system, 'settings.system'.tr(), icon: Icons.smartphone_rounded),
                  ],
                  onChanged: cubit.setThemeMode,
                ),
              ],
            ),
          ),
          const SizedBox(height: YqSpace.x3 + 2),
          YqCard(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x4, vertical: YqSpace.x1),
            child: Column(
              children: [
                _ToggleRow(
                  title: 'settings.sound'.tr(),
                  subtitle: 'settings.sound_hint'.tr(),
                  value: settings.sound,
                  onChanged: cubit.setSound,
                ),
                Divider(height: 1.5, thickness: 1.5, color: c.line),
                _ToggleRow(
                  title: 'settings.vibration'.tr(),
                  value: settings.vibration,
                  onChanged: cubit.setVibration,
                ),
              ],
            ),
          ),
          const SizedBox(height: YqSpace.x3 + 2),
          if (profile != null)
            Semantics(
              button: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.push(Routes.profile),
                child: YqCard(
                  child: Row(
                    children: [
                      YqAvatar(seed: profile.avatarSeed, size: 44),
                      const SizedBox(width: YqSpace.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(profile.name, style: t.titleSm.copyWith(fontSize: 16)),
                            Text(
                              'settings.edit_profile'.tr(),
                              style: t.caption.copyWith(fontSize: 12, color: c.inkMuted),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: c.inkMuted),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottom: Text(
        'settings.version'.tr(args: [kAppVersion]),
        textAlign: TextAlign.center,
        style: t.caption.copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: c.inkMuted),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    return MergeSemantics(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 58),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: t.titleSm.copyWith(fontSize: 16)),
                  if (subtitle != null)
                    Text(subtitle!, style: t.caption.copyWith(fontSize: 12, color: c.inkMuted)),
                ],
              ),
            ),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
