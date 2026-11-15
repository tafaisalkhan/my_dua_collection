import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

String recitationDayKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

class DailyRecitationLog {
  const DailyRecitationLog({required this.firstDay, required this.answers});

  final String firstDay;
  final Map<String, bool> answers;

  bool? answerFor(DateTime date) => answers[recitationDayKey(date)];
}

final dailyRecitationProvider =
    AsyncNotifierProvider<DailyRecitationController, DailyRecitationLog>(
      DailyRecitationController.new,
    );

class DailyRecitationController extends AsyncNotifier<DailyRecitationLog> {
  static const _firstDayKey = 'recitation_first_day';
  static const _answersKey = 'recitation_daily_answers';

  @override
  Future<DailyRecitationLog> build() async {
    final prefs = await SharedPreferences.getInstance();
    final firstDay =
        prefs.getString(_firstDayKey) ?? recitationDayKey(DateTime.now());
    if (!prefs.containsKey(_firstDayKey)) {
      await prefs.setString(_firstDayKey, firstDay);
    }
    final saved = prefs.getString(_answersKey);
    final decoded = saved == null
        ? <String, dynamic>{}
        : jsonDecode(saved) as Map<String, dynamic>;
    return DailyRecitationLog(
      firstDay: firstDay,
      answers: decoded.map((key, value) => MapEntry(key, value == true)),
    );
  }

  Future<void> record(DateTime date, bool recited) async {
    final current = state.value ?? await future;
    final answers = Map<String, bool>.of(current.answers);
    answers[recitationDayKey(date)] = recited;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_answersKey, jsonEncode(answers));
    state = AsyncData(
      DailyRecitationLog(firstDay: current.firstDay, answers: answers),
    );
  }
}
