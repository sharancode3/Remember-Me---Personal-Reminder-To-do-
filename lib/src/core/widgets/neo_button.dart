import 'package:flutter/material.dart';
import '../theme/neo_colors.dart';
import '../theme/neo_shadows.dart';
import '../theme/neo_typography.dart';

enum NeoButtonVariant { accentRed, accentYellow, accentViolet, surface, outline }
enum NeoButtonShape { sharp, pill }

class NeoButton extends StatefulWidget {
  const NeoButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = NeoButtonVariant.accentYellow,
    this.shape = NeoButtonShape.sharp,
    this.icon,
    this.isFullWidth = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    this.fontSize = 14,
    this.rotation = 0.0,
  });

  final String text;
  final VoidCallback? onPressed;
  final NeoButtonVariant variant;
  final NeoButtonShape shape;
  final Widget? icon;
  final bool isFullWidth;
  final EdgeInsets padding;
  final double fontSize;
  final double rotation;

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.neo;
    final isEnabled = widget.onPressed != null;

    Color bg;
    Color fg;
    Color borderColor = colors.border;

    switch (widget.variant) {
      case NeoButtonVariant.accentRed:
        bg = colors.accentRed;
        fg = Colors.white;
        break;
      case NeoButtonVariant.accentYellow:
        bg = colors.accentYellow;
        fg = const Color(0xFF000000);
        break;
      case NeoButtonVariant.accentViolet:
        bg = colors.accentViolet;
        fg = Colors.white; // High-contrast white on Bauhaus Blue
        break;
      case NeoButtonVariant.surface:
        bg = colors.surface;
        fg = colors.textPrimary;
        break;
      case NeoButtonVariant.outline:
        bg = Colors.transparent;
        fg = colors.textPrimary;
        break;
    }

    if (!isEnabled) {
      bg = colors.borderMuted;
      fg = colors.textSecondary;
    }

    final isPill = widget.shape == NeoButtonShape.pill;
    final borderRadius = isPill ? BorderRadius.circular(999) : BorderRadius.zero;
    final translation = _isPressed ? const Offset(3, 3) : Offset.zero;

    Widget buttonContent = Row(
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          widget.icon!,
          const SizedBox(width: 6),
        ],
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.text.toUpperCase(),
              style: NeoTypography.headline(
                color: fg,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ],
    );

    Widget interactive = GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      child: Transform.translate(
        offset: translation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 75),
          width: widget.isFullWidth ? double.infinity : null,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: borderRadius,
            border: Border.all(color: borderColor, width: 3.5),
            boxShadow: (_isPressed || !isEnabled)
                ? []
                : NeoShadows.small(colors.shadow),
          ),
          child: buttonContent,
        ),
      ),
    );

    if (widget.rotation != 0.0) {
      return Transform.rotate(
        angle: widget.rotation,
        child: interactive,
      );
    }
    return interactive;
  }
}
