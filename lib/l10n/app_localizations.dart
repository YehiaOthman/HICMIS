import 'package:flutter/material.dart';
import 'ar_strings.dart';

final Map<String, String> _arStringsLower = {
  for (final entry in arStrings.entries) entry.key.toLowerCase(): entry.value,
};

extension AppLocalizationsX on BuildContext {
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';

  String tr(Object? key, [List<Object?> args = const []]) {
    var text = key?.toString() ?? '';
    if (isArabic) {
      final trimmed = text.trim();
      if (trimmed.isNotEmpty) {
        final value = arStrings[trimmed] ?? _arStringsLower[trimmed.toLowerCase()];
        if (value != null) text = text.replaceFirst(trimmed, value);
      }
    }
    for (var i = 0; i < args.length; i++) {
      text = text.replaceAll('{$i}', '${args[i] ?? ''}');
    }
    return text;
  }

  String localized(String? en, String? ar, [String fallback = '']) {
    final value = isArabic ? (ar ?? en) : (en ?? ar);
    return value == null || value.isEmpty ? fallback : value;
  }
}
