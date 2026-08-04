import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/login_screen.dart';

/// Root widget that defines the navigation and global providers.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Add auth state provider to decide initial screen
    return MaterialApp(
      title: 'Flutter Clean API App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF263238),
        useMaterial3: false,
      ),
      // Placeholder navigation – replace with proper routing later
      home: const LoginScreen(),
      routes: {
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
