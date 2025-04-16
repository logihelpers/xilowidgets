import 'package:flutter/material.dart';
import 'package:flet/flet.dart';

import 'package:flet/src/controls/cupertino_alert_dialog.dart';

class XDialogControl extends StatefulWidget {
  final Control? parent;
  final Control control;
  final List<Control> children;
  final bool parentDisabled;
  final bool? parentAdaptive;
  final Widget? nextChild;
  final FletControlBackend backend;

  const XDialogControl(
      {super.key,
      this.parent,
      required this.control,
      required this.children,
      required this.parentDisabled,
      required this.parentAdaptive,
      required this.nextChild,
      required this.backend});

  @override
  State<XDialogControl> createState() => _XDialogControlState();
}

class _XDialogControlState extends State<XDialogControl>
    with FletStoreMixin {
  Widget _createXDialog() {
    bool disabled = widget.control.isDisabled || widget.parentDisabled;
    bool? adaptive =
        widget.control.attrBool("adaptive") ?? widget.parentAdaptive;
    var titleCtrls =
        widget.children.where((c) => c.name == "title" && c.isVisible);
    String titleStr = widget.control.attrString("title", "")!;
    var iconCtrls =
        widget.children.where((c) => c.name == "icon" && c.isVisible);
    var contentCtrls =
        widget.children.where((c) => c.name == "content" && c.isVisible);
    var actionCtrls =
        widget.children.where((c) => c.name == "action" && c.isVisible);
    final actionsAlignment =
        parseMainAxisAlignment(widget.control.attrString("actionsAlignment"));

    if (titleCtrls.isEmpty &&
        titleStr == "" &&
        contentCtrls.isEmpty &&
        actionCtrls.isEmpty) {
      return const ErrorControl(
          "XDialog has nothing to display. Provide at minimum one of the following: title, content, actions");
    }

    var clipBehavior =
        parseClip(widget.control.attrString("clipBehavior"), Clip.none)!;

    return AlertDialog(
      title: titleCtrls.isNotEmpty
          ? createControl(widget.control, titleCtrls.first.id, disabled,
              parentAdaptive: adaptive)
          : titleStr != ""
              ? Text(titleStr)
              : null,
      titlePadding: parseEdgeInsets(widget.control, "titlePadding"),
      content: contentCtrls.isNotEmpty
          ? createControl(widget.control, contentCtrls.first.id, disabled,
              parentAdaptive: adaptive)
          : null,
      contentPadding: parseEdgeInsets(widget.control, "contentPadding",
          const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0))!,
      actions: actionCtrls
          .map((c) => createControl(widget.control, c.id, disabled,
              parentAdaptive: adaptive))
          .toList(),
      actionsPadding: parseEdgeInsets(widget.control, "actionsPadding"),
      actionsAlignment: actionsAlignment,
      shape: parseOutlinedBorder(widget.control, "shape"),
      semanticLabel: widget.control.attrString("semanticsLabel"),
      insetPadding: parseEdgeInsets(widget.control, "insetPadding",
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0))!,
      iconPadding: parseEdgeInsets(widget.control, "iconPadding"),
      backgroundColor: widget.control.attrColor("bgcolor", context),
      buttonPadding: parseEdgeInsets(widget.control, "actionButtonPadding"),
      surfaceTintColor: widget.control.attrColor("surfaceTintColor", context),
      shadowColor: widget.control.attrColor("shadowColor", context),
      elevation: widget.control.attrDouble("elevation"),
      clipBehavior: clipBehavior,
      icon: iconCtrls.isNotEmpty
          ? createControl(widget.control, iconCtrls.first.id, disabled,
              parentAdaptive: adaptive)
          : null,
      iconColor: widget.control.attrColor("iconColor", context),
      scrollable: widget.control.attrBool("scrollable", false)!,
      actionsOverflowButtonSpacing:
          widget.control.attrDouble("actionsOverflowButtonSpacing"),
      alignment: parseAlignment(widget.control, "alignment"),
      contentTextStyle:
          parseTextStyle(Theme.of(context), widget.control, "contentTextStyle"),
      titleTextStyle:
          parseTextStyle(Theme.of(context), widget.control, "titleTextStyle"),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("XDialog build ($hashCode): ${widget.control.id}");

    return withPagePlatform((context, platform) {
      bool? adaptive =
          widget.control.attrBool("adaptive") ?? widget.parentAdaptive;
      if (adaptive == true &&
          (platform == TargetPlatform.iOS ||
              platform == TargetPlatform.macOS)) {
        return CupertinoAlertDialogControl(
            control: widget.control,
            parentDisabled: widget.parentDisabled,
            children: widget.children,
            nextChild: widget.nextChild,
            parentAdaptive: adaptive,
            backend: widget.backend);
      }

      bool lastOpen = widget.control.state["open"] ?? false;

      debugPrint("XDialog build: ${widget.control.id}");

      var open = widget.control.attrBool("open", false)!;
      var modal = widget.control.attrBool("modal", false)!;
      var duration = widget.control.attrInt("duration", 300)!;
      var curve = widget.control.attrString("curve", "easeOutBack");
      var transitionFrom = widget.control.attrString("transitionFrom", "top-left")!;
      var offsetScale = widget.control.attrDouble("offset_scale", 100.0)!;
      var minimum_scale = widget.control.attrDouble("minimum_scale", 0.1)!;
      var maximum_scale = widget.control.attrDouble("maximum_scale", 1.0)!;
      

      debugPrint("Current open state: $lastOpen");
      debugPrint("New open state: $open");

      if (open && (open != lastOpen)) {
        var dialog = _createXDialog();
        if (dialog is ErrorControl) {
          return dialog;
        }

        // close previous dialog
        if (ModalRoute.of(context)?.isCurrent != true) {
          Navigator.of(context).pop();
        }

        widget.control.state["open"] = open;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showGeneralDialog(
              barrierDismissible: !modal,
              barrierColor: widget.control.attrColor("barrierColor", context) ?? Colors.black54,
              pageBuilder: (context, animation, secondaryAnimation) => _createXDialog(),
              context: context,
              transitionDuration: Duration(milliseconds: duration),
              transitionBuilder: (context, animation, secondaryAnimation, child) {
                final scale = Tween<double>(begin: minimum_scale, end: maximum_scale).animate(
                  CurvedAnimation(parent: animation, curve: parseCurve(curve, Curves.easeOutCubic) ?? Curves.easeOutCubic),
                );

                final offset = Tween<Offset>(
                  begin: _getOffsetFromDirection(transitionFrom),
                  end: Offset.zero,
                ).animate(animation);

                return Transform.translate(
                  offset: offset.value * offsetScale,
                  child: Transform.scale(
                    scale: scale.value,
                    child: child, // Use the child from pageBuilder
                  ),
                );
              }
              // builder: (context) => _createXDialog()
          ).then((value) {
            lastOpen = widget.control.state["open"] ?? false;
            debugPrint("Dialog should be dismissed ($hashCode): $lastOpen");
            bool shouldDismiss = lastOpen;
            widget.control.state["open"] = false;

            if (shouldDismiss) {
              widget.backend
                  .updateControlState(widget.control.id, {"open": "false"});
              widget.backend.triggerControlEvent(widget.control.id, "dismiss");
            }
          });
        });
      } else if (open != lastOpen && lastOpen) {
        Navigator.of(context).pop();
      }

      return widget.nextChild ?? const SizedBox.shrink();
    });
  }

  Offset _getOffsetFromDirection(String direction) {
    switch (direction.toLowerCase()) {
      case "top":
        return const Offset(0, -1);
      case "bottom":
        return const Offset(0, 1);
      case "left":
        return const Offset(-1, 0);
      case "right":
        return const Offset(1, 0);
      case "top-left":
        return const Offset(-1, -1);
      case "top-right":
        return const Offset(1, -1);
      case "bottom-left":
        return const Offset(-1, 1);
      case "bottom-right":
        return const Offset(1, 1);
      case "center":
        return Offset.zero;
      default:
        return Offset.zero; // fallback is center
    }
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