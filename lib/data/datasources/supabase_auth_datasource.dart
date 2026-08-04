import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthDataSource {
  final SupabaseClient _client;

  SupabaseAuthDataSource(this._client);

  Future<AuthResponse> signUp({required String email, required String password}) async {
    return await _client.auth.signUp(email: email, password: password).timeout(const Duration(seconds: 30));
  }

  Future<AuthResponse> signInWithPassword({required String email, required String password}) async {
    return await _client.auth.signInWithPassword(email: email, password: password).timeout(const Duration(seconds: 30));
  }

  Future<void> signOut() async {
    await _client.auth.signOut().timeout(const Duration(seconds: 30));
  }

  User? getCurrentUser() {
    return _client.auth.currentUser;
  }
}
