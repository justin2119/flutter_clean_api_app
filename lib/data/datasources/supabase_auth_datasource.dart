// Cette datasource est le seul endroit qui connaît directement Supabase.
import 'package:supabase_flutter/supabase_flutter.dart'; // Types et client du SDK Supabase.

// Elle encapsule les appels réseau d'authentification.
class SupabaseAuthDataSource {
  // Client utilisé pour accéder au service auth de Supabase.
  final SupabaseClient _client;

  // Injection du client : cela facilite le remplacement et les tests.
  SupabaseAuthDataSource(this._client);

  // Future<AuthResponse> signifie qu'un AuthResponse arrivera plus tard.
  // Les paramètres required obligent l'appelant à fournir email et password.
  Future<AuthResponse> signUp({required String email, required String password}) async {
    // auth.signUp envoie les identifiants à Supabase.
    // timeout limite l'attente à 30 secondes pour éviter un chargement infini.
    return await _client.auth.signUp(email: email, password: password).timeout(const Duration(seconds: 30));
  }

  // Connexion d'un utilisateur déjà inscrit avec son mot de passe.
  Future<AuthResponse> signInWithPassword({required String email, required String password}) async {
    // Le SDK renvoie AuthResponse ; le timeout protège l'expérience utilisateur.
    return await _client.auth.signInWithPassword(email: email, password: password).timeout(const Duration(seconds: 30));
  }

  // Future<void> indique une opération asynchrone sans valeur de retour.
  Future<void> signOut() async {
    // On attend la fin de la déconnexion et on applique le même délai maximal.
    await _client.auth.signOut().timeout(const Duration(seconds: 30));
  }

  // Lecture immédiate de la session en mémoire ; User? autorise l'absence de session.
  User? getCurrentUser() {
    // currentUser vaut null lorsqu'aucun utilisateur n'est connecté.
    return _client.auth.currentUser;
  }
}
