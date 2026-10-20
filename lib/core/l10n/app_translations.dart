import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/shared_prefs_service.dart';

class LocaleController extends ChangeNotifier {
  LocaleController._();

  static final LocaleController instance = LocaleController._();

  String _language = 'uz';

  String get language => _language;

  Locale get locale => Locale(_language);

  Future<void> load() async {
    try {
      final prefs = await SharedPrefsService.getInstance();
      _language = prefs.getLanguage() ?? 'uz';
      notifyListeners();
    } catch (_) {
      _language = 'uz';
    }
  }

  Future<void> setLanguage(String code) async {
    if (_language == code) return;
    _language = code;
    notifyListeners();
    try {
      final prefs = await SharedPrefsService.getInstance();
      await prefs.saveLanguage(code);
    } catch (_) {}
  }
}

class Tr {
  Tr._();

  static final Map<String, Map<String, String>> _translations = {
    'uz': {},
    'en': {},
  };

  static bool _loaded = false;

  static Future<void> ensureLoaded() async {
    if (_loaded) return;
    try {
      final uzJson = await rootBundle.loadString('assets/translations/uz.json');
      final enJson = await rootBundle.loadString('assets/translations/en.json');
      _translations['uz'] = Map<String, String>.from(json.decode(uzJson));
      _translations['en'] = Map<String, String>.from(json.decode(enJson));
      _loaded = true;
    } catch (e) {
      // Fallback to empty maps if loading fails
      _translations['uz'] = {};
      _translations['en'] = {};
      _loaded = true;
    }
  }

  static String t(String key, [Map<String, String>? args]) {
    if (!_loaded) {
      // This shouldn't happen in normal usage, but handle gracefully
      return key;
    }
    final lang = LocaleController.instance.language;
    var text = _translations[lang]?[key] ?? _translations['uz']?[key] ?? key;
    if (args != null) {
      args.forEach((k, v) => text = text.replaceAll('{$k}', v));
    }
    return text;
  }

  static String categoryName(String value) {
    switch (value.trim().toLowerCase()) {
      case 'texnik':
      case 'texnika':
      case 'technical':
      case 'technique':
        return t('categoryTechnical');
      case 'ujt':
        return t('categoryUjt');
      case 'mjt':
        return t('categoryMjt');
      default:
        return value;
    }
  }

  static String categoryKey(String value) {
    switch (value.trim().toLowerCase()) {
      case 'texnik':
      case 'texnika':
      case 'technical':
      case 'technique':
        return 'technical';
      case 'ujt':
        return 'ujt';
      case 'mjt':
        return 'mjt';
      default:
        return value.trim().toLowerCase();
    }
  }
}
