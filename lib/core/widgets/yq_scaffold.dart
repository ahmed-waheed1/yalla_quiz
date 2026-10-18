import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/yq_spacing.dart';
import 'yq_dot_grid.dart';

/// Standard screen: dot-grid ground, top inset `x14`, side gutter, primary
/// actions pinned to the bottom while the content above scrolls if text scale
/// pushes it past the screen. Phone-style screens are centred at [maxWidth]
/// on big screens.
class YqScaffold extends StatelessWidget {
  const YqScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottom,
    this.maxWidth = Breakpoints.phoneContentMaxWidth,
    this.gutter = YqSpace.gutter,
    this.bottomPadding = YqSpace.x10,
  });

  final Widget? appBar;
  final Widget body;

  /// Pinned to the bottom of the screen.
  final Widget? bottom;

  final double maxWidth;
  final double gutter;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.paddingOf(context);
    final top = math.max(YqSpace.x14, insets.top + YqSpace.x2);
    final bottomInset = math.max(bottomPadding, insets.bottom + YqSpace.x4);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: YqDotGridBackground(
        child: Align(
          alignment: AlignmentDirectional.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: top),
                if (appBar != null)
                  Padding(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: gutter),
                    child: appBar,
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      gutter,
                      0,
                      gutter,
                      bottom == null ? bottomInset : YqSpace.x6,
                    ),
                    child: body,
                  ),
                ),
                if (bottom != null)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(gutter, 0, gutter, bottomInset),
                    child: bottom,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
