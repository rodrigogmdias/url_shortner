import 'package:flutter/material.dart';

enum DesignTextType { h1, h2, h3, body, caption }

class DesignText extends StatelessWidget {
  const DesignText(
    this.text, {
    super.key,
    this.type = DesignTextType.h3,
    this.overflow = TextOverflow.visible,
    this.maxLines,
    this.textAlign,
    this.style,
  });

  final String text;
  final DesignTextType type;
  final TextOverflow overflow;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final baseStyle = _styleFor(context, type);
    final effectiveStyle = style == null ? baseStyle : baseStyle.merge(style);

    return Text(
      text,
      style: effectiveStyle,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }

  TextStyle _styleFor(BuildContext context, DesignTextType type) {
    final Color? baseColor = DefaultTextStyle.of(context).style.color;

    switch (type) {
      case DesignTextType.h1:
        return TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: baseColor,
        );
      case DesignTextType.h2:
        return TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: baseColor,
        );
      case DesignTextType.h3:
        return TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: baseColor,
        );
      case DesignTextType.body:
        return TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: baseColor,
        );
      case DesignTextType.caption:
        return TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: baseColor,
        );
    }
  }
}
