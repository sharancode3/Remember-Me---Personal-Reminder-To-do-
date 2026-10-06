import 'package:flutter/material.dart';
import '../theme/neo_colors.dart';

class NeoCard extends StatelessWidget {
  const NeoCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 3.5,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.hasShadow = true,
    this.shadowOffset = const Offset(6, 6),
    this.rotation = 0.0,
    this.onTap,
  });

  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final bool hasShadow;
  final Offset shadowOffset;
  final double rotation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.neo;
    final bg = backgroundColor ?? colors.surface;
    final border = borderColor ?? colors.border;

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: border, width: borderWidth),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: colors.shadow,
                  offset: shadowOffset,
                  blurRadius: 0,
                  spreadRadius: 0,
                )
              ]
            : null,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    if (rotation != 0.0) {
      return Transform.rotate(
        angle: rotation,
        child: card,
      );
    }
    return card;
  }
}
