import 'package:flutter/material.dart';
import '../theme/neo_colors.dart';
import '../theme/neo_shadows.dart';
import '../theme/neo_typography.dart';
import 'neo_bandaid_alarm_logo.dart';

class NeoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NeoAppBar({
    super.key,
    this.title = 'REMEMBER ME',
    this.subtitle,
    this.showMenuButton = true,
    this.onMenuPressed,
    this.onInfoPressed,
    this.onNotificationsPressed,
    this.notificationCount = 0,
    this.bottomBorderWidth = 3.5,
  });

  final String title;
  final String? subtitle;
  final bool showMenuButton;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onInfoPressed;
  final VoidCallback? onNotificationsPressed;
  final int notificationCount;
  final double bottomBorderWidth;

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    final colors = context.neo;

    return Container(
      decoration: BoxDecoration(
        color: colors.canvas,
        border: Border(
          bottom: BorderSide(
            color: colors.border,
            width: bottomBorderWidth,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Top-Left: Tappable Logo that opens How Remember Me Works Info Page
              GestureDetector(
                onTap: onInfoPressed,
                child: NeoBandaidAlarmLogo(
                  size: 36,
                  alarmColor: colors.accentYellow,
                  bandaidColor: colors.accentRed,
                  borderColor: colors.border,
                ),
              ),
              const SizedBox(width: 12),

              // Single Screen Title (Eliminating redundant subtitle block)
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: NeoTypography.headline(
                    color: colors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Top-Right: Notification Bell Button (with Badge)
              if (onNotificationsPressed != null) ...[
                GestureDetector(
                  onTap: onNotificationsPressed,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          border: Border.all(color: colors.border, width: 2.5),
                          boxShadow: NeoShadows.small(colors.shadow),
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          size: 18,
                          color: colors.textPrimary,
                        ),
                      ),
                      if (notificationCount > 0)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: colors.accentRed,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 1.5),
                            ),
                            child: Text(
                              '$notificationCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],

              // Top-Right: Profile Avatar Icon Only (Replaces text pill)
              if (showMenuButton)
                GestureDetector(
                  onTap: onMenuPressed,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.accentYellow,
                      border: Border.all(color: colors.border, width: 2.5),
                      boxShadow: NeoShadows.small(colors.shadow),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
