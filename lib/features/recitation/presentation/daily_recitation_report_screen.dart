import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/presentation/controllers/reminder_controller.dart';
import '../data/daily_recitation_log.dart';

class DailyRecitationReportScreen extends ConsumerStatefulWidget {
  const DailyRecitationReportScreen({super.key});

  @override
  ConsumerState<DailyRecitationReportScreen> createState() =>
      _DailyRecitationReportScreenState();
}

class _DailyRecitationReportScreenState
    extends ConsumerState<DailyRecitationReportScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  Future<void> _setDay(DateTime day, bool done) async {
    try {
      await ref.read(dailyRecitationProvider.notifier).record(day, done);
      await ref.read(reminderControllerProvider.notifier).refresh();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save this day. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final log = ref.watch(dailyRecitationProvider);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Dua calendar')),
      body: log.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(dailyRecitationProvider),
            child: const Text('Could not load calendar. Retry'),
          ),
        ),
        data: (data) {
          final first = DateTime.parse(data.firstDay);
          final firstDate = DateTime(first.year, first.month, first.day);
          final daysElapsed =
              DateTime.utc(today.year, today.month, today.day)
                  .difference(DateTime.utc(first.year, first.month, first.day))
                  .inDays +
              1;
          var done = 0;
          for (var i = 0; i < daysElapsed; i++) {
            final day = DateTime(first.year, first.month, first.day + i);
            if (data.answerFor(day) == true) done++;
          }
          final missed = daysElapsed > done
              ? daysElapsed - done - (data.answerFor(todayDate) == true ? 0 : 1)
              : 0;
          final firstWeekday = DateTime(_month.year, _month.month).weekday - 1;
          final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
          final cells = firstWeekday + daysInMonth;
          final canGoBack = DateTime(
            _month.year,
            _month.month,
          ).isAfter(DateTime(first.year, first.month));
          final canGoForward = DateTime(
            _month.year,
            _month.month,
          ).isBefore(DateTime(today.year, today.month));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Done: $done   •   Missed: $missed',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              if (data.answerFor(todayDate) != true)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: FilledButton.icon(
                    onPressed: () => _setDay(todayDate, true),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Mark today as read'),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: canGoBack
                        ? () => setState(
                            () => _month = DateTime(
                              _month.year,
                              _month.month - 1,
                            ),
                          )
                        : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text(
                    MaterialLocalizations.of(context).formatMonthYear(_month),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    onPressed: canGoForward
                        ? () => setState(
                            () => _month = DateTime(
                              _month.year,
                              _month.month + 1,
                            ),
                          )
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              Row(
                children: [
                  for (final name in [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ])
                    Expanded(child: Center(child: Text(name))),
                ],
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemCount: cells,
                itemBuilder: (context, index) {
                  final number = index - firstWeekday + 1;
                  if (number < 1) return const SizedBox.shrink();
                  final day = DateTime(_month.year, _month.month, number);
                  final active =
                      !day.isBefore(firstDate) && !day.isAfter(todayDate);
                  final complete = data.answerFor(day) == true;
                  final isToday = day == todayDate;
                  final missedDay = active && !complete && !isToday;
                  return Semantics(
                    label:
                        '${day.day}/${day.month}/${day.year}: '
                        '${complete
                            ? 'done'
                            : missedDay
                            ? 'missed'
                            : 'pending'}',
                    button: active,
                    child: InkWell(
                      onTap: active ? () => _setDay(day, !complete) : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: complete
                              ? Colors.green.withValues(alpha: 0.2)
                              : missedDay
                              ? colors.errorContainer
                              : colors.surfaceContainerHighest,
                          border: isToday
                              ? Border.all(color: colors.primary, width: 2)
                              : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('$number'),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text('Green: done   •   Red: missed   •   Outlined: today'),
              const SizedBox(height: 8),
              const Text('Tap a day to change its status.'),
            ],
          );
        },
      ),
    );
  }
}
