import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/supabase_auth_datasource.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(() => AuthNotifier());

class AuthNotifier extends AsyncNotifier<User?> {
  late final AuthRepository _repo;

  @override
  Future<User?> build() async {
    final client = Supabase.instance;
    _repo = AuthRepositoryImpl(SupabaseAuthDataSource(client));
    return _repo.getCurrentUser();
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      final user = await _repo.signIn(email: email, password: password);
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    try {
      final user = await _repo.signUp(email: email, password: password);
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await _repo.signOut();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
