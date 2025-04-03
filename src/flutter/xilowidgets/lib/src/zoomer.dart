import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:interactive_viewer_2/interactive_viewer_2.dart';

class ZoomerControl extends StatefulWidget{
  final Control? parent;
  final Control control;
  final List<Control> children;
  final bool parentDisabled;
  final bool? parentAdaptive;

  const ZoomerControl({
    super.key,
    required this.parent,
    required this.control,
    required this.children, 
    required this.parentDisabled, 
    required this.parentAdaptive
  });
  
  @override
  State<ZoomerControl> createState() =>  _ZoomerControlState();
}

class _ZoomerControlState extends State<ZoomerControl> with FletStoreMixin{

  @override
  Widget build(BuildContext context) {
    double minScale = widget.control.attrDouble("minimum_scale", 0.1)!;
    double maxScale = widget.control.attrDouble("maximum_scale", 1)!;

    var contentCtrls =
        widget.children.where((c) => c.name == "content" && c.isVisible);

    Widget interactive_viewer = Expanded(
      child: InteractiveViewer2(
        child: createControl(widget.control,contentCtrls.first.id, widget.control.isDisabled),
        maxScale: maxScale,
        minScale: minScale,
        clipBehavior: Clip.antiAlias,
      )
    );

    return constrainedControl(context, interactive_viewer, widget.parent, widget.control);
  }
}