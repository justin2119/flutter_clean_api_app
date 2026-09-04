import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/locale_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isFrench = locale.languageCode == 'fr';
    return Scaffold(
      appBar: AppBar(title: Text(isFrench ? 'Paramètres' : 'Settings')),
      body: SwitchListTile(
        title: Text(isFrench ? 'Français / English' : 'English / Français'),
        value: isFrench,
        onChanged: (_) => ref.read(localeProvider.notifier).toggle(),
        secondary: const Semantics(
          label: 'Language',
          child: Icon(Icons.language),
        ),
        activeColor: const Color(0xFF4CAF50),
      ),
    );
  }
}
