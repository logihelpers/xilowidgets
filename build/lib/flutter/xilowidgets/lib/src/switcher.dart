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

  Curve? parseCurve(String? value, [Curve? defValue]) {
    switch (value?.toLowerCase()) {
      case "bouncein":
        return Curves.bounceIn;
      case "bounceinout":
        return Curves.bounceInOut;
      case "bounceout":
        return Curves.bounceOut;
      case "decelerate":
        return Curves.decelerate;
      case "ease":
        return Curves.ease;
      case "easein":
        return Curves.easeIn;
      case "easeinback":
        return Curves.easeInBack;
      case "easeincirc":
        return Curves.easeInCirc;
      case "easeincubic":
        return Curves.easeInCubic;
      case "easeinexpo":
        return Curves.easeInExpo;
      case "easeinout":
        return Curves.easeInOut;
      case "easeinoutback":
        return Curves.easeInOutBack;
      case "easeinoutcirc":
        return Curves.easeInOutCirc;
      case "easeinoutcubic":
        return Curves.easeInOutCubic;
      case "easeinoutcubicemphasized":
        return Curves.easeInOutCubicEmphasized;
      case "easeinoutexpo":
        return Curves.easeInOutExpo;
      case "easeinoutquad":
        return Curves.easeInOutQuad;
      case "easeinoutquart":
        return Curves.easeInOutQuart;
      case "easeinoutquint":
        return Curves.easeInOutQuint;
      case "easeinoutsine":
        return Curves.easeInOutSine;
      case "easeinquad":
        return Curves.easeInQuad;
      case "easeinquart":
        return Curves.easeInQuart;
      case "easeinquint":
        return Curves.easeInQuint;
      case "easeinsine":
        return Curves.easeInSine;
      case "easeintolinear":
        return Curves.easeInToLinear;
      case "easeout":
        return Curves.easeOut;
      case "easeoutback":
        return Curves.easeOutBack;
      case "easeoutcirc":
        return Curves.easeOutCirc;
      case "easeoutcubic":
        return Curves.easeOutCubic;
      case "easeoutexpo":
        return Curves.easeOutExpo;
      case "easeoutquad":
        return Curves.easeOutQuad;
      case "easeoutquart":
        return Curves.easeOutQuart;
      case "easeoutquint":
        return Curves.easeOutQuint;
      case "easeoutsine":
        return Curves.easeOutSine;
      case "elasticin":
        return Curves.elasticIn;
      case "elasticinout":
        return Curves.elasticInOut;
      case "elasticout":
        return Curves.elasticOut;
      case "fastlineartosloweasein":
        return Curves.fastLinearToSlowEaseIn;
      case "fastoutslowin":
        return Curves.fastOutSlowIn;
      case "lineartoeaseout":
        return Curves.linearToEaseOut;
      case "slowmiddle":
        return Curves.slowMiddle;
      default:
        return defValue;
    }
  }
}