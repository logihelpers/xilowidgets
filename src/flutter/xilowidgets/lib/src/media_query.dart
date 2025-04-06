import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class MediaQuerySizeChangeEvent {
  final double width;
  final double height;

  MediaQuerySizeChangeEvent(
      {required this.width,
      required this.height});

  Map<String, dynamic> toJson() => <String, dynamic>{
        'width': width,
        'height': height,
      };
}

class MediaQueryThemeModeChangeEvent {
  final bool themeMode;

  MediaQueryThemeModeChangeEvent(
      {required this.themeMode});

  Map<String, dynamic> toJson() => <String, dynamic>{
        'theme_mode': themeMode,
      };
}

class MediaQueryControl extends StatefulWidget with FletStoreMixin {
  final Control? parent;
  final Control control;
  final FletControlBackend backend;

  const MediaQueryControl({
    super.key,
    this.parent,
    required this.control,
    required this.backend
  });

  State<MediaQueryControl> createState() => _MediaQueryControlState();
}

class _MediaQueryControlState extends State<MediaQueryControl> with FletStoreMixin {

  Future<void> returnSizeToFlet(double _width, double _height) async {
    widget.backend.triggerControlEvent(
      widget.control.id, 
      "size_change", 
      json.encode(MediaQuerySizeChangeEvent(
          width: _width,
          height: _height)
      .toJson()));
  }

  Future<void> returnThemeModeToFlet(bool _themeMode) async {
    widget.backend.triggerControlEvent(
      widget.control.id, 
      "theme_mode_change", 
      json.encode(MediaQueryThemeModeChangeEvent(
          themeMode: _themeMode)
      .toJson()));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("MediaQueryContainer build: ${widget.control.id}");

    final mediaQuery = MediaQuery.of(context);

    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;
    bool mode = mediaQuery.platformBrightness == Brightness.dark;
    
    () async {
      returnSizeToFlet(screenWidth, screenHeight);
    }();

    () async {
      returnThemeModeToFlet(mode);
    }();

    Widget wg = SizedBox.shrink();

    return constrainedControl(context, wg, widget.parent, widget.control);
  }

  @override
  void initState() {
    super.initState();
  }
}