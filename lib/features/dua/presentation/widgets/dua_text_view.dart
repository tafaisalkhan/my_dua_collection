import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';

class DuaTextView extends StatelessWidget {
  const DuaTextView(this.text, {super.key, this.languageCode, this.color});
  final String text;
  final String? languageCode;
  final Color? color;
  bool get _rtl =>
      languageCode == 'ar' ||
      languageCode == 'ur' ||
      RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
    child: SelectableText(
      text,
      textAlign: _rtl ? TextAlign.right : TextAlign.left,
      style: _rtl
          ? AppTypography.arabic.copyWith(color: color)
          : Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
    ),
  );
}
