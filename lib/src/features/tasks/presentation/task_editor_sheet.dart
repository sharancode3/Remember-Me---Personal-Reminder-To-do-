import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/ui_helpers.dart';
import '../../../data/models/task_model.dart';
import '../../../presentation/providers/providers.dart';
import '../../../services/reminder_recurrence.dart';

Future<void> showDailyEditor(
  BuildContext context,
  WidgetRef ref, {
  TaskModel? task,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => DailyEditorSheet(
      day: ref.read(dailyDateProvider),
      task: task,
    ),
  );
}

class DailyEditorSheet extends ConsumerStatefulWidget {
  const DailyEditorSheet({super.key, required this.day, this.task});
  final DateTime day;
  final TaskModel? task;

  @override
  ConsumerState<DailyEditorSheet> createState() => _DailyEditorSheetState();
}

class _DailyEditorSheetState extends ConsumerState<DailyEditorSheet> {
  late final TaskModel _draftTask = widget.task ?? TaskModel();
  late final bool _isOccurrence = widget.task != null &&
      widget.task!.templateId != null &&
      widget.task!.templateId != widget.task!.id;
  late EditRecurrenceScope _editScope = EditRecurrenceScope.thisOccurrenceOnly;
  late final TextEditingController _title = TextEditingController(
    text: widget.task?.title,
  );
  late final TextEditingController _note = TextEditingController(
    text: widget.task?.description,
  );
  late DateTime _date = dayOnly(widget.task?.startAt ?? widget.day);
  late TimeOfDay _time = TimeOfDay.fromDateTime(
    widget.task?.startAt ?? DateTime.now().add(const Duration(hours: 1)),
  );
  late bool _reminder =
      widget.task == null || widget.task!.reminderOffsetMinutes >= 0;
  late bool _isAlarmStyle = widget.task?.isAlarmStyle ?? false;
  late int _nagMinutes = widget.task?.nagMinutes ?? 0;
  late String? _placeId = widget.task?.placeId;
  bool _saving = false;
  late RepeatKind _repeat = ReminderRecurrence.decode(
    widget.task?.recurrenceRule ?? 'none',
  ).kind;
  late Set<int> _days = ReminderRecurrence.decode(
    widget.task?.recurrenceRule ?? 'none',
  ).days.toSet();
  bool _timeOpen = false;
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savedPlaces = ref.watch(dailyTrailProvider).places;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          0,
          24,
          MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.task == null ? 'Add something' : 'Edit',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  icon: Icon(Icons.notifications_none),
                  label: Text('Reminder'),
                ),
                ButtonSegment(
                  value: false,
                  icon: Icon(Icons.checklist),
                  label: Text('To-do'),
                ),
              ],
              selected: {_reminder},
              onSelectionChanged: _saving
                  ? null
                  : (value) => setState(() => _reminder = value.first),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
              maxLength: 120,
              decoration: const InputDecoration(labelText: 'What needs doing?'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Note (optional)'),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(DateFormat.yMMMd().format(_date)),
              trailing: const Icon(Icons.chevron_right),
              onTap: _saving
                  ? null
                  : () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (date != null && mounted) setState(() => _date = date);
                    },
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 240),
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  if (_reminder)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.access_time_rounded),
                      title: Text(_time.format(context)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _saving
                          ? null
                          : () => setState(() => _timeOpen = !_timeOpen),
                    ),
                  if (_reminder && _timeOpen)
                    SizedBox(
                      height: 160,
                      child: CupertinoTheme(
                        data: CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle: TextStyle(
                              fontFamily:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.fontFamily ??
                                  'Roboto',
                              fontSize: 20,
                              letterSpacing: 0,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.time,
                          initialDateTime: DateTime(
                            2026,
                            1,
                            1,
                            _time.hour,
                            _time.minute,
                          ),
                          use24hFormat: MediaQuery.alwaysUse24HourFormatOf(
                            context,
                          ),
                          onDateTimeChanged: (time) => setState(
                            () => _time = TimeOfDay.fromDateTime(time),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            DropdownButtonFormField<RepeatKind>(
              isExpanded: true,
              initialValue: _repeat,
              decoration: const InputDecoration(
                labelText: 'Repeat',
                prefixIcon: Icon(Icons.repeat),
              ),
              items: RepeatKind.values
                  .map(
                    (kind) => DropdownMenuItem(
                      value: kind,
                      child: Text(switch (kind) {
                        RepeatKind.none => 'Does not repeat',
                        RepeatKind.daily => 'Every day',
                        RepeatKind.weekly => 'Days of the week',
                        RepeatKind.monthly => 'Dates of the month',
                      }),
                    ),
                  )
                  .toList(),
              onChanged: _saving
                  ? null
                  : (kind) => setState(() {
                      _repeat = kind!;
                      _days = {
                        kind == RepeatKind.weekly ? _date.weekday : _date.day,
                      };
                    }),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 240),
              child: _repeat == RepeatKind.weekly || _repeat == RepeatKind.monthly
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: List.generate(
                          _repeat == RepeatKind.weekly ? 7 : 31,
                          (index) {
                            final day = index + 1;
                            return FilterChip(
                              label: Text(
                                _repeat == RepeatKind.weekly
                                    ? [
                                        'Mon',
                                        'Tue',
                                        'Wed',
                                        'Thu',
                                        'Fri',
                                        'Sat',
                                        'Sun',
                                      ][index]
                                    : '$day',
                              ),
                              selected: _days.contains(day),
                              onSelected: _saving
                                  ? null
                                  : (value) => setState(
                                      () => value
                                          ? _days.add(day)
                                          : _days.remove(day),
                                    ),
                            );
                          },
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            if (_reminder) ...[
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Alarm-style (wake screen)'),
                subtitle: const Text('Plays alarm sound and wakes screen with alert'),
                value: _isAlarmStyle,
                onChanged: _saving ? null : (v) => setState(() => _isAlarmStyle = v),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                isExpanded: true,
                initialValue: _nagMinutes,
                decoration: const InputDecoration(
                  labelText: 'Nag until done',
                  prefixIcon: Icon(Icons.repeat_one),
                ),
                items: const [
                  DropdownMenuItem(value: 0, child: Text('Off (fire once)')),
                  DropdownMenuItem(value: 1, child: Text('Repeat every 1 min until done')),
                  DropdownMenuItem(value: 5, child: Text('Repeat every 5 min until done')),
                  DropdownMenuItem(value: 10, child: Text('Repeat every 10 min until done')),
                ],
                onChanged: _saving ? null : (v) => setState(() => _nagMinutes = v ?? 0),
              ),
            ],
            if (savedPlaces.isNotEmpty) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                isExpanded: true,
                initialValue: savedPlaces.any((p) => p.id == _placeId) ? _placeId : null,
                decoration: const InputDecoration(
                  labelText: 'Linked Place (Proximity alert)',
                  prefixIcon: Icon(Icons.place_outlined),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('No place linked'),
                  ),
                  ...savedPlaces.map(
                    (p) => DropdownMenuItem<String?>(
                      value: p.id,
                      child: Text('${p.name} (${p.radius.toInt()}m)'),
                    ),
                  ),
                ],
                onChanged: _saving ? null : (v) => setState(() => _placeId = v),
              ),
            ],
            if (_isOccurrence) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<EditRecurrenceScope>(
                isExpanded: true,
                initialValue: _editScope,
                decoration: const InputDecoration(
                  labelText: 'Apply changes to',
                  prefixIcon: Icon(Icons.edit_calendar),
                ),
                items: const [
                  DropdownMenuItem(
                    value: EditRecurrenceScope.thisOccurrenceOnly,
                    child: Text('This occurrence only'),
                  ),
                  DropdownMenuItem(
                    value: EditRecurrenceScope.thisAndFuture,
                    child: Text('This and future occurrences'),
                  ),
                  DropdownMenuItem(
                    value: EditRecurrenceScope.all,
                    child: Text('All occurrences (series)'),
                  ),
                ],
                onChanged: _saving ? null : (v) => setState(() => _editScope = v ?? EditRecurrenceScope.thisOccurrenceOnly),
              ),
            ],
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
                label: Text(_saving ? 'Saving...' : 'Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    final start = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _reminder ? _time.hour : 0,
      _reminder ? _time.minute : 0,
    );
    if (title.isEmpty) {
      setState(() => _error = 'Add a name first.');
      return;
    }
    if ((_repeat == RepeatKind.weekly || _repeat == RepeatKind.monthly) &&
        _days.isEmpty) {
      setState(() => _error = 'Choose at least one day.');
      return;
    }
    if (_reminder &&
        _repeat == RepeatKind.none &&
        !start.isAfter(DateTime.now()) &&
        widget.task?.status != TaskStatus.completed) {
      setState(() => _error = 'Choose a future time for the notification.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      if (_reminder) {
        await ref.read(localNotificationServiceProvider).requestPermissions();
      }
      final task = _draftTask;
      task
        ..title = title
        ..description = _note.text.trim()
        ..startAt = start
        ..endAt = start.add(const Duration(minutes: 1))
        ..reminderOffsetMinutes = _reminder ? 0 : -1
        ..isAlarmStyle = _isAlarmStyle
        ..nagMinutes = _nagMinutes
        ..placeId = _placeId
        ..recurrenceRule = ReminderRecurrence(
          kind: _repeat,
          days: _days.toList(),
        ).encode();
      await ref.read(dailyRepositoryProvider).save(task, scope: _editScope);
      await ref.read(dailyRepositoryProvider).syncTasksByPlace();
      ref.read(dailyDateProvider.notifier).state = _date;
      ref.invalidate(dailyCountsProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = readableError(e);
          _saving = false;
        });
      }
    }
  }
}
