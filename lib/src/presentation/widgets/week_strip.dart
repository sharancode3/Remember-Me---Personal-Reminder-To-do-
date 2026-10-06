import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/pressable_action.dart';

class WeekStrip extends StatefulWidget {
  const WeekStrip({
    super.key,
    required this.selectedDay,
    required this.onSelect,
    required this.onWeekShift,
    this.dayCompletion = const {},
    this.dayRealism = const {},
  });

  final DateTime selectedDay;
  final ValueChanged<DateTime> onSelect;
  final ValueChanged<int> onWeekShift;
  final Map<DateTime, double> dayCompletion;
  final Map<DateTime, bool> dayRealism;

  @override
  State<WeekStrip> createState() => _WeekStripState();
}

class _WeekStripState extends State<WeekStrip> {
  int _direction = 1;

  @override
  Widget build(BuildContext context) {
    final selectedDay = widget.selectedDay;
    final start = selectedDay.subtract(Duration(days: selectedDay.weekday - 1));
    final days = List.generate(7, (i) => start.add(Duration(days: i)));
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final switchDuration = Duration(milliseconds: isDesktop ? 240 : 200);

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity < -100) {
          setState(() => _direction = 1);
          widget.onWeekShift(1);
        } else if (velocity > 100) {
          setState(() => _direction = -1);
          widget.onWeekShift(-1);
        }
      },
      child: SizedBox(
        height: 56,
        child: AnimatedSwitcher(
          duration: switchDuration,
          transitionBuilder: (child, animation) {
            final begin = Offset(_direction * 0.08, 0);
            return FadeTransition(
              opacity: Tween<double>(begin: 0.85, end: 1.0).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(begin: begin, end: Offset.zero).animate(animation),
                child: child,
              ),
            );
          },
          child: ListView.separated(
            key: ValueKey(start),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              final day = days[index];
              final isSelected = _sameDate(day, selectedDay);
              final completion = _completionForDay(day);
                final realismWarning = _realismForDay(day);
              final indicatorColor = completion >= 0.95
                  ? const Color(0xFF67C587)
                  : completion > 0
                      ? const Color(0xFFE0B04F)
                      : const Color(0xFF8A8A8A);

              final content = AnimatedContainer(
                duration: AppTheme.micro,
                curve: Curves.easeInOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: isSelected ? AppTheme.accentGradient : null,
                  color: isSelected ? null : AppTheme.surface,
                  border: Border.all(color: isSelected ? Colors.transparent : Colors.white10),
                  boxShadow: isSelected
                      ? const [
                          BoxShadow(color: Color(0x444F8CFF), blurRadius: 12, offset: Offset(0, 4)),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat.d().format(day),
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppTheme.textSecondary,
                      ),
                    ),
                    if (realismWarning) ...[
                      const SizedBox(width: 4),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB300).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFFFB300).withValues(alpha: 0.6)),
                        ),
                        child: const Center(
                          child: Text('!', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                    const SizedBox(width: 6),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: indicatorColor, shape: BoxShape.circle),
                    ),
                  ],
                ),
              );
              return PressableAction(onTap: () => widget.onSelect(day), child: content);
            },
            separatorBuilder: (_, _) => const SizedBox(width: AppTheme.s8),
            itemCount: days.length,
          ),
        ),
      ),
    );
  }

  double _completionForDay(DateTime day) {
    final key = widget.dayCompletion.keys.firstWhere(
      (value) => _sameDate(value, day),
      orElse: () => DateTime(0),
    );
    if (key.year == 0) return 0;
    return widget.dayCompletion[key] ?? 0;
  }

  bool _realismForDay(DateTime day) {
    final key = widget.dayRealism.keys.firstWhere(
      (value) => _sameDate(value, day),
      orElse: () => DateTime(0),
    );
    if (key.year == 0) return false;
    return widget.dayRealism[key] ?? false;
  }

  bool _sameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
