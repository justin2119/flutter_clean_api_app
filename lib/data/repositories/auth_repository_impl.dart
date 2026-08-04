import '../../domain/repositories/auth_repository.dart';
import '../datasources/supabase_auth_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<AuthResponse> signUp({required String email, required String password}) {
    return _dataSource.signUp(email: email, password: password);
  }

  @override
  Future<AuthResponse> signIn({required String email, required String password}) {
    return _dataSource.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() {
    return _dataSource.signOut();
  }

  @override
  User? getCurrentUser() {
    return _dataSource.getCurrentUser();
  }
}
