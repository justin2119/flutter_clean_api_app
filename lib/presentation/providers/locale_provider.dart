import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('fr'));

  void setLocale(Locale locale) {
    if (locale.languageCode == 'en' || locale.languageCode == 'fr') {
      state = locale;
    }
  }

  void toggle() {
    setLocale(state.languageCode == 'fr' ? const Locale('en') : const Locale('fr'));
  }
}
