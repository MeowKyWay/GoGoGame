import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/extensions/text_style_extension.dart';

extension TextExtension on Text {
  Text withColor(Color color) =>
      copyWith(style: (style ?? TextStyle()).withColor(color));
  Text withFontSize(double fontSize) =>
      copyWith(style: (style ?? TextStyle()).withFontSize(fontSize));
  Text withFontWeight(FontWeight fontWeight) =>
      copyWith(style: (style ?? TextStyle()).withFontWeight(fontWeight));
  Text withFontFamily(String fontFamily) =>
      copyWith(style: (style ?? TextStyle()).withFontFamily(fontFamily));

  Text copyWith({
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) {
    return Text(
      data ?? '',
      key: key ?? this.key,
      style: style ?? this.style,
      strutStyle: strutStyle ?? this.strutStyle,
      textAlign: textAlign ?? this.textAlign,
      textDirection: textDirection ?? this.textDirection,
      locale: locale ?? this.locale,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      textScaler: textScaler ?? this.textScaler,
      maxLines: maxLines ?? this.maxLines,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
      selectionColor: selectionColor ?? this.selectionColor,
    );
  }
}
