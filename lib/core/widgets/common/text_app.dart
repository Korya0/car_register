import 'package:flutter/material.dart';

enum TextAppType { bodyLarge, bodyMedium, bodySmall }

class TextApp extends StatelessWidget {
  const TextApp({
    required this.text,
    this.type = TextAppType.bodyMedium,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.letterSpacing,
    this.height,
    this.maxLines,
    this.softWrap,
    this.textOverflow,
    this.textAlign,
    this.style,
    super.key,
  });

  final String text;
  final TextAppType type;
  final TextStyle? style;

  // Optional overrides
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final double? height;

  final int? maxLines;
  final bool? softWrap;
  final TextOverflow? textOverflow;
  final TextAlign? textAlign;

  TextStyle _getStyle(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    TextStyle baseStyle;

    switch (type) {
      case TextAppType.bodyLarge:
        baseStyle = theme.bodyLarge!;
        break;
      case TextAppType.bodyMedium:
        baseStyle = theme.bodyMedium!;
        break;
      case TextAppType.bodySmall:
        baseStyle = theme.bodySmall!;
        break;
    }

    // Apply overrides with copyWith
    return baseStyle.copyWith(
      color: color ?? baseStyle.color,
      fontSize: fontSize ?? baseStyle.fontSize,
      fontWeight: fontWeight ?? baseStyle.fontWeight,
      letterSpacing: letterSpacing ?? baseStyle.letterSpacing,
      height: height ?? baseStyle.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? _getStyle(context),
      softWrap: softWrap,
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}
