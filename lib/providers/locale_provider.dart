import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocaleProvider extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  static const _languageKey = 'app_language';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  Future<void> load() async {
    final code = await _storage.read(key: _languageKey);
    if (code == 'ar' || code == 'en') {
      _locale = Locale(code!);
      notifyListeners();
    }
  }

  Future<void> toggle() async {
    _locale = Locale(isArabic ? 'en' : 'ar');
    notifyListeners();
    await _storage.write(key: _languageKey, value: _locale.languageCode);
  }
}
