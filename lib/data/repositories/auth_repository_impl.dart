import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/supabase_auth_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  User _mapSupabaseUser(supabase.User? supabaseUser) {
    if (supabaseUser == null) {
      return User(id: '', email: null);
    }
    return User(
      id: supabaseUser.id,
      email: supabaseUser.email,
      phone: supabaseUser.phone,
      createdAt: supabaseUser.createdAt,
      metadata: supabaseUser.userMetadata,
    );
  }

  @override
  Future<User> signUp({required String email, required String password}) async {
    final resp = await _dataSource.signUp(email: email, password: password);
    if (resp.error != null) {
      throw Exception(resp.error!.message);
    }
    return _mapSupabaseUser(resp.user);
  }

  @override
  Future<User> signIn({required String email, required String password}) async {
    final resp = await _dataSource.signInWithPassword(email: email, password: password);
    if (resp.error != null) {
      throw Exception(resp.error!.message);
    }
    return _mapSupabaseUser(resp.user);
  }

  @override
  Future<void> signOut() async {
    await _dataSource.signOut();
  }

  @override
  User? getCurrentUser() {
    final user = _dataSource.getCurrentUser();
    return user != null ? _mapSupabaseUser(user) : null;
  }
}
