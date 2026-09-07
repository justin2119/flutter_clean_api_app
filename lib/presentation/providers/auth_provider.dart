import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/supabase_auth_datasource.dart';

final authRepositoryProvider = Provider<AuthRepository?>((ref) {
  try {
    return AuthRepositoryImpl(SupabaseAuthDataSource(supabase.Supabase.instance.client));
  } catch (_) {
    return null;
  }
});

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(AuthNotifier.new);
final authNotifierProvider = authProvider;

class AuthNotifier extends AsyncNotifier<User?> {
  AuthRepository? _repo;

  @override
  Future<User?> build() async {
    _repo = ref.watch(authRepositoryProvider);
    if (_repo == null) return null;
    try {
      return (await _repo!.getCurrentUser()).fold((_) => null, (user) => user);
    } catch (_) {
      return null;
    }
  }

  Future<void> signIn(String email, String password) async {
    final repo = _repo;
    if (repo == null) return;
    state = const AsyncLoading();
    final result = await repo.signIn(email: email.trim(), password: password);
    result.fold((failure) => state = AsyncError(failure, StackTrace.current), (user) => state = AsyncData(user));
  }

  Future<void> signUp(String email, String password) async {
    final repo = _repo;
    if (repo == null) return;
    state = const AsyncLoading();
    final result = await repo.signUp(email: email.trim(), password: password);
    result.fold((failure) => state = AsyncError(failure, StackTrace.current), (user) => state = AsyncData(user));
  }

  Future<void> continueAsGuest() async => state = const AsyncData(null);

  Future<void> signOut() async {
    final repo = _repo;
    if (repo == null) return continueAsGuest();
    state = const AsyncLoading();
    final result = await repo.signOut();
    result.fold((failure) => state = AsyncError(failure, StackTrace.current), (_) => state = const AsyncData(null));
  }
}
