import 'package:flutter/material.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:readmore/readmore.dart';

class ReadMoreTextView extends StatelessWidget {
  const ReadMoreTextView({
    Key? key,
    required this.text,
    this.trimLines = 4,
    this.trimMode = TrimMode.Line,
    this.colorClickableText,
    this.moreTextStyle,
    this.lessTextStyle,
    this.style,
  }) : super(key: key);

  final String text;
  final int trimLines;
  final Color? colorClickableText;
  final TrimMode trimMode;
  final TextStyle? moreTextStyle;
  final TextStyle? lessTextStyle;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: ReadMoreText(
        text,
        trimLines: trimLines,
        colorClickableText: colorClickableText ?? context.colorScheme.primary,
        trimMode: trimMode,
        trimCollapsedText: "أكمل القراءة",
        trimExpandedText: 'إظهار أقل ',
        lessStyle: lessTextStyle ?? moreTextStyle,
        moreStyle: moreTextStyle,
        style: style,
      ),
    );
  }
}
