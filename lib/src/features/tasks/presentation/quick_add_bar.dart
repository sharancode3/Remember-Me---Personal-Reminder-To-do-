import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/natural_language_parser.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../data/models/task_model.dart';
import '../../../presentation/providers/daily_providers.dart';

class QuickAddBar extends ConsumerStatefulWidget {
  const QuickAddBar({super.key, required this.selectedDate});
  final DateTime selectedDate;

  @override
  ConsumerState<QuickAddBar> createState() => _QuickAddBarState();
}

class _QuickAddBarState extends ConsumerState<QuickAddBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  ParsedTaskInput? _parsed;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      if (_parsed != null) setState(() => _parsed = null);
      return;
    }
    final parsed = NaturalLanguageTaskParser.parse(
      text,
      referenceTime: widget.selectedDate,
    );
    setState(() => _parsed = parsed);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _submitting) return;

    setState(() => _submitting = true);
    try {
      final parsed = NaturalLanguageTaskParser.parse(
        text,
        referenceTime: widget.selectedDate,
      );
      final task = TaskModel()
        ..title = parsed.title.isNotEmpty ? parsed.title : text
        ..startAt = parsed.startAt
        ..endAt = parsed.endAt
        ..priority = parsed.priority
        ..placeId = parsed.tag
        ..reminderOffsetMinutes = 0;

      await ref.read(dailyRepositoryProvider).save(task);
      await ref.read(dailyRepositoryProvider).syncTasksByPlace();
      ref.invalidate(dailyCountsProvider);

      if (mounted) {
        _controller.clear();
        setState(() {
          _parsed = null;
          _submitting = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        showMessage(context, readableError(e));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasPreview = _parsed != null && _controller.text.trim().isNotEmpty;

    final isCurrent = ModalRoute.of(context)?.isCurrent ?? true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCE5E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: isCurrent
                    ? TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        decoration: const InputDecoration(
                          hintText: 'Quick add: "Gym tomorrow 7am #fitness"',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          _controller.text.isNotEmpty
                              ? _controller.text
                              : 'Quick add: "Gym tomorrow 7am #fitness"',
                          style: TextStyle(
                            color: _controller.text.isNotEmpty
                                ? theme.textTheme.bodyMedium?.color
                                : theme.hintColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
              ),
              IconButton(
                icon: _submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        Icons.arrow_upward_rounded,
                        color: theme.colorScheme.primary,
                      ),
                tooltip: 'Add task',
                onPressed: _submit,
              ),
            ],
          ),
          if (hasPreview)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 2),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4F0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 12,
                          color: Color(0xFF107C41),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat.jm().format(_parsed!.startAt),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF107C41),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF2FA),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Color(0xFF3577B5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat.MMMd().format(_parsed!.startAt),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3577B5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_parsed!.tag != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6E8FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.place,
                            size: 12,
                            color: Color(0xFF7B2CBF),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _parsed!.tag!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7B2CBF),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
