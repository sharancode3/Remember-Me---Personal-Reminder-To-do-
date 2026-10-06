import 'package:flutter/material.dart';

class PressableAction extends StatefulWidget {
  const PressableAction({
    super.key,
    required this.child,
    required this.onTap,
    this.enabled = true,
    this.baseDuration = const Duration(milliseconds: 110),
  });

  final Widget child;
  final VoidCallback onTap;
  final bool enabled;
  final Duration baseDuration;

  @override
  State<PressableAction> createState() => _PressableActionState();
}

class _PressableActionState extends State<PressableAction> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = _pressed ? 0.96 : 1.0;
    final opacity = _pressed ? 0.95 : 1.0;

    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: widget.enabled ? () => setState(() => _pressed = false) : null,
      onTapUp: widget.enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap();
            }
          : null,
      child: AnimatedScale(
        scale: scale,
        duration: widget.baseDuration,
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: opacity,
          duration: widget.baseDuration,
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
