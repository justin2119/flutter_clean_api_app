import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/providers/auth_provider.dart';
import '../widgets/custom_button.dart';

// ConsumerStatefulWidget permet de combiner cycle de vie local et accès à Riverpod.
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

// ConsumerState expose ref pour appeler le notifier d'inscription.
class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  // Les contrôleurs relient le texte saisi aux valeurs envoyées au provider.
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  // État local limité à l'indicateur visuel de cette page.
  bool _isLoading = false;

  @override
  void dispose() {
    // Nettoyage obligatoire des contrôleurs lorsque la route disparaît.
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ref.read récupère le notifier sans abonnement et appelle son opération métier signUp.
  Future<void> _signUp() async {
    setState(() => _isLoading = true);
    await ref.read(authProvider.notifier).signUp(_emailCtrl.text, _passwordCtrl.text);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF263238),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Sign Up', style: GoogleFonts.abel(color: Colors.white, fontSize: 28)),
              const SizedBox(height: 24),
              TextField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  hintText: 'Email',
                  // La typographie Abel est appliquée aux indications et à la saisie.
                  hintStyle: GoogleFonts.abel(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white12,
                  // Style Carré : aucun rayon, même implicite, sur les champs.
                  border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                ),
                style: GoogleFonts.abel(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordCtrl,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: GoogleFonts.abel(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white12,
                  border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                ),
                obscureText: true,
                style: GoogleFonts.abel(color: Colors.white),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : CustomButton(
                      label: 'Create Account',
                      onPressed: _signUp,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
