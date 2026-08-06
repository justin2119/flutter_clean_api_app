import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:ecommerce_project/data/repositories/auth_repository_impl.dart';
import 'package:ecommerce_project/data/datasources/supabase_auth_datasource.dart';
import 'package:ecommerce_project/domain/entities/user.dart';
import 'package:ecommerce_project/core/error/failures.dart';

class MockSupabaseAuthDataSource extends Mock implements SupabaseAuthDataSource {}
class MockAuthResponse extends Mock implements supabase.AuthResponse {}
class MockSupabaseUser extends Mock implements supabase.User {}

void main() {
  late MockSupabaseAuthDataSource mockDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockSupabaseAuthDataSource();
    repository = AuthRepositoryImpl(mockDataSource);
  });

  group('AuthRepositoryImpl', () {
    const email = 'test@example.com';
    const password = 'password123';

    group('signIn', () {
      test('should return Right(User) when signIn is successful', () async {
        final mockAuthResponse = MockAuthResponse();
        final mockSupabaseUser = MockSupabaseUser();

        when(() => mockSupabaseUser.id).thenReturn('user-id-123');
        when(() => mockSupabaseUser.email).thenReturn(email);
        when(() => mockSupabaseUser.phone).thenReturn('123456');
        when(() => mockSupabaseUser.createdAt).thenReturn('2026-08-05T00:00:00Z');
        when(() => mockSupabaseUser.userMetadata).thenReturn({'name': 'Justin'});
        when(() => mockAuthResponse.user).thenReturn(mockSupabaseUser);

        when(() => mockDataSource.signInWithPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockAuthResponse);

        final result = await repository.signIn(email: email, password: password);

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return Left'),
          (user) {
            expect(user.id, 'user-id-123');
            expect(user.email, email);
            expect(user.phone, '123456');
            expect(user.createdAt, DateTime.parse('2026-08-05T00:00:00Z'));
            expect(user.metadata, {'name': 'Justin'});
          },
        );
        verify(() => mockDataSource.signInWithPassword(email: email, password: password)).called(1);
      });

      test('should return Left(NetworkFailure) on AuthException', () async {
        when(() => mockDataSource.signInWithPassword(
          email: email,
          password: password,
        )).thenThrow(const supabase.AuthException('Invalid credentials'));

        final result = await repository.signIn(email: email, password: password);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<NetworkFailure>());
            expect((failure as NetworkFailure).message, 'Invalid credentials');
          },
          (user) => fail('Should not return Right'),
        );
        verify(() => mockDataSource.signInWithPassword(email: email, password: password)).called(1);
      });
    });

    group('signUp', () {
      test('should return Right(User) when signUp is successful', () async {
        final mockAuthResponse = MockAuthResponse();
        final mockSupabaseUser = MockSupabaseUser();

        when(() => mockSupabaseUser.id).thenReturn('user-id-123');
        when(() => mockSupabaseUser.email).thenReturn(email);
        when(() => mockSupabaseUser.phone).thenReturn('123456');
        when(() => mockSupabaseUser.createdAt).thenReturn('2026-08-05T00:00:00Z');
        when(() => mockSupabaseUser.userMetadata).thenReturn({'name': 'Justin'});
        when(() => mockAuthResponse.user).thenReturn(mockSupabaseUser);

        when(() => mockDataSource.signUp(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockAuthResponse);

        final result = await repository.signUp(email: email, password: password);

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return Left'),
          (user) {
            expect(user.id, 'user-id-123');
            expect(user.email, email);
          },
        );
        verify(() => mockDataSource.signUp(email: email, password: password)).called(1);
      });
    });

    group('signOut', () {
      test('should return Right(unit) when signOut is successful', () async {
        when(() => mockDataSource.signOut()).thenAnswer((_) async => {});

        final result = await repository.signOut();

        expect(result.isRight(), true);
        expect(result, const Right(unit));
        verify(() => mockDataSource.signOut()).called(1);
      });
    });
  });
}
