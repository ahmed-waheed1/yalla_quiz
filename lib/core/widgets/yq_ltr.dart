import 'package:flutter/widgets.dart';

/// Numbers, scores and room codes are always laid out LTR, in both locales.
class YqLtr extends StatelessWidget {
  const YqLtr({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      Directionality(textDirection: TextDirection.ltr, child: child);
}

/// A number rendered LTR with the given (tabular) style.
class YqNumberText extends StatelessWidget {
  const YqNumberText(this.text, {super.key, required this.style, this.textAlign});

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) => YqLtr(
        child: Text(text, style: style, textAlign: textAlign, maxLines: 1),
      );
}
