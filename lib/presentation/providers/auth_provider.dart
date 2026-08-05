import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/supabase_auth_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:fpdart/fpdart.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(() => AuthNotifier());

class AuthNotifier extends AsyncNotifier<User?> {
  late final AuthRepository _repo;

  @override
  Future<User?> build() async {
    final client = supabase.Supabase.instance.client;
    _repo = AuthRepositoryImpl(SupabaseAuthDataSource(client));
    final result = await _repo.getCurrentUser();
    return result.fold((l) => null, (r) => r);
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    final result = await _repo.signIn(email: email, password: password);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (user) => state = AsyncData(user),
    );
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    final result = await _repo.signUp(email: email, password: password);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (user) => state = AsyncData(user),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    final result = await _repo.signOut();
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) => state = const AsyncData(null),
    );
  }
}
