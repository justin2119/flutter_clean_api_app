import 'package:flutter/material.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override State<SettingsScreen> createState() => _SettingsScreenState();
}
class _SettingsScreenState extends State<SettingsScreen> {
  bool french = true;
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Settings')), body: SwitchListTile(title: const Text('Français / English'), value: french, onChanged: (value) => setState(() => french = value), secondary: const Icon(Icons.language), activeColor: const Color(0xFF4CAF50),),);
}
