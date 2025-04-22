import 'package:flet/flet.dart';
import 'package:flutter/material.dart';

class RevealerControl extends StatefulWidget {
  final Control? parent;
  final Control control;
  final List<Control> children;
  final FletControlBackend backend;

  const RevealerControl({
    super.key,
    required this.parent,
    required this.control,
    required this.children,
    required this.backend,
  });

  @override
  State<RevealerControl> createState() => _RevealerControlState();
}

class _RevealerControlState extends State<RevealerControl>
    with FletStoreMixin, SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _lengthAnimation;
  late Tween<double> _lengthTween;
  late bool _contentHidden;
  late Duration _duration;
  late String _orientation;
  late double _maxLength;
  late Curve _curve;

  @override
  void initState() {
    super.initState();
    _contentHidden = widget.control.attrBool("content_hidden", false)!;
    _orientation = widget.control.attrString("orientation", "HORIZONTAL")!;
    _maxLength = widget.control.attrDouble("content_length", 200.0) ?? 200.0;
    _curve = parseCurve(widget.control.attrString("curve", "easeOutBack"))!;

    _duration = Duration(milliseconds: widget.control.attrInt("animationDuration", 300)!);
    _controller = AnimationController(
      duration: _duration,
      vsync: this,
    );
    
    _lengthTween = Tween<double>(
      begin: widget.control.attrDouble("content_length", 200.0) ?? 200.0,
      end: 0,
    );
    _lengthAnimation = _lengthTween.animate(
      CurvedAnimation(parent: _controller, curve: _curve),
    );

    // Set initial controller value based on content_hidden
    _controller.value = _contentHidden ? 1.0 : 0.0;
  }

  void _updateAnimation(double maxLength) {
    _lengthTween.begin = maxLength;
    _lengthAnimation = _lengthTween.animate(
      CurvedAnimation(parent: _controller, curve: _curve),
    );
  }

  @override
  void didUpdateWidget(RevealerControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    double newLength = widget.control.attrDouble("content_length", 200.0) ?? 200.0;
    bool newContentHidden = widget.control.attrBool("content_hidden", false)!;
    Duration newDuration = Duration(milliseconds: widget.control.attrInt("animationDuration", 300)!);

    if (newLength != _maxLength || newContentHidden != _contentHidden) {
      setState(() {
        _maxLength = newLength;
        _updateAnimation(newLength);
        _duration = newDuration;
        if (newContentHidden != _contentHidden) {
          _contentHidden = newContentHidden;
          if (_contentHidden) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Revealer build ($hashCode): ${widget.control.id}");

    return withPageArgs((context, pageArgs) {
      var sideBarControl = widget.children
          .where((c) => c.name == "content" && c.isVisible)
          .first;

      var builder = LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              AnimatedBuilder(
                animation: _lengthAnimation,
                builder: (context, child) {

                  if (_maxLength == 0 || _lengthAnimation.value == 0) {
                    return const SizedBox.shrink();
                  }

                  return SizedBox(
                    width: _orientation == "HORIZONTAL" ? _lengthAnimation.value : constraints.maxWidth,
                    height: _orientation == "VERTICAL" ? _lengthAnimation.value : constraints.maxHeight,
                    child: createControl(
                        widget.control,
                        sideBarControl.id,
                        widget.control.isDisabled),
                  );
                },
              ),
            ],
          );
        },
      );

      return constrainedControl(context, builder, widget.parent, widget.control);
    });
  }
}