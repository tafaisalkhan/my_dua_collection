import 'package:flutter/material.dart';

abstract final class DuaPalette {
  static const colors = <Color>[
    Color(0xFFFFDDE5),
    Color(0xFFFFEDB8),
    Color(0xFFD4F2DD),
    Color(0xFFD9E5FF),
    Color(0xFFE8D8FA),
    Color(0xFFCFF1EE),
    Color(0xFFFFDFC7),
    Color(0xFFF3D8EC),
    Color(0xFFE0EDC5),
    Color(0xFFD7EAF3),
  ];

  static Color forKey(String key) {
    final value = key.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
    return colors[value % colors.length];
  }

  static Color forCategory(String name) {
    final normalized = name.trim().toLowerCase();
    if (normalized == 'morning') return const Color(0xFFD9E8FF);
    if (normalized == 'evening') return const Color(0xFFFFEDB8);
    if (normalized == 'night' || normalized == 'before sleep') {
      return const Color(0xFFDCD9F8);
    }
    if (normalized.contains('prayer') || normalized.contains('mosque')) {
      return const Color(0xFFD4F2DD);
    }
    return forKey(normalized);
  }
}
