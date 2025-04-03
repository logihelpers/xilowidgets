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

  Future<void> returnToFlet(double _width, double _height) async {
    widget.backend.triggerControlEvent(
      widget.control.id, 
      "size_change", 
      json.encode(MediaQuerySizeChangeEvent(
          width: _width,
          height: _height)
      .toJson()));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("MediaQueryContainer build: ${widget.control.id}");

    final mediaQuery = MediaQuery.of(context);

    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;
    
    () async {
      returnToFlet(screenWidth, screenHeight);
    }();

    Widget wg = SizedBox.shrink();

    return constrainedControl(context, wg, widget.parent, widget.control);
  }

  @override
  void initState() {
    super.initState();
  }
}