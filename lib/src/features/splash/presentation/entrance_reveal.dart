import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/daily_theme.dart';

/// Entrance reveal animation featuring playful spring/bouncy physics
/// and brand reveal on application launch.
class EntranceReveal extends StatefulWidget {
  const EntranceReveal({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1400),
  });

  final Widget child;
  final Duration duration;

  @override
  State<EntranceReveal> createState() => _EntranceRevealState();
}

class _EntranceRevealState extends State<EntranceReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final Animation<double> _ball1Bounce = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
    ),
  );

  late final Animation<double> _ball2Bounce = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.12, 0.55, curve: Curves.easeOutBack),
    ),
  );

  late final Animation<double> _ball3Bounce = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.24, 0.65, curve: Curves.easeOutBack),
    ),
  );

  late final Animation<double> _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.40, 0.75, curve: Curves.easeOut),
    ),
  );

  late final Animation<double> _splashExit = Tween<double>(begin: 1.0, end: 0.0).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.82, 1.0, curve: Curves.easeIn),
    ),
  );

  bool _complete = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.disableAnimationsOf(context)) {
        setState(() => _complete = true);
        return;
      }

      unawaited(HapticFeedback.lightImpact());
      unawaited(_controller.forward().then((_) {
        if (mounted) {
          setState(() => _complete = true);
        }
      }));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_complete) return widget.child;

    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Stack(
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            if (_splashExit.value <= 0) return const SizedBox.shrink();

            return Opacity(
              opacity: _splashExit.value,
              child: Container(
                color: theme.scaffoldBackgroundColor,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildBouncingBall(
                            progress: _ball1Bounce.value,
                            color: primary,
                            size: 28,
                          ),
                          const SizedBox(width: 14),
                          _buildBouncingBall(
                            progress: _ball2Bounce.value,
                            color: const Color(0xFF3577B5),
                            size: 36,
                          ),
                          const SizedBox(width: 14),
                          _buildBouncingBall(
                            progress: _ball3Bounce.value,
                            color: const Color(0xFFB45D72),
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Opacity(
                      opacity: _titleFade.value,
                      child: Transform.translate(
                        offset: Offset(0, 16 * (1 - _titleFade.value)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const RememberMark(),
                            const SizedBox(width: 12),
                            Text(
                              'Remember Me',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBouncingBall({
    required double progress,
    required Color color,
    required double size,
  }) {
    final offset = (1 - progress) * 60;
    final scale = progress.clamp(0.0, 1.0);

    return Transform.translate(
      offset: Offset(0, offset),
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
