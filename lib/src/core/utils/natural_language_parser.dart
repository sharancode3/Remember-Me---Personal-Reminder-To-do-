import 'package:flutter/material.dart';

class ParsedTaskInput {
  ParsedTaskInput({
    required this.title,
    required this.startAt,
    required this.endAt,
    this.durationMinutes = 30,
    this.priority = 1,
    this.isRecurring = false,
    this.recurringDays = const [],
    this.tag,
  });

  final String title;
  final DateTime startAt;
  final DateTime endAt;
  final int durationMinutes;
  final int priority;
  final bool isRecurring;
  final List<int> recurringDays;
  final String? tag;
}

class NaturalLanguageTaskParser {
  /// Parses freeform input string offline using deterministic rules and regex
  /// e.g. "Study physics tomorrow 7 to 9" -> title: "Study physics", start: Tomorrow 7:00, end: Tomorrow 9:00
  /// e.g. "Gym 45m at 6pm" -> title: "Gym", start: Today 18:00, end: Today 18:45
  /// e.g. "Finish report priority:high in 2h" -> title: "Finish report", priority: 2, duration: 120m
  static ParsedTaskInput parse(String rawText, {DateTime? referenceTime}) {
    final now = referenceTime ?? DateTime.now();
    String text = rawText.trim();

    if (text.isEmpty) {
      final defaultStart = now.add(const Duration(minutes: 5));
      return ParsedTaskInput(
        title: 'New Task',
        startAt: defaultStart,
        endAt: defaultStart.add(const Duration(minutes: 30)),
        durationMinutes: 30,
      );
    }

    // 1. Priority parsing (e.g. !p1, !urgent, !p2, !p3, !low)
    // In Remember Me: Priority 2 = P1 (Critical), Priority 1 = P2 (Important), Priority 0 = P3 (Normal)
    int priority = 1;
    final pHighRegex = RegExp(r'(!p1|!high|!urgent|!critical|p:1|p:high)\b', caseSensitive: false);
    final pMedRegex = RegExp(r'(!p2|!med|!medium|!important|p:2|p:med)\b', caseSensitive: false);
    final pLowRegex = RegExp(r'(!p3|!low|!normal|!optional|p:3|p:low)\b', caseSensitive: false);

    if (pHighRegex.hasMatch(text)) {
      priority = 2; // P1 Critical
      text = text.replaceAll(pHighRegex, '').trim();
    } else if (pMedRegex.hasMatch(text)) {
      priority = 1; // P2 Important
      text = text.replaceAll(pMedRegex, '').trim();
    } else if (pLowRegex.hasMatch(text)) {
      priority = 0; // P3 Normal
      text = text.replaceAll(pLowRegex, '').trim();
    }

    // 2. Category / Tag (#study, #work, #gym)
    String? tag;
    final tagRegex = RegExp(r'#([a-zA-Z0-9_\-]+)');
    final tagMatch = tagRegex.firstMatch(text);
    if (tagMatch != null) {
      tag = tagMatch.group(1);
      text = text.replaceAll(tagRegex, '').trim();
    }

    // 3. Date Parsing (tomorrow, today, mon, tue, wed, thu, fri, sat, sun, saturday, etc.)
    DateTime targetDate = DateTime(now.year, now.month, now.day);
    final tomorrowRegex = RegExp(r'\b(tomorrow|tmrw)\b', caseSensitive: false);
    final todayRegex = RegExp(r'\b(today)\b', caseSensitive: false);
    final weekdayRegex = RegExp(
      r'\b(monday|mon|tuesday|tue|wednesday|wed|thursday|thu|friday|fri|saturday|sat|sunday|sun)\b',
      caseSensitive: false,
    );

    if (tomorrowRegex.hasMatch(text)) {
      targetDate = targetDate.add(const Duration(days: 1));
      text = text.replaceAll(tomorrowRegex, '').trim();
    } else if (todayRegex.hasMatch(text)) {
      text = text.replaceAll(todayRegex, '').trim();
    } else if (weekdayRegex.hasMatch(text)) {
      final match = weekdayRegex.firstMatch(text)!.group(1)!.toLowerCase();
      const dayMap = {
        'mon': 1, 'monday': 1,
        'tue': 2, 'tuesday': 2,
        'wed': 3, 'wednesday': 3,
        'thu': 4, 'thursday': 4,
        'fri': 5, 'friday': 5,
        'sat': 6, 'saturday': 6,
        'sun': 7, 'sunday': 7,
      };
      final targetWeekday = dayMap[match] ?? now.weekday;
      int daysAhead = targetWeekday - now.weekday;
      if (daysAhead <= 0) daysAhead += 7;
      targetDate = targetDate.add(Duration(days: daysAhead));
      text = text.replaceAll(weekdayRegex, '').trim();
    }

    // 4. Time Range Parsing (e.g. "7 to 9", "7pm to 9pm", "14:00 to 15:30", "7 - 8:30pm")
    final timeRangeRegex = RegExp(
      r'\b(?:at\s+)?(\d{1,2})(?::(\d{2}))?\s*(am|pm)?\s*(?:to|-)\s*(\d{1,2})(?::(\d{2}))?\s*(am|pm)?\b',
      caseSensitive: false,
    );
    final rangeMatch = timeRangeRegex.firstMatch(text);

    int startHour = 0;
    int startMinute = 0;
    int endHour = 0;
    int endMinute = 0;
    bool timeRangeFound = false;

    if (rangeMatch != null) {
      int h1 = int.parse(rangeMatch.group(1)!);
      int m1 = rangeMatch.group(2) != null ? int.parse(rangeMatch.group(2)!) : 0;
      String? ampm1 = rangeMatch.group(3)?.toLowerCase();

      int h2 = int.parse(rangeMatch.group(4)!);
      int m2 = rangeMatch.group(5) != null ? int.parse(rangeMatch.group(5)!) : 0;
      String? ampm2 = rangeMatch.group(6)?.toLowerCase();

      // Normalize AM/PM if only the second has it (e.g., "7 to 9pm" -> 19:00 to 21:00)
      if (ampm1 == null && ampm2 != null) {
        if (ampm2 == 'pm' && h1 < 12) h1 += 12;
        if (ampm2 == 'am' && h1 == 12) h1 = 0;
      } else if (ampm1 == 'pm' && h1 < 12) {
        h1 += 12;
      } else if (ampm1 == 'am' && h1 == 12) {
        h1 = 0;
      }

      if (ampm2 == 'pm' && h2 < 12) {
        h2 += 12;
      } else if (ampm2 == 'am' && h2 == 12) {
        h2 = 0;
      }

      startHour = h1;
      startMinute = m1;
      endHour = h2;
      endMinute = m2;
      timeRangeFound = true;
      text = text.replaceAll(timeRangeRegex, '').trim();
    }

    // 5. Single Time parsing (e.g., "at 6pm", "at 14:30", "at 7")
    final singleTimeRegex = RegExp(
      r'\b(?:at\s+)?(\d{1,2})(?::(\d{2}))?\s*(am|pm)\b|\b(?:at\s+)(\d{1,2})(?::(\d{2}))?\b',
      caseSensitive: false,
    );
    final singleTimeMatch = singleTimeRegex.firstMatch(text);
    if (!timeRangeFound && singleTimeMatch != null) {
      final hourStr = singleTimeMatch.group(1) ?? singleTimeMatch.group(4);
      final minStr = singleTimeMatch.group(2) ?? singleTimeMatch.group(5);
      final ampm = singleTimeMatch.group(3)?.toLowerCase();

      if (hourStr != null) {
        int h = int.parse(hourStr);
        int m = minStr != null ? int.parse(minStr) : 0;

        if (ampm == 'pm' && h < 12) {
          h += 12;
        } else if (ampm == 'am' && h == 12) {
          h = 0;
        } else if (ampm == null && h >= 1 && h <= 6) {
          // Likely evening if 1 to 6 without am/pm
          h += 12;
        }

        startHour = h;
        startMinute = m;
        timeRangeFound = true;
        text = text.replaceAll(singleTimeRegex, '').trim();
      }
    }

    // 6. Explicit Duration Parsing (e.g., "45m", "1h", "1.5h", "90 mins")
    int durationMinutes = 30;
    final durHourRegex = RegExp(r'\b(\d+(?:\.\d+)?)\s*(?:h|hr|hours?)\b', caseSensitive: false);
    final durMinRegex = RegExp(r'\b(\d+)\s*(?:m|min|mins|minutes?)\b', caseSensitive: false);

    final hourMatch = durHourRegex.firstMatch(text);
    final minMatch = durMinRegex.firstMatch(text);

    if (hourMatch != null) {
      final hours = double.parse(hourMatch.group(1)!);
      durationMinutes = (hours * 60).round();
      text = text.replaceAll(durHourRegex, '').trim();
    } else if (minMatch != null) {
      durationMinutes = int.parse(minMatch.group(1)!);
      text = text.replaceAll(durMinRegex, '').trim();
    }

    // 7. Calculate Start & End DateTimes
    DateTime finalStart;
    DateTime finalEnd;

    if (timeRangeFound && endHour != 0) {
      finalStart = DateTime(targetDate.year, targetDate.month, targetDate.day, startHour, startMinute);
      finalEnd = DateTime(targetDate.year, targetDate.month, targetDate.day, endHour, endMinute);
      if (finalEnd.isBefore(finalStart)) {
        finalEnd = finalEnd.add(const Duration(days: 1));
      }
      durationMinutes = finalEnd.difference(finalStart).inMinutes;
    } else if (timeRangeFound) {
      finalStart = DateTime(targetDate.year, targetDate.month, targetDate.day, startHour, startMinute);
      finalEnd = finalStart.add(Duration(minutes: durationMinutes));
    } else {
      // Default to next nearest 15-minute slot
      final currentMins = now.minute;
      final remainder = 15 - (currentMins % 15);
      final roundedStart = now.add(Duration(minutes: remainder));
      finalStart = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        roundedStart.hour,
        roundedStart.minute,
      );
      finalEnd = finalStart.add(Duration(minutes: durationMinutes));
    }

    // Clean up residual glue words ("for", "at", "on", "in")
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (text.isEmpty) {
      text = 'New Task';
    }

    return ParsedTaskInput(
      title: text,
      startAt: finalStart,
      endAt: finalEnd,
      durationMinutes: durationMinutes,
      priority: priority,
      tag: tag,
    );
  }
}
