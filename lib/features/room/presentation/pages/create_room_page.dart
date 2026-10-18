import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/theme/yq_typography.dart';
import '../../../../core/utils/failure_message.dart';
import '../../../../core/widgets/yq_app_bar.dart';
import '../../../../core/widgets/yq_button.dart';
import '../../../../core/widgets/yq_scaffold.dart';
import '../../../../core/widgets/yq_segmented.dart';
import '../../../../core/widgets/yq_spinner.dart';
import '../../../../core/widgets/yq_toast.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../cubit/create_room_cubit.dart';
import '../widgets/category_chip.dart';

/// 04 Create room.
class CreateRoomPage extends StatelessWidget {
  const CreateRoomPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => CreateRoomCubit(getIt(), getIt(), getIt<ProfileCubit>())..load(),
        child: const _CreateRoomView(),
      );
}

class _CreateRoomView extends StatelessWidget {
  const _CreateRoomView();

  static const double _sectionGap = YqSpace.x5;
  static const double _chipGap = 10;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final sectionLabel = t.label.copyWith(color: c.inkMuted);

    return BlocConsumer<CreateRoomCubit, CreateRoomState>(
      listenWhen: (a, b) => a.createdCode != b.createdCode || a.failure != b.failure,
      listener: (context, state) {
        final code = state.createdCode;
        if (code != null) {
          context.go(Routes.lobbyFor(code));
        } else if (state.failure != null) {
          YqToast.show(context, failureMessage(state.failure!));
        }
      },
      builder: (context, state) {
        final cubit = context.read<CreateRoomCubit>();
        final settings = state.settings;
        return YqScaffold(
          appBar: YqAppBar.back(context, title: 'create.title'.tr()),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: YqSpace.x6),
              Text('create.category'.tr(), style: sectionLabel),
              const SizedBox(height: YqSpace.x3),
              if (state.loadingCategories)
                const Center(child: YqSpinner())
              else
                _CategoryGrid(
                  ids: state.categories,
                  selected: state.category,
                  gap: _chipGap,
                  onSelect: cubit.selectCategory,
                ),
              const SizedBox(height: _sectionGap + YqSpace.x1),
              Text('create.question_count'.tr(), style: sectionLabel),
              const SizedBox(height: YqSpace.x3),
              YqSegmented<int>(
                semanticLabel: 'create.question_count'.tr(),
                value: state.questionCount,
                segments: [
                  for (final n in RoomRules.questionCounts) YqSegment(n, '$n', ltrLabel: true),
                ],
                onChanged: cubit.selectQuestionCount,
              ),
              const SizedBox(height: _sectionGap + YqSpace.x1),
              Text('create.time_per_question'.tr(), style: sectionLabel),
              const SizedBox(height: YqSpace.x3),
              YqSegmented<int>(
                semanticLabel: 'create.time_per_question'.tr(),
                value: state.timePerQuestion,
                segments: [
                  for (final s in RoomRules.timesPerQuestion)
                    YqSegment(s, 'create.seconds_short'.tr(args: ['$s'])),
                ],
                onChanged: cubit.selectTimePerQuestion,
              ),
            ],
          ),
          bottom: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (settings != null)
                Text(
                  [
                    'create.summary_questions'.plural(settings.questionCount),
                    'create.summary_time'.tr(args: ['${settings.timePerQuestion}']),
                    'create.summary_minutes'.plural(settings.estimatedMinutes),
                  ].join(' · '),
                  textAlign: TextAlign.center,
                  style: t.caption.copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: c.inkMuted),
                ),
              const SizedBox(height: YqSpace.x3),
              YqButton(
                label: 'create.go'.tr(),
                loading: state.creating,
                onPressed: state.canCreate ? cubit.create : null,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({
    required this.ids,
    required this.selected,
    required this.gap,
    required this.onSelect,
  });

  final List<String> ids;
  final String? selected;
  final double gap;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    Widget chip(String id) => CategoryChip(
          id: id,
          label: 'categories.$id'.tr(),
          selected: id == selected,
          onTap: () => onSelect(id),
        );
    return Column(
      children: [
        for (var i = 0; i < ids.length; i += 2) ...[
          if (i > 0) SizedBox(height: gap),
          Row(
            children: [
              Expanded(child: chip(ids[i])),
              SizedBox(width: gap),
              Expanded(child: i + 1 < ids.length ? chip(ids[i + 1]) : const SizedBox.shrink()),
            ],
          ),
        ],
      ],
    );
  }
}
