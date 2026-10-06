import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../presentation/providers/daily_providers.dart';
import '../../today/presentation/today_tab.dart';

class CalendarTab extends ConsumerWidget {
  const CalendarTab({super.key, required this.onTrail});
  final VoidCallback onTrail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(dailyMonthProvider);
    final selected = ref.watch(dailyDateProvider);
    final counts = ref.watch(dailyCountsProvider).valueOrNull ?? {};
    final firstOffset = (month.weekday + 6) % 7;
    final length = DateTime(month.year, month.month + 1, 0).day;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
      children: [
        const Text(
          'Calendar',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Text(
                DateFormat('MMMM yyyy').format(month),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Previous month',
              onPressed: () => ref.read(dailyMonthProvider.notifier).state =
                  DateTime(month.year, month.month - 1),
              icon: const Icon(Icons.chevron_left),
            ),
            IconButton(
              tooltip: 'Next month',
              onPressed: () => ref.read(dailyMonthProvider.notifier).state =
                  DateTime(month.year, month.month + 1),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: const TextStyle(
                        color: Color(0xFF68756E),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ((firstOffset + length) / 7).ceil() * 7,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            mainAxisExtent: 47,
          ),
          itemBuilder: (context, index) {
            final number = index - firstOffset + 1;
            if (number < 1 || number > length) return const SizedBox.shrink();
            final day = DateTime(month.year, month.month, number);
            final active = selected == day;
            return Semantics(
              label: DateFormat.yMMMMd().format(day),
              selected: active,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => ref.read(dailyDateProvider.notifier).state = day,
                child: Container(
                  decoration: BoxDecoration(
                    color: active
                        ? Theme.of(context).colorScheme.primary
                        : day == dayOnly(DateTime.now())
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: .10)
                        : Colors.transparent,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$number',
                        style: TextStyle(
                          color: active
                              ? Colors.white
                              : const Color(0xFF202B27),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: counts.containsKey(day)
                              ? (active
                                    ? Colors.white
                                    : const Color(0xFF3577B5))
                              : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        Text(
          DateFormat('EEEE, MMMM d').format(selected),
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        DaySummary(onTrail: onTrail),
        const SizedBox(height: 24),
        const TodayTaskLists(),
      ],
    );
  }
}
