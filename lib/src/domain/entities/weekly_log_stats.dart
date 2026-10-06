class WeeklyLogStats {
  const WeeklyLogStats({
    required this.total,
    required this.completed,
    required this.pending,
  });

  final int total;
  final int completed;
  final int pending;

  double get completionRate => total == 0 ? 0 : completed / total;
}
