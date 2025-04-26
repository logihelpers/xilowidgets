import 'package:flet/flet.dart';
import 'package:flutter/material.dart';

class SwitcherControl extends StatefulWidget {
  final Control? parent;
  final Control control;
  final List<Control> children;
  final bool parentDisabled;
  final bool? parentAdaptive;
  final FletControlBackend backend;

  const SwitcherControl({
    super.key,
    required this.parent,
    required this.control, 
    required this.children,
    required this.parentDisabled, 
    required this.parentAdaptive,
    required this.backend,
  });
  
  @override
  State<SwitcherControl> createState() => _SwitcherControlState();
}

class _SwitcherControlState extends State<SwitcherControl> with FletStoreMixin, TickerProviderStateMixin {
  late PageController _pageViewController;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("XiloSwitcher build: ${widget.control.id}");

    String? animCurveStr = widget.control.attrString("animation_curve", "easeInOut");
    int animDuration = widget.control.attrInt("animation_duration", 250)!;

    () async {
      widget.backend.subscribeMethods(widget.control.id,
          (methodName, args) async {
        switch (methodName) {
          case "switch":
            if (_pageViewController.hasClients) {
              _pageViewController.animateToPage(
                  int.parse(args["current"].toString()),
                  duration: Duration(milliseconds: animDuration),
                  curve: parseCurve(animCurveStr, Curves.easeInOut)!,
                );
            }
        }
        return null;
      });
    }();
 
    Axis _scrollDirection = (widget.control.attrString("orientation", "VERTICAL") == "VERTICAL") ? Axis.vertical: Axis.horizontal;

    bool disabled = widget.control.isDisabled || widget.parentDisabled;

    List<Widget> controls = widget.children.where((c) => c.isVisible).map((c) {
      return createControl(widget.control, c.id, disabled, parentAdaptive: widget.parentAdaptive);
    }).toList();

    var pageView = PageView(
      controller: _pageViewController,
      scrollDirection: _scrollDirection,
      physics: NeverScrollableScrollPhysics(),
      children: controls,
    );

    return constrainedControl(context, pageView, widget.parent, widget.control);
  }
}