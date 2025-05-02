import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flet/flet.dart';
import 'package:flutter/material.dart';

class AnimatedTextKitControl extends StatefulWidget {
  final Control? parent;
  final Control control;
  final bool parentDisabled;
  final bool? parentAdaptive;

  const AnimatedTextKitControl({
    super.key,
    required this.parent,
    required this.control,
    required this.parentDisabled, 
    required this.parentAdaptive,
  });
  
  @override
  State<AnimatedTextKitControl> createState() => _AnimatedTextKitControlState();
}

class _AnimatedTextKitControlState extends State<AnimatedTextKitControl> with FletStoreMixin {
  @override
  Widget build(BuildContext context) {
    debugPrint("AnimatedTextKit build: ${widget.control.id}");

    List texts = widget.control.attrList("texts")!;

    List<AnimatedText> animatedTextWidgets = [];

    texts.forEach((text){
      Map<String, dynamic> textObject = json.decode(text);
      String content = textObject['text'] ?? '';
      String animationType = textObject['type'] ?? 'Typer';
      int duration = textObject['duration'] ?? '';
      int speed = textObject['speed'] ?? '';
      TextAlign textAlign = parseTextAlign(textObject['align'])!;
      Curve curve = parseCurve(textObject['Curve'])!;
      List<Color> colors = [];
      if (textObject.containsKey('colors') && textObject['colors'] is List) {
        colors = parseColorList(List<String>.from(textObject['colors']));
      }

      TextStyle? style;
      var styleNameOrData = textObject["style"];
      if (styleNameOrData != null) {
        style = getTextStyle(context, styleNameOrData);
      }

      if (style == null && styleNameOrData != null) {
        try {
          style = parseTextStyleFromJson(Theme.of(context), textObject["style"]);
        } on FormatException catch (_) {
          style = null;
        }
      }

      TextStyle? themeStyle;
      var styleName = textObject["theme_style"];
      if (styleName != null) {
        themeStyle = getTextStyle(context, styleName);
      }

      if (style == null && themeStyle != null) {
        style = themeStyle;
      } else if (style != null && themeStyle != null) {
        style = themeStyle.merge(style);
      }

      switch (animationType) {
        case "Typer":
          animatedTextWidgets.add(
            TyperAnimatedText(
              content,
              textStyle: style,
              speed: Duration(milliseconds: speed),
              curve: curve,
              textAlign: textAlign
            )
          );
        case "Rotate":
          animatedTextWidgets.add(
            RotateAnimatedText(
              content,
              textStyle: style,
              duration: Duration(milliseconds: duration),
              textAlign: textAlign
            )
          );
        case "Fade":
          animatedTextWidgets.add(
            FadeAnimatedText(
              content,
              textStyle: style,
              duration: Duration(milliseconds: duration),
              textAlign: textAlign
            )
          );
        case "Typewriter":
          animatedTextWidgets.add(
            TypewriterAnimatedText(
              content,
              textStyle: style,
              textAlign: textAlign,
              speed: Duration(milliseconds: speed),
              curve: curve,
            )
          );
        case "Scale":
          animatedTextWidgets.add(
            ScaleAnimatedText(
              content,
              textAlign: textAlign,
              textStyle: style,
              duration: Duration(milliseconds: duration),
            )
          );
        case "Colorize":
          animatedTextWidgets.add(
            ColorizeAnimatedText(
              content, 
              textStyle: style!, 
              colors: colors,
              speed: Duration(milliseconds: speed)
            )
          );
        }
    });

    AnimatedTextKit finalWidget = AnimatedTextKit(
      animatedTexts: animatedTextWidgets,
      repeatForever: true,
    );

    return constrainedControl(context, finalWidget, widget.parent, widget.control);
  }

  TextStyle? parseTextStyleFromJson(ThemeData theme, String? propName) {
    dynamic j;
    if (propName == null) {
      return null;
    }
    j = json.decode(propName);
    return textStyleFromJson(theme, j);
  }
  
  List<Color> parseColorList(List list) {
    List<Color> colorList = [];

    list.forEach((hexColor) {
      hexColor = hexColor.toUpperCase().replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }
      colorList.add(Color(int.parse(hexColor, radix: 16)));
    });

    return colorList;
  }
}