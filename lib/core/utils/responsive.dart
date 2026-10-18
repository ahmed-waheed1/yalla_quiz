import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_constants.dart';

enum ScreenSize { phone, tablet, desktop }

ScreenSize screenSizeFor(double width) {
  if (width < Breakpoints.tablet) return ScreenSize.phone;
  if (width < Breakpoints.desktop) return ScreenSize.tablet;
  return ScreenSize.desktop;
}

extension ResponsiveNum on num {
  /// Design size scaled down on short phones (via flutter_screenutil), never
  /// scaled up, so tokens keep their spec values on regular and large screens.
  double get shrinkH => math.min(toDouble(), h);
}
