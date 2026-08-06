import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/providers/auth_provider.dart';
import 'login_screen.dart';
import '../screens/home_screen.dart';

// ConsumerWidget donne accès à WidgetRef afin d'observer l'état Riverpod sans état local.
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // authProvider expose un AsyncValue<User?> : l'état peut être en chargement,
    // contenir un utilisateur, contenir null, ou représenter une erreur.
    final authState = ref.watch(authProvider);
    // Ce AsyncValue agit comme un garde de navigation déclaratif : chaque branche
    // associe un état d'authentification à l'écran autorisé correspondant.
    return authState.when(
      // Un utilisateur authentifié accède à HomeScreen ; null renvoie vers LoginScreen.
      data: (user) => user != null ? const HomeScreen() : const LoginScreen(),
      // Pendant la résolution de la session, on évite d'afficher prématurément une route.
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      // L'erreur est rendue dans la même arborescence réactive, avec la police du produit.
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e', style: GoogleFonts.abel(color: Colors.white)))),
    );
  }
}
