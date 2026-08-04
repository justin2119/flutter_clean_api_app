import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/auth_wrapper.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Clean API App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF263238),
        useMaterial3: false,
      ),
      home: const AuthWrapper(),
    );
  }
}
