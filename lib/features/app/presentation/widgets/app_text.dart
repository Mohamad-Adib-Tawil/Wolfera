import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:text_scroll/text_scroll.dart';

class AppText extends StatelessWidget {
  const AppText(
    String this.data, {
    super.key,
    this.translation = true,
    this.scrollText = false,
    this.isAutoScale = false,
    this.textSpan,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.selectionColor,
  });

  final String? data;
  final bool translation;
  final InlineSpan? textSpan;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final Color? selectionColor;
  final bool scrollText;
  final bool isAutoScale;

  @override
  Widget build(BuildContext context) {
    if (scrollText) {
      return TextScroll(
        translation ? data!.tr() : data!,
        mode: TextScrollMode.endless,
        velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
        delayBefore: const Duration(milliseconds: 20000),
        pauseBetween: const Duration(milliseconds: 0),
        style: style,
        selectable: false,
        intervalSpaces: 5,
        textAlign: textAlign,
        textDirection: textDirection ?? TextDirection.rtl,
      );
    }
    if (isAutoScale) {
      return AutoSizeText(
        translation ? data!.tr() : data!,
        style: style,
        key: key,
        locale: locale,
        maxLines: maxLines,
        overflow: overflow,
        semanticsLabel: semanticsLabel,
        softWrap: softWrap,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        textScaleFactor: textScaleFactor,
      );
    }
    return Text(
      translation ? data!.tr() : data!,
      style: style,
      key: key,
      locale: locale,
      maxLines: maxLines,
      overflow: overflow,
      semanticsLabel: semanticsLabel,
      softWrap: softWrap,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      textScaleFactor: textScaleFactor,
    );
  }
}
