import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
class SettingsScreen extends ConsumerWidget { const SettingsScreen({super.key}); @override Widget build(BuildContext context, WidgetRef ref) { final fr = ref.watch(localeProvider).languageCode == 'fr'; final dark = ref.watch(themeModeProvider) == ThemeMode.dark; return Scaffold(appBar: AppBar(title: Text(fr ? 'Paramètres' : 'Settings')), body: Column(children: [SwitchListTile(title: Text(fr ? 'Français / English' : 'English / Français'), value: fr, onChanged: (_) => ref.read(localeProvider.notifier).toggle(), secondary: const Icon(Icons.language)), SwitchListTile(title: Text(fr ? 'Mode sombre' : 'Dark mode'), value: dark, onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(), secondary: const Icon(Icons.brightness_6))] ); } }
