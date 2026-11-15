import 'package:favorite_dua/features/recitation/data/daily_recitation_log.dart';
import 'package:favorite_dua/features/recitation/presentation/daily_recitation_report_screen.dart';
import 'package:favorite_dua/features/settings/presentation/controllers/reminder_controller.dart';
import 'package:favorite_dua/core/notifications/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('calendar shows missed days and marks today done', (
    tester,
  ) async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    SharedPreferences.setMockInitialValues({
      'recitation_first_day': recitationDayKey(yesterday),
    });
    final container = ProviderContainer(
      overrides: [
        notificationServiceProvider.overrideWithValue(_FakeNotifications()),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: DailyRecitationReportScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Missed: 1'), findsOneWidget);

    await tester.tap(find.text('Mark today as read'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Done: 1'), findsOneWidget);
    expect(
      container.read(dailyRecitationProvider).value!.answerFor(DateTime.now()),
      isTrue,
    );

    final saved = await SharedPreferences.getInstance();
    expect(saved.getString('recitation_daily_answers'), contains('true'));
  });

  test('No is distinct from a missing answer', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(dailyRecitationProvider.notifier);
    final day = DateTime(2026, 11, 7);
    await controller.record(day, false);

    final log = container.read(dailyRecitationProvider).value!;
    expect(log.answerFor(day), isFalse);
    expect(log.answerFor(day.add(const Duration(days: 1))), isNull);
  });

  test('reminder times can be added, changed and removed', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer(
      overrides: [
        notificationServiceProvider.overrideWithValue(_FakeNotifications()),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(reminderControllerProvider.notifier);
    expect(
      (await container.read(reminderControllerProvider.future)).minutesOfDay,
      [23 * 60],
    );
    await controller.addTime(8, 30);
    await controller.updateTime(23 * 60, 22, 15);
    await controller.removeTime(8 * 60 + 30);
    expect(container.read(reminderControllerProvider).value!.minutesOfDay, [
      22 * 60 + 15,
    ]);
  });
}

class _FakeNotifications implements NotificationService {
  @override
  Future<void> initialize() async {}
  @override
  Future<bool> requestPermission() async => true;
  @override
  Future<void> scheduleDaily({required int hour, required int minute}) async {}
  @override
  Future<void> cancelDaily() async {}
  @override
  Future<void> scheduleRecitationReminders({
    required List<int> minutesOfDay,
    required Set<String> completedDays,
  }) async {}
  @override
  Future<void> cancelRecitationReminders() async {}
}
