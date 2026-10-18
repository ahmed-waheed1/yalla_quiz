import 'package:intl/intl.dart';

final NumberFormat _grouped = NumberFormat.decimalPattern('en');

/// "3,330": Western digits with grouping, in every locale.
String formatScore(int value) => _grouped.format(value);

/// "+850".
String formatPoints(int value) => '+${_grouped.format(value)}';
