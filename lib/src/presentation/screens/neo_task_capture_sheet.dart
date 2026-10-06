import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/neo_colors.dart';
import '../../core/theme/neo_shadows.dart';
import '../../core/theme/neo_typography.dart';
import '../../core/utils/natural_language_parser.dart';
import '../../core/widgets/neo_button.dart';
import '../../data/models/task_model.dart';
import '../providers/providers.dart';

class NeoTaskCaptureSheet extends ConsumerStatefulWidget {
  const NeoTaskCaptureSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NeoTaskCaptureSheet(),
    );
  }

  @override
  ConsumerState<NeoTaskCaptureSheet> createState() => _NeoTaskCaptureSheetState();
}

class _NeoTaskCaptureSheetState extends ConsumerState<NeoTaskCaptureSheet> {
  final TextEditingController _textController = TextEditingController();
  ParsedTaskInput? _parsed;
  bool _showAdvanced = false;
  int _selectedDuration = 30;
  int _selectedPriority = 1;
  int _selectedReminderOffset = 10;
  String _customTag = '';

  // Explicit Form Control Overrides bound to pickers
  DateTime? _overrideStartDate;
  TimeOfDay? _overrideStartTime;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
    _onTextChanged();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _textController.text;
    final parsed = NaturalLanguageTaskParser.parse(text);
    setState(() {
      _parsed = parsed;
      _validationError = null;
      if (_overrideStartDate == null) {
        _selectedDuration = parsed.durationMinutes;
        _selectedPriority = parsed.priority;
        if (parsed.tag != null) {
          _customTag = parsed.tag!;
        }
      }
    });
  }

  DateTime _getEffectiveStart() {
    final baseDate = _overrideStartDate ?? _parsed?.startAt ?? DateTime.now();
    final time = _overrideStartTime ??
        TimeOfDay.fromDateTime(_parsed?.startAt ?? DateTime.now());
    return DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      time.hour,
      time.minute,
    );
  }

  DateTime _getEffectiveEnd() {
    final start = _getEffectiveStart();
    return start.add(Duration(minutes: _selectedDuration));
  }

  Future<void> _pickDate(BuildContext context) async {
    final current = _getEffectiveStart();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.neo.accentYellow,
              onPrimary: Colors.black,
              surface: context.neo.surface,
              onSurface: context.neo.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _overrideStartDate = picked;
        _validationError = null;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final current = _getEffectiveStart();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.neo.accentYellow,
              onPrimary: Colors.black,
              surface: context.neo.surface,
              onSurface: context.neo.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _overrideStartTime = picked;
        _validationError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.neo;
    final parsed = _parsed;

    final effectiveStart = _getEffectiveStart();
    final effectiveEnd = _getEffectiveEnd();

    final dateStr = DateFormat('EEE, MMM d').format(effectiveStart);
    final timeStr =
        '${DateFormat('h:mm a').format(effectiveStart)} – ${DateFormat('h:mm a').format(effectiveEnd)}';

    return Container(
      decoration: BoxDecoration(
        color: colors.canvas,
        border: Border(
          top: BorderSide(color: colors.border, width: 4),
          left: BorderSide(color: colors.border, width: 3),
          right: BorderSide(color: colors.border, width: 3),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        24 + MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: colors.border,
                border: Border.all(color: colors.border, width: 1),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.accentYellow,
                  border: Border.all(color: colors.border, width: 2),
                ),
                child: Text(
                  'FAST CAPTURE',
                  style: NeoTypography.label(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colors.accentRed,
                    border: Border.all(color: colors.border, width: 2),
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Main Natural Language Input Field
          TextField(
            controller: _textController,
            autofocus: true,
            style: NeoTypography.headline(
              color: colors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: 'e.g. "Study physics tomorrow 7 to 9 #college !high"',
              hintStyle: NeoTypography.body(
                color: colors.textSecondary.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              filled: true,
              fillColor: colors.surface,
              contentPadding: const EdgeInsets.all(16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: colors.border, width: 3.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: colors.accentYellow, width: 3.5),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Live Smart Detection & Interactive Bound Form Controls
          if (parsed != null && _textController.text.trim().isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.accentViolet.withValues(alpha: 0.2),
                border: Border.all(color: colors.border, width: 2.5),
                boxShadow: NeoShadows.small(colors.shadow),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, size: 16, color: Colors.black),
                      const SizedBox(width: 6),
                      Text(
                        'SMART DETECTION (TAP CHIP TO EDIT):',
                        style: NeoTypography.label(
                          color: colors.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      // Interactive Bound Date Chip
                      _interactiveChip(
                        context,
                        label: '📅 $dateStr',
                        bg: colors.accentYellow,
                        onTap: () => _pickDate(context),
                      ),
                      // Interactive Bound Time Range Chip
                      _interactiveChip(
                        context,
                        label: '⏰ $timeStr',
                        bg: colors.surface,
                        onTap: () => _pickTime(context),
                      ),
                      // Interactive Bound Duration Chip
                      _interactiveChip(
                        context,
                        label: '⏳ ${_selectedDuration}M',
                        bg: colors.surface,
                        onTap: () {
                          setState(() {
                            // Cycle duration 15 -> 30 -> 45 -> 60 -> 90 -> 120
                            final next = switch (_selectedDuration) {
                              15 => 30,
                              30 => 45,
                              45 => 60,
                              60 => 90,
                              90 => 120,
                              _ => 30,
                            };
                            _selectedDuration = next;
                          });
                        },
                      ),
                      if (_customTag.isNotEmpty)
                        _chipBadge(context, '#$_customTag', colors.accentViolet),
                      if (_selectedPriority == 2)
                        _chipBadge(context, '🔥 HIGH PRIORITY', colors.accentRed),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          if (_validationError != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              color: colors.accentRed,
              child: Text(
                '⚠️ $_validationError',
                style: NeoTypography.label(color: Colors.white, fontSize: 11),
              ),
            ),
            const SizedBox(height: 10),
          ],

          // Quick Duration Selectors
          Row(
            children: [
              Text(
                'DURATION:',
                style: NeoTypography.label(color: colors.textSecondary, fontSize: 11),
              ),
              const SizedBox(width: 8),
              ...[15, 30, 45, 60, 90].map((mins) {
                final isSel = _selectedDuration == mins;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDuration = mins;
                      _validationError = null;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSel ? colors.accentYellow : colors.surface,
                      border: Border.all(color: colors.border, width: isSel ? 2.5 : 1.5),
                    ),
                    child: Text(
                      '${mins}M',
                      style: NeoTypography.label(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: isSel ? FontWeight.w900 : FontWeight.w700,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),

          // Advanced Options Accordion Toggle
          GestureDetector(
            onTap: () => setState(() => _showAdvanced = !_showAdvanced),
            child: Row(
              children: [
                Icon(
                  _showAdvanced ? Icons.remove : Icons.add,
                  size: 16,
                  color: colors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  _showAdvanced ? 'HIDE OPTIONS' : 'MORE OPTIONS (P1/P2/P3 & REMINDERS)',
                  style: NeoTypography.label(
                    color: colors.textSecondary,
                    fontSize: 11,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),

          if (_showAdvanced) ...[
            const SizedBox(height: 12),
            // Priority Selector (P1 Critical, P2 Important, P3 Normal)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text('PRIORITY:', style: NeoTypography.label(color: colors.textSecondary, fontSize: 11)),
                  const SizedBox(width: 8),
                  _priorityButton(context, 2, 'P1 CRITICAL', colors.accentRed),
                  const SizedBox(width: 6),
                  _priorityButton(context, 1, 'P2 IMPORTANT', colors.accentYellow),
                  const SizedBox(width: 6),
                  _priorityButton(context, 0, 'P3 NORMAL', colors.surface),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Reminder Selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text('REMIND:', style: NeoTypography.label(color: colors.textSecondary, fontSize: 11)),
                  const SizedBox(width: 8),
                  ...[0, 5, 10, 15, 30].map((offset) {
                    final isSel = _selectedReminderOffset == offset;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedReminderOffset = offset),
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSel ? colors.accentYellow : colors.surface,
                          border: Border.all(color: colors.border, width: isSel ? 2.5 : 1.5),
                        ),
                        child: Text(
                          offset == 0 ? 'AT TIME' : '${offset}M',
                          style: NeoTypography.label(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: isSel ? FontWeight.w900 : FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],

          const SizedBox(height: 18),

          // Save Button
          NeoButton(
            text: 'SAVE TO PLAN →',
            variant: NeoButtonVariant.accentRed,
            isFullWidth: true,
            fontSize: 15,
            padding: const EdgeInsets.symmetric(vertical: 16),
            onPressed: () async {
              final text = _textController.text.trim();
              if (text.isEmpty) return;

              final parsedResult = NaturalLanguageTaskParser.parse(text);

              // Calculate start and end with explicit picker values
              final startAt = _getEffectiveStart();
              final endAt = _getEffectiveEnd();

              // Explicit validation: end time must be after start time
              if (!endAt.isAfter(startAt)) {
                setState(() {
                  _validationError = 'End time must be after start time.';
                });
                return;
              }

              final task = TaskModel()
                ..title = parsedResult.title.isNotEmpty ? parsedResult.title : text
                ..startAt = startAt
                ..endAt = endAt
                ..priority = _selectedPriority
                ..reminderOffsetMinutes = _selectedReminderOffset
                ..checklist = [
                  ChecklistItemModel(
                    text: 'Complete ${parsedResult.title.isNotEmpty ? parsedResult.title : text}',
                    isChecked: false,
                  ),
                ];

              if (_customTag.isNotEmpty) {
                task.tag = TaskTagModel(
                  name: _customTag,
                  colorValue: colors.accentViolet.toARGB32(),
                );
              }

              await ref.read(plannerActionsProvider).saveTask(task);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _interactiveChip(
    BuildContext context, {
    required String label,
    required Color bg,
    required VoidCallback onTap,
  }) {
    final colors = context.neo;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: colors.border, width: 2.5),
          boxShadow: NeoShadows.small(colors.shadow),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.toUpperCase(),
              style: NeoTypography.label(
                color: bg == colors.accentRed ? Colors.white : Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.edit,
              size: 12,
              color: bg == colors.accentRed ? Colors.white : Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipBadge(BuildContext context, String text, Color bg) {
    final colors = context.neo;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: colors.border, width: 2),
      ),
      child: Text(
        text.toUpperCase(),
        style: NeoTypography.label(
          color: bg == colors.accentRed ? Colors.white : Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _priorityButton(BuildContext context, int level, String label, Color bg) {
    final colors = context.neo;
    final isSel = _selectedPriority == level;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPriority = level),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSel ? bg : colors.surface,
            border: Border.all(
              color: colors.border,
              width: isSel ? 2.5 : 1.5,
            ),
            boxShadow: isSel ? NeoShadows.small(colors.shadow) : null,
          ),
          child: Center(
            child: Text(
              label,
              style: NeoTypography.label(
                color: (isSel && bg == colors.accentRed) ? Colors.white : Colors.black,
                fontSize: 11,
                fontWeight: isSel ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
