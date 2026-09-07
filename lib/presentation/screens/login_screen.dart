import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/providers/auth_provider.dart';
import 'signup_screen.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() { _emailCtrl.dispose(); _passwordCtrl.dispose(); super.dispose(); }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    await ref.read(authProvider.notifier).signIn(_emailCtrl.text, _passwordCtrl.text);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF263238),
    body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('Login', style: GoogleFonts.abel(color: Colors.white, fontSize: 28)),
      const SizedBox(height: 24),
      _field(_emailCtrl, 'Email', false, TextInputType.emailAddress),
      const SizedBox(height: 16),
      _field(_passwordCtrl, 'Password', true, TextInputType.text),
      const SizedBox(height: 24),
      _isLoading ? const CircularProgressIndicator(color: Color(0xFF4CAF50)) : CustomButton(label: 'Sign In', onPressed: _signIn),
      TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignUpScreen())), child: Text("Don't have an account? Sign Up", style: GoogleFonts.abel(color: Colors.white70))),
      OutlinedButton(onPressed: () => ref.read(authProvider.notifier).continueAsGuest(), style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF4CAF50), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)), child: Text('Continue as guest', style: GoogleFonts.abel())),
    ]))),
  );

  Widget _field(TextEditingController controller, String hint, bool obscure, TextInputType type) => TextField(
    controller: controller, obscureText: obscure, keyboardType: type, style: GoogleFonts.abel(color: Colors.white),
    decoration: InputDecoration(hintText: hint, hintStyle: GoogleFonts.abel(color: Colors.white70), filled: true, fillColor: Colors.white12, border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none)),
  );
}
