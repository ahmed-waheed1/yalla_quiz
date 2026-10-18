import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/services/haptics.dart';
import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/theme/yq_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/yq_app_bar.dart';
import '../../../../core/widgets/yq_avatar.dart';
import '../../../../core/widgets/yq_button.dart';
import '../../../../core/widgets/yq_ltr.dart';
import '../../../../core/widgets/yq_scaffold.dart';
import '../../../../core/widgets/yq_toast.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_setup_cubit.dart';

/// 03 Profile setup. First launch (with [next]) or edit from Settings.
class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({super.key, this.next});

  /// Where to go after saving; when null the page pops.
  final String? next;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => ProfileSetupCubit(getIt<ProfileCubit>()),
    child: _ProfileSetupView(next: next),
  );
}

class _ProfileSetupView extends StatefulWidget {
  const _ProfileSetupView({required this.next});

  final String? next;

  @override
  State<_ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<_ProfileSetupView> {
  late final TextEditingController _name = TextEditingController(
    text: context.read<ProfileSetupCubit>().state.name,
  );

  static const double _previewSize = 132;
  static const double _fieldHeight = 60;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final cubit = context.read<ProfileSetupCubit>();
    final ok = await cubit.submit();
    if (!mounted) return;
    if (!ok) {
      YqToast.show(context, 'common.error_generic'.tr());
      return;
    }
    final next = widget.next;
    if (next != null) {
      context.go(next);
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final state = context.watch<ProfileSetupCubit>().state;
    final cubit = context.read<ProfileSetupCubit>();
    final previewSize = _previewSize.shrinkH;

    return YqScaffold(
      appBar: context.canPop()
          ? YqAppBar.back(context, title: 'profile.title'.tr())
          : YqAppBar(title: 'profile.title'.tr()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: YqSpace.x4),
          Center(
            child: SizedBox(
              width: previewSize + YqSpace.x6,
              height: previewSize + YqSpace.x2,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: AlignmentDirectional.topCenter,
                children: [
                  _AvatarPreview(seed: state.avatarSeed, size: previewSize),
                  PositionedDirectional(
                    end: -10 + YqSpace.x3,
                    bottom: -4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: YqRadius.all(YqRadius.md + 4),
                        border: Border.all(color: c.bg, width: 4),
                      ),
                      child: YqIconButton(
                        icon: const Icon(Icons.shuffle_rounded),
                        tooltip: 'profile.shuffle'.tr(),
                        inverse: true,
                        onPressed: () {
                          getIt<Haptics>().selection();
                          cubit.shuffle();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: YqSpace.x4),
          Text('profile.name_label'.tr(), style: t.titleSm),
          const SizedBox(height: YqSpace.x3),
          SizedBox(
            height: _fieldHeight,
            child: TextField(
              controller: _name,
              autofocus: state.name.isEmpty,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [LengthLimitingTextInputFormatter(RoomRules.nameMaxLength)],
              style: t.titleSm.copyWith(fontSize: 20, color: c.ink),
              cursorColor: c.focus,
              decoration: InputDecoration(
                hintText: 'profile.name_placeholder'.tr(),
                hintStyle: t.titleSm.copyWith(fontSize: 20, color: c.inkMuted),
                enabledBorder: OutlineInputBorder(
                  borderRadius: YqRadius.all(YqRadius.lg),
                  borderSide: BorderSide(color: c.line, width: 2),
                ),
              ),
              onChanged: cubit.nameChanged,
              onSubmitted: (_) => state.canSubmit ? _submit() : null,
            ),
          ),
          const SizedBox(height: YqSpace.x2 + 2),
          Row(
            children: [
              Expanded(
                child: Text('profile.name_hint'.tr(), style: t.caption.copyWith(color: c.inkMuted)),
              ),
              YqNumberText(
                '${state.name.characters.length}/${RoomRules.nameMaxLength}',
                style: t.numeric.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: c.inkMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: YqSpace.x6 + 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(child: Text('profile.pick_title'.tr(), style: t.titleSm)),
              Text('profile.pick_hint'.tr(), style: t.caption.copyWith(color: c.inkMuted)),
            ],
          ),
          const SizedBox(height: YqSpace.x4),
          _AvatarGrid(
            selected: state.avatarSeed,
            onPick: (seed) {
              getIt<Haptics>().selection();
              cubit.avatarPicked(seed);
            },
          ),
        ],
      ),
      bottom: YqButton(
        label: 'profile.go'.tr(),
        icon: const Icon(Icons.arrow_forward_rounded),
        iconAfterLabel: true,
        loading: state.saving,
        onPressed: state.canSubmit ? _submit : null,
      ),
    );
  }
}

class _AvatarPreview extends StatelessWidget {
  const _AvatarPreview({required this.seed, required this.size});

  final int seed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    return AnimatedSwitcher(
      duration: reduced ? YqMotion.reducedFade : YqMotion.base,
      switchInCurve: YqMotion.snap,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: reduced
            ? child
            : ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1).animate(animation),
                child: child,
              ),
      ),
      child: YqAvatar(key: ValueKey(seed), seed: seed, size: size),
    );
  }
}

class _AvatarGrid extends StatelessWidget {
  const _AvatarGrid({required this.selected, required this.onPick});

  final int selected;
  final ValueChanged<int> onPick;

  static const int _columns = 4;
  static const double _cell = 68;
  static const double _avatar = 60;
  static const double _badge = 24;
  static const double _badgeRing = 3;
  static const double _badgeIcon = 14;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final rows = (RoomRules.avatarCount / _columns).ceil();
    return Column(
      children: [
        for (var r = 0; r < rows; r++) ...[
          if (r > 0) const SizedBox(height: YqSpace.x3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = r * _columns; i < (r + 1) * _columns && i < RoomRules.avatarCount; i++)
                _cellFor(context, i, c),
            ],
          ),
        ],
      ],
    );
  }

  Widget _cellFor(BuildContext context, int seed, YqColors c) {
    final isSelected = seed == selected;
    final reduced = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      selected: isSelected,
      button: true,
      label: 'profile.avatar'.tr(args: ['${seed + 1}']),
      child: GestureDetector(
        onTap: () => onPick(seed),
        child: SizedBox.square(
          dimension: _cell,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              AnimatedScale(
                scale: isSelected || reduced ? 1 : 0.85,
                duration: YqMotion.fast,
                curve: YqMotion.snap,
                child: AnimatedOpacity(
                  opacity: isSelected ? 1 : 0,
                  duration: YqMotion.fast,
                  child: Container(
                    width: _avatar,
                    height: _avatar,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: c.primary, spreadRadius: 6),
                        BoxShadow(color: c.bg, spreadRadius: 3),
                      ],
                    ),
                  ),
                ),
              ),
              YqAvatar(seed: seed, size: _avatar),
              if (isSelected)
                PositionedDirectional(
                  top: -2 - _badgeRing,
                  end: -2 - _badgeRing,
                  child: Container(
                    width: _badge + _badgeRing * 2,
                    height: _badge + _badgeRing * 2,
                    decoration: BoxDecoration(
                      color: c.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: c.bg, width: _badgeRing),
                    ),
                    child: Icon(Icons.check_rounded, size: _badgeIcon, color: c.onPrimary),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
