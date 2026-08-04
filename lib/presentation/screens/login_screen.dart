import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/custom_button.dart';
import '../../domain/usecases/auth_login.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Placeholder UI – implement Supabase auth login flow here
    return Scaffold(
      body: Center(
        child: CustomButton(
          label: 'Login with Supabase',
          onPressed: () async {
            // TODO: call AuthLogin use‑case
          },
        ),
      ),
    );
  }
}
