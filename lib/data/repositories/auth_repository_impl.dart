import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../../core/error/failures.dart';
import '../datasources/supabase_auth_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:fpdart/fpdart.dart';
import 'dart:io';

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
      createdAt: DateTime.parse(supabaseUser.createdAt),
      metadata: supabaseUser.userMetadata,
    );
  }

  @override
  Future<Either<Failure, User>> signUp({required String email, required String password}) async {
    try {
      final resp = await _dataSource.signUp(email: email, password: password);
      return Right(_mapSupabaseUser(resp.user));
    } on supabase.AuthException catch (e) {
      return Left(NetworkFailure(e.message));
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signIn({required String email, required String password}) async {
    try {
      final resp = await _dataSource.signInWithPassword(email: email, password: password);
      return Right(_mapSupabaseUser(resp.user));
    } on supabase.AuthException catch (e) {
      return Left(NetworkFailure(e.message));
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(unit);
    } on supabase.AuthException catch (e) {
      return Left(NetworkFailure(e.message));
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final supabaseUser = _dataSource.getCurrentUser();
      return Right(supabaseUser != null ? _mapSupabaseUser(supabaseUser) : null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
