import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

extension on CustomPainter {
  Future<Uint8List?> toPng (Size size) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    paint(canvas, size);
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData == null ? null : Uint8List.view(byteData.buffer);
  }
}

class DrawboardViewModel extends Equatable {
  final Control control;
  final Control? child;
  final List<ControlTreeViewModel> shapes;

  const DrawboardViewModel(
      {required this.control, required this.child, required this.shapes});

  static DrawboardViewModel fromStore(
      Store<AppState> store, Control control, List<Control> children) {
    return DrawboardViewModel(
        control: control,
        child: store.state.controls[control.id]!.childIds
            .map((childId) => store.state.controls[childId])
            .nonNulls
            .where((c) => c.name == "content" && c.isVisible)
            .firstOrNull,
        shapes: children
            .where((c) => c.name != "content" && c.isVisible)
            .map((c) => ControlTreeViewModel.fromStore(store, c))
            .toList());
  }

  @override
  List<Object?> get props => [control, shapes];
}

typedef DrawboardControlOnPaintCallback = void Function(Size size);

class DrawboardControl extends StatefulWidget {
  final Control? parent;
  final Control control;
  final List<Control> children;
  final bool parentDisabled;
  final bool? parentAdaptive;
  final FletControlBackend backend;

  const DrawboardControl(
      {super.key,
      this.parent,
      required this.control,
      required this.children,
      required this.parentDisabled,
      required this.parentAdaptive,
      required this.backend});

  @override
  State<DrawboardControl> createState() => _DrawboardControlState();
}

class _DrawboardControlState extends State<DrawboardControl> {
  int _lastResize = DateTime.now().millisecondsSinceEpoch;
  Size? _lastSize;
  FletCustomPainter? painter;

  Future<String> _captureCanvas(double width, double height) async {
    try {
      Uint8List? byteData = await painter?.toPng(Size(width, height));
      if (byteData != null) {
        String base64_image = base64Encode(byteData);
        widget.backend.triggerControlEvent(widget.control.id, "captured", base64_image);
        return base64_image;
      }
      
      return '\n';
    } catch (e) {
      print('Error capturing widget: $e');

      return '\n';
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("CustomPaint build: ${widget.control.id}");

    () async {
      widget.backend.subscribeMethods(widget.control.id,
          (methodName, args) async {
        switch (methodName) {
          case "capture":
            await _captureCanvas(
              double.parse(args["width"].toString()), 
              double.parse(args["height"].toString())
            );
        }
        return null;
      });
    }();

    var result = StoreConnector<AppState, DrawboardViewModel>(
        distinct: true,
        ignoreChange: (state) {
          return state.controls[widget.control.id] == null;
        },
        converter: (store) =>
            DrawboardViewModel.fromStore(store, widget.control, widget.children),
        builder: (context, viewModel) {
          var onResize = viewModel.control.attrBool("onResize", false)!;
          var resizeInterval = viewModel.control.attrInt("resizeInterval", 10)!;

          painter = FletCustomPainter(
            context: context,
            theme: Theme.of(context),
            shapes: viewModel.shapes,
            onPaintCallback: (size) {
              if (onResize) {
                var now = DateTime.now().millisecondsSinceEpoch;
                if ((now - _lastResize > resizeInterval &&
                        _lastSize != size) ||
                    _lastSize == null) {
                  _lastResize = now;
                  _lastSize = size;
                  widget.backend.triggerControlEvent(
                      viewModel.control.id,
                      "resize",
                      json.encode({"w": size.width, "h": size.height}));
                }
              }
            },
          );

          var paint = CustomPaint(
            painter: painter,
            child: viewModel.child != null
                ? createControl(viewModel.control, viewModel.child!.id,
                    viewModel.control.isDisabled,
                    parentAdaptive: widget.parentAdaptive)
                : null,
          );

          return paint;
        });

    return constrainedControl(context, result, widget.parent, widget.control);
  }
}

class FletCustomPainter extends CustomPainter {
  final BuildContext context;
  final ThemeData theme;
  final List<ControlTreeViewModel> shapes;
  final DrawboardControlOnPaintCallback onPaintCallback;

  const FletCustomPainter(
      {required this.context,
      required this.theme,
      required this.shapes,
      required this.onPaintCallback});

  @override
  void paint(Canvas canvas, Size size) {
    onPaintCallback(size);

    //debugPrint("SHAPE CONTROLS: $shapes");

    for (var shape in shapes) {
      if (shape.control.type == "line") {
        drawLine(canvas, shape);
      } else if (shape.control.type == "circle") {
        drawCircle(canvas, shape);
      } else if (shape.control.type == "arc") {
        drawArc(canvas, shape);
      } else if (shape.control.type == "color") {
        drawColor(canvas, shape);
      } else if (shape.control.type == "oval") {
        drawOval(canvas, shape);
      } else if (shape.control.type == "fill") {
        drawFill(canvas, shape);
      } else if (shape.control.type == "points") {
        drawPoints(canvas, shape);
      } else if (shape.control.type == "rect") {
        drawRect(canvas, shape);
      } else if (shape.control.type == "path") {
        drawPath(canvas, shape);
      } else if (shape.control.type == "shadow") {
        drawShadow(canvas, shape);
      } else if (shape.control.type == "text") {
        drawText(context, canvas, shape);
      }
    }
  }

  @override
  bool shouldRepaint(FletCustomPainter oldDelegate) {
    return true;
  }

  void drawLine(Canvas canvas, ControlTreeViewModel shape) {
    Paint paint = parsePaint(theme, shape.control, "paint");
    var dashPattern = parsePaintStrokeDashPattern(shape.control, "paint");
    paint.style = ui.PaintingStyle.stroke;
    var path = ui.Path();
    path.moveTo(
        shape.control.attrDouble("x1")!, shape.control.attrDouble("y1")!);
    path.lineTo(
        shape.control.attrDouble("x2")!, shape.control.attrDouble("y2")!);

    if (dashPattern != null) {
      path = dashPath(path, dashArray: CircularIntervalList(dashPattern));
    }
    canvas.drawPath(path, paint);
  }

  void drawCircle(Canvas canvas, ControlTreeViewModel shape) {
    var radius = shape.control.attrDouble("radius", 0)!;
    Paint paint = parsePaint(theme, shape.control, "paint");
    canvas.drawCircle(
        Offset(shape.control.attrDouble("x")!, shape.control.attrDouble("y")!),
        radius,
        paint);
  }

  void drawOval(Canvas canvas, ControlTreeViewModel shape) {
    var width = shape.control.attrDouble("width", 0)!;
    var height = shape.control.attrDouble("height", 0)!;
    Paint paint = parsePaint(theme, shape.control, "paint");
    canvas.drawOval(
        Rect.fromLTWH(shape.control.attrDouble("x")!,
            shape.control.attrDouble("y")!, width, height),
        paint);
  }

  void drawArc(Canvas canvas, ControlTreeViewModel shape) {
    var width = shape.control.attrDouble("width", 0)!;
    var height = shape.control.attrDouble("height", 0)!;
    var startAngle = shape.control.attrDouble("startAngle", 0)!;
    var sweepAngle = shape.control.attrDouble("sweepAngle", 0)!;
    var useCenter = shape.control.attrBool("useCenter", false)!;
    Paint paint = parsePaint(theme, shape.control, "paint");
    canvas.drawArc(
        Rect.fromLTWH(shape.control.attrDouble("x")!,
            shape.control.attrDouble("y")!, width, height),
        startAngle,
        sweepAngle,
        useCenter,
        paint);
  }

  void drawFill(Canvas canvas, ControlTreeViewModel shape) {
    Paint paint = parsePaint(theme, shape.control, "paint");
    canvas.drawPaint(paint);
  }

  void drawColor(Canvas canvas, ControlTreeViewModel shape) {
    var color = shape.control.attrColor("color", context) ?? Colors.black;
    var blendMode = parseBlendMode(
        shape.control.attrString("blendMode"), BlendMode.srcOver)!;
    canvas.drawColor(color, blendMode);
  }

  void drawPoints(Canvas canvas, ControlTreeViewModel shape) {
    var points = parseOffsetList(shape.control, "points")!;
    var pointMode = ui.PointMode.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
            shape.control.attrString("pointMode", "")!.toLowerCase(),
        orElse: () => ui.PointMode.points);
    Paint paint = parsePaint(theme, shape.control, "paint");
    canvas.drawPoints(pointMode, points, paint);
  }

  void drawRect(Canvas canvas, ControlTreeViewModel shape) {
    var width = shape.control.attrDouble("width", 0)!;
    var height = shape.control.attrDouble("height", 0)!;
    var borderRadius = parseBorderRadius(shape.control, "borderRadius");
    Paint paint = parsePaint(theme, shape.control, "paint");
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(shape.control.attrDouble("x")!,
                shape.control.attrDouble("y")!, width, height),
            topLeft: borderRadius?.topLeft ?? Radius.zero,
            topRight: borderRadius?.topRight ?? Radius.zero,
            bottomLeft: borderRadius?.bottomLeft ?? Radius.zero,
            bottomRight: borderRadius?.bottomRight ?? Radius.zero),
        paint);
  }

  void drawText(
      BuildContext context, Canvas canvas, ControlTreeViewModel shape) {
    var offset =
        Offset(shape.control.attrDouble("x")!, shape.control.attrDouble("y")!);
    var alignment =
        parseAlignment(shape.control, "alignment", Alignment.topLeft)!;
    var text = shape.control.attrString("text", "")!;
    TextStyle style = parseTextStyle(theme, shape.control, "style") ??
        theme.textTheme.bodyMedium!;

    if (style.color == null) {
      style = style.copyWith(color: theme.textTheme.bodyMedium!.color);
    }

    TextAlign? textAlign =
        parseTextAlign(shape.control.attrString("textAlign"), TextAlign.start)!;
    TextSpan span = TextSpan(
        text: text,
        style: style,
        children: parseTextSpans(theme, shape, false, null));

    var maxLines = shape.control.attrInt("maxLines");
    var maxWidth = shape.control.attrDouble("maxWidth");
    var ellipsis = shape.control.attrString("ellipsis");

    // paint
    TextPainter textPainter = TextPainter(
        text: span,
        textAlign: textAlign,
        maxLines: maxLines,
        ellipsis: ellipsis,
        textDirection: Directionality.of(context));
    textPainter.layout(maxWidth: maxWidth ?? double.infinity);

    var angle = shape.control.attrDouble("rotate", 0)!;

    final delta = Offset(
        offset.dx - textPainter.size.width / 2 * (alignment.x + 1.0),
        offset.dy - textPainter.size.height / 2 * (alignment.y + 1.0));

    // rotate the text around offset point
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.rotate(angle);
    canvas.translate(-offset.dx, -offset.dy);
    textPainter.paint(canvas, delta);
    canvas.restore();
  }

  void drawPath(Canvas canvas, ControlTreeViewModel shape) {
    var path =
        buildPath(json.decode(shape.control.attrString("elements", "[]")!));
    Paint paint = parsePaint(theme, shape.control, "paint");
    var dashPattern = parsePaintStrokeDashPattern(shape.control, "paint");
    if (dashPattern != null) {
      path = dashPath(path, dashArray: CircularIntervalList(dashPattern));
    }
    canvas.drawPath(path, paint);
  }

  void drawShadow(Canvas canvas, ControlTreeViewModel shape) {
    var path = buildPath(json.decode(shape.control.attrString("path", "[]")!));
    var color = shape.control.attrColor("color", context) ?? Colors.black;
    var elevation = shape.control.attrDouble("elevation", 0)!;
    var transparentOccluder =
        shape.control.attrBool("transparentOccluder", false)!;
    canvas.drawShadow(path, color, elevation, transparentOccluder);
  }

  ui.Path buildPath(dynamic j) {
    var path = ui.Path();
    if (j == null) {
      return path;
    }
    for (var elem in (j as List)) {
      var type = elem["type"];
      if (type == "moveto") {
        path.moveTo(parseDouble(elem["x"], 0)!, parseDouble(elem["y"], 0)!);
      } else if (type == "lineto") {
        path.lineTo(parseDouble(elem["x"], 0)!, parseDouble(elem["y"], 0)!);
      } else if (type == "arc") {
        path.addArc(
            Rect.fromLTWH(
                parseDouble(elem["x"], 0)!,
                parseDouble(elem["y"], 0)!,
                parseDouble(elem["width"], 0)!,
                parseDouble(elem["height"], 0)!),
            parseDouble(elem["start_angle"], 0)!,
            parseDouble(elem["sweep_angle"], 0)!);
      } else if (type == "arcto") {
        path.arcToPoint(
            Offset(parseDouble(elem["x"], 0)!, parseDouble(elem["y"], 0)!),
            radius: Radius.circular(parseDouble(elem["radius"], 0)!),
            rotation: parseDouble(elem["rotation"], 0)!,
            largeArc: parseBool(elem["large_arc"], false)!,
            clockwise: parseBool(elem["clockwise"], true)!);
      } else if (type == "oval") {
        path.addOval(Rect.fromLTWH(
            parseDouble(elem["x"], 0)!,
            parseDouble(elem["y"], 0)!,
            parseDouble(elem["width"], 0)!,
            parseDouble(elem["height"], 0)!));
      } else if (type == "rect") {
        var borderRadius = borderRadiusFromJSON(elem["border_radius"]);
        path.addRRect(RRect.fromRectAndCorners(
            Rect.fromLTWH(
                parseDouble(elem["x"], 0)!,
                parseDouble(elem["y"], 0)!,
                parseDouble(elem["width"], 0)!,
                parseDouble(elem["height"], 0)!),
            topLeft: borderRadius?.topLeft ?? Radius.zero,
            topRight: borderRadius?.topRight ?? Radius.zero,
            bottomLeft: borderRadius?.bottomLeft ?? Radius.zero,
            bottomRight: borderRadius?.bottomRight ?? Radius.zero));
      } else if (type == "conicto") {
        path.conicTo(
            parseDouble(elem["cp1x"], 0)!,
            parseDouble(elem["cp1y"], 0)!,
            parseDouble(elem["x"], 0)!,
            parseDouble(elem["y"], 0)!,
            parseDouble(elem["w"], 0)!);
      } else if (type == "cubicto") {
        path.cubicTo(
            parseDouble(elem["cp1x"], 0)!,
            parseDouble(elem["cp1y"], 0)!,
            parseDouble(elem["cp2x"], 0)!,
            parseDouble(elem["cp2y"], 0)!,
            parseDouble(elem["x"], 0)!,
            parseDouble(elem["y"], 0)!);
      } else if (type == "subpath") {
        path.addPath(buildPath(elem["elements"]),
            Offset(parseDouble(elem["x"], 0)!, parseDouble(elem["y"], 0)!));
      } else if (type == "close") {
        path.close();
      }
    }
    return path;
  }
}