import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/yq_spacing.dart';
import '../theme/yq_typography.dart';
import 'yq_button.dart';

/// In-body app bar: leading icon button, `titleSm` title, optional trailing.
class YqAppBar extends StatelessWidget {
  const YqAppBar({super.key, this.title, this.leading, this.trailing});

  /// Back chevron (mirrors in RTL) that pops the route.
  factory YqAppBar.back(BuildContext context, {Key? key, String? title, Widget? trailing}) =>
      YqAppBar(
        key: key,
        title: title,
        trailing: trailing,
        leading: YqIconButton(
          icon: const Icon(Icons.chevron_left_rounded, size: 30),
          tooltip: 'common.back'.tr(),
          onPressed: () => context.pop(),
        ),
      );

  final String? title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: YqSpace.iconButton,
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: YqSpace.x4)],
          if (title != null)
            Expanded(
              child: Text(
                title!,
                style: context.yqText.titleSm,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          else
            const Spacer(),
          ?trailing,
        ],
      ),
    );
  }
}
