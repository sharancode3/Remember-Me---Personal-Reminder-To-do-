class WeeklyProductivity {
  const WeeklyProductivity({
    required this.totalScheduledMinutes,
    required this.totalCompletedMinutes,
    required this.completionRatio,
    required this.categoryWiseProductivity,
    required this.mostProductive2HourWindow,
    required this.mostFrequentMissedTimeSlot,
    required this.missedCount,
  });

  final int totalScheduledMinutes;
  final int totalCompletedMinutes;
  final double completionRatio;
  final Map<String, double> categoryWiseProductivity;
  final String mostProductive2HourWindow;
  final String mostFrequentMissedTimeSlot;
  final int missedCount;
}

class BehavioralInsights {
  const BehavioralInsights({
    required this.recurringMissPatterns,
    required this.frequentlyRescheduled,
    required this.suggestedWindow,
  });

  final List<String> recurringMissPatterns;
  final List<String> frequentlyRescheduled;
  final String suggestedWindow;
}
