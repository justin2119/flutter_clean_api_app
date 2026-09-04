import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/supabase_auth_datasource.dart';
import 'package:fpdart/fpdart.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(SupabaseAuthDataSource(supabase.Supabase.instance.client));
});

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<User?> {
  late AuthRepository _repo;

  @override
  Future<User?> build() async {
    _repo = ref.watch(authRepositoryProvider);
    return (await _repo.getCurrentUser()).fold((_) => null, (user) => user);
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    final result = await _repo.signIn(email: email.trim(), password: password);
    result.fold((failure) => state = AsyncError(failure, StackTrace.current), (user) => state = AsyncData(user));
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    final result = await _repo.signUp(email: email.trim(), password: password);
    result.fold((failure) => state = AsyncError(failure, StackTrace.current), (user) => state = AsyncData(user));
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    final result = await _repo.signOut();
    result.fold((failure) => state = AsyncError(failure, StackTrace.current), (_) => state = const AsyncData(null));
  }
}
