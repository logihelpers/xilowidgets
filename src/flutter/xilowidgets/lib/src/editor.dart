import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:flutter_highlight/themes/agate.dart';
import 'package:flutter_highlight/themes/androidstudio.dart';
import 'package:flutter_highlight/themes/arta.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/default.dart';
import 'package:flutter_highlight/themes/dark.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/obsidian.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:flutter_highlight/themes/xcode.dart';
import 'package:flutter_highlight/themes/idea.dart';
import 'package:flutter_highlight/themes/solarized-light.dart';
import 'package:flutter_highlight/themes/solarized-dark.dart';

import 'package:xilowidgets/src/create_control.dart';

class EditorControl extends StatefulWidget {
  final Control? parent;
  final Control control;
  final List<Control> children;
  final bool parentDisabled;
  final bool? parentAdaptive;
  final FletControlBackend backend;

  const EditorControl({
    super.key,
    required this.parent,
    required this.control,
    required this.children,
    required this.parentDisabled,
    required this.parentAdaptive,
    required this.backend,
  });

  @override
  State<EditorControl> createState() => _EditorControlState();
}

class _EditorControlState extends State<EditorControl> with FletStoreMixin {
  late final CodeController controller;

  @override
  void initState() {
    super.initState();
    controller = CodeController(
      language: pseudocode,
      text: widget.control.attrString("value", ""), // Initial text from control
    );

    // Add listener for text changes
    controller.addListener(() {
      debugPrint("CodeEditor text changed: ${controller.text}");
      widget.backend.triggerControlEvent(
        widget.control.id,
        "change",
        controller.text,
      );
    });
  }

  @override
  void didUpdateWidget(covariant EditorControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller text if control value changes (from backend)
    if (widget.control.attrString("value") != oldWidget.control.attrString("value")) {
      final newValue = widget.control.attrString("value", "")!;
      if (controller.text != newValue) { // Prevent unnecessary updates
        controller.text = newValue;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Editor build ($hashCode): ${widget.control.id}");

    return withPageArgs((context, pageArgs) {
      var theme = parseEditorTheme(widget.control.attrString("editorTheme", "default")!.toLowerCase());
      var showLineNumbers = widget.control.attrBool("showLineNumbers", true)!;
      var shouldWrap = widget.control.attrBool("wrap", false)!;
      var fontSize = widget.control.attrDouble("fontSize", 12.0)!;
      var fontFamily = widget.control.attrString("fontFamily", "monospace")!;
      var gutterWidth = widget.control.attrDouble("gutterWidth", 80.0)!;

      var editor = Expanded(
        child: CodeTheme(
          data: CodeThemeData(styles: theme),
          child: CodeField(
            padding: EdgeInsets.only(top: 3),
            controller: controller,
            wrap: shouldWrap,
            gutterStyle: GutterStyle(
              showErrors: false,
              showFoldingHandles: false,
              showLineNumbers: showLineNumbers,
              width: gutterWidth,
              textStyle: TextStyle(
                height: 1.5
              )
            ),
            textStyle: TextStyle(
              fontFamily: fontFamily,
              fontSize: fontSize,
            ),
            expands: true,
          ),
        ),
      );

      return constrainedControl(context, editor, widget.parent, widget.control);
    });
  }

  @override
  void dispose() {
    controller.dispose(); // This also removes listeners
    super.dispose();
  }

  Map<String, TextStyle> parseEditorTheme(String theme) {
    switch (theme) {
      case "a11y-dark":
        return a11yDarkTheme;
      case "a11y-light":
        return a11yLightTheme;
      case "agate":
        return agateTheme;
      case "androidstudio":
        return androidstudioTheme;
      case "arta":
        return artaTheme;
      case "atom-one-dark":
        return atomOneDarkTheme;
      case "default":
        return defaultTheme;
      case "dark":
        return darkTheme;
      case "monokai":
        return monokaiTheme;
      case "monokai-sublime":
        return monokaiSublimeTheme;
      case "obsidian":
        return obsidianTheme;
      case "solarized-light":
        return solarizedLightTheme;
      case "solarized-dark":
        return solarizedDarkTheme;
      case "vs2015":
        return vs2015Theme;
      case "xcode":
        return xcodeTheme;
      case "idea":
        return ideaTheme;
      default:
        return defaultTheme;
    }
  }
}