import 'dart:convert';

enum RepeatKind { none, daily, weekly, monthly }

class ReminderRecurrence {
  const ReminderRecurrence({this.kind = RepeatKind.none, this.days = const []});
  final RepeatKind kind;
  final List<int> days;
  bool get repeating => kind != RepeatKind.none;
  String encode() =>
      repeating ? jsonEncode({'kind': kind.name, 'days': days}) : 'none';
  factory ReminderRecurrence.decode(String value) {
    try {
      final data = jsonDecode(value) as Map<String, dynamic>;
      final kind = RepeatKind.values.byName(data['kind'] as String);
      final days = (data['days'] as List).cast<int>();
      return ReminderRecurrence(
        kind: kind,
        days:
            days
                .where(
                  (d) => d >= 1 && d <= (kind == RepeatKind.weekly ? 7 : 31),
                )
                .toSet()
                .toList()
              ..sort(),
      );
    } catch (_) {
      return const ReminderRecurrence();
    }
  }
  bool includes(DateTime day, DateTime anchor) {
    final date = DateTime(day.year, day.month, day.day);
    if (date.isBefore(DateTime(anchor.year, anchor.month, anchor.day))) {
      return false;
    }
    return switch (kind) {
      RepeatKind.none =>
        date == DateTime(anchor.year, anchor.month, anchor.day),
      RepeatKind.daily => true,
      RepeatKind.weekly => days.contains(day.weekday),
      RepeatKind.monthly => days.contains(day.day),
    };
  }

  DateTime? nextAfter(DateTime after, DateTime anchor) {
    var date = DateTime(after.year, after.month, after.day);
    for (var i = 0; i < 370; i++) {
      final candidate = DateTime(
        date.year,
        date.month,
        date.day,
        anchor.hour,
        anchor.minute,
      );
      if (candidate.isAfter(after) && includes(candidate, anchor)) {
        return candidate;
      }
      date = DateTime(date.year, date.month, date.day + 1);
    }
    return null;
  }

  String get label => switch (kind) {
    RepeatKind.none => 'Does not repeat',
    RepeatKind.daily => 'Every day',
    RepeatKind.weekly =>
      'Every ${days.map((d) => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][d - 1]).join(', ')}',
    RepeatKind.monthly => 'Monthly on ${days.join(', ')}',
  };
}
