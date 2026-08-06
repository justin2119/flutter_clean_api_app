import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/providers/auth_provider.dart';
import 'signup_screen.dart';
import '../widgets/custom_button.dart';

// ConsumerStatefulWidget combine le cycle de vie StatefulWidget avec l'accès à Riverpod.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

// ConsumerState fournit ref pour lire le notifier et setState pour l'état visuel local.
class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Chaque contrôleur conserve et expose le texte saisi par son TextField.
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  // Cet état local ne remplace pas Riverpod : il contrôle seulement le bouton de l'écran.
  bool _isLoading = false;

  @override
  void dispose() {
    // Libérer les contrôleurs évite de conserver des ressources après la destruction de la route.
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // Lit les valeurs saisies puis invoque la méthode exposée par le provider d'authentification.
  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    await ref.read(authProvider.notifier).signIn(_emailCtrl.text, _passwordCtrl.text);
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
              Text('Login', style: GoogleFonts.abel(color: Colors.white, fontSize: 28)),
              const SizedBox(height: 24),
              TextField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  hintText: 'Email',
                  // Abel est appliquée aux textes indicatifs et aux caractères saisis.
                  hintStyle: GoogleFonts.abel(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white12,
                  // BorderRadius.zero impose le Style Carré sans arrondi implicite.
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
                      label: 'Sign In',
                      onPressed: _signIn,
                    ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignUpScreen())),
                child: Text('Don\'t have an account? Sign Up', style: GoogleFonts.abel(color: Colors.white70)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
