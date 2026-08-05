import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../lib/data/datasources/supabase_auth_datasource.dart';
import '../../lib/data/repositories/auth_repository_impl.dart';
import '../../lib/domain/entities/user.dart' as domain;
import '../../lib/core/error/failures.dart';

class MockSupabaseAuthDataSource extends Mock implements SupabaseAuthDataSource {}

void main() {
  late MockSupabaseAuthDataSource mockDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockSupabaseAuthDataSource();
    repository = AuthRepositoryImpl(mockDataSource);
  });

  test('signIn success returns Right(User)', () async {
    final supabaseUser = supabase.User(
      id: 'uid123',
      appMetadata: {},
      userMetadata: {},
      aud: '',
      confirmationSentAt: null,
      createdAt: DateTime.now(),
      email: 'test@example.com',
      emailConfirmedAt: null,
      phone: null,
      role: '',
      updatedAt: DateTime.now(),
    );
    final response = supabase.AuthResponse(user: supabaseUser, error: null);
    when(() => mockDataSource.signInWithPassword(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => response);

    final result = await repository.signIn(email: 'test@example.com', password: 'pwd');
    expect(result.isRight(), true);
    result.fold((l) => null, (r) {
      expect(r.id, 'uid123');
      expect(r.email, 'test@example.com');
    });
  });

  test('signIn failure returns Left(InvalidCredentialsFailure)', () async {
    final error = supabase.AuthException(message: 'Invalid credentials');
    final response = supabase.AuthResponse(user: null, error: error);
    when(() => mockDataSource.signInWithPassword(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => response);

    final result = await repository.signIn(email: 'bad@example.com', password: 'wrong');
    expect(result.isLeft(), true);
    result.fold((l) => expect(l, isA<InvalidCredentialsFailure>()), (r) => null);
  });

  test('getCurrentUser returns Right(null) when no session', () async {
    when(() => mockDataSource.getCurrentUser()).thenReturn(null);
    final result = await repository.getCurrentUser();
    expect(result.isRight(), true);
    result.fold((l) => null, (r) => expect(r, isNull));
  });
}
