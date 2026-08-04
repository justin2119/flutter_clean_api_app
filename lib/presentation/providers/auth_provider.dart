import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/supabase_auth_datasource.dart';
import '../../domain/usecases/sign_in_use_case.dart';
import '../../domain/usecases/sign_up_use_case.dart';
import '../../domain/usecases/sign_out_use_case.dart';

/// Riverpod provider that manages the Supabase authentication state.
final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(() => AuthNotifier());

class AuthNotifier extends AsyncNotifier<User?> {
  late final AuthRepository _repo;
  late final SignInUseCase _signIn;
  late final SignUpUseCase _signUp;
  late final SignOutUseCase _signOut;

  @override
  Future<User?> build() async {
    // Assumes Supabase.initialize has been called in main.dart before runApp.
    final client = Supabase.instance;
    _repo = AuthRepositoryImpl(SupabaseAuthDataSource(client));
    _signIn = SignInUseCase(_repo);
    _signUp = SignUpUseCase(_repo);
    _signOut = SignOutUseCase(_repo);
    return _repo.getCurrentUser();
  }

  /// Sign‑in with email and password.
  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    final resp = await _signIn.call(email: email, password: password);
    if (resp.error != null) {
      state = AsyncError(resp.error!.message);
    } else {
      state = AsyncData(resp.user);
    }
  }

  /// Sign‑up with email and password.
  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    final resp = await _signUp.call(email: email, password: password);
    if (resp.error != null) {
      state = AsyncError(resp.error!.message);
    } else {
      state = AsyncData(resp.user);
    }
  }

  /// Sign‑out the current user.
  Future<void> signOut() async {
    state = const AsyncLoading();
    await _signOut.call();
    state = const AsyncData(null);
  }
}
