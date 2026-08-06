// dart:io contient les erreurs réseau possibles, notamment SocketException.
import 'dart:io';
// flutter_test fournit test, group, expect et fail.
import 'package:flutter_test/flutter_test.dart';
// mocktail permet de créer des objets simulés et de vérifier leurs appels.
import 'package:mocktail/mocktail.dart';
// Either et Right sont utilisés pour contrôler le résultat du repository.
import 'package:fpdart/fpdart.dart';
// Préfixe supabase pour distinguer les classes du SDK des modèles internes.
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
// Import de la classe réellement testée.
import 'package:ecommerce_project/data/repositories/auth_repository_impl.dart';
// Import de la dépendance que le repository reçoit au constructeur.
import 'package:ecommerce_project/data/datasources/supabase_auth_datasource.dart';
// Import du modèle User du domaine.
import 'package:ecommerce_project/domain/entities/user.dart';
// Import des types d'échec vérifiés dans les assertions.
import 'package:ecommerce_project/core/error/failures.dart';

// Faux datasource : il imite SupabaseAuthDataSource sans appeler Internet.
class MockSupabaseAuthDataSource extends Mock implements SupabaseAuthDataSource {}
// Faux AuthResponse : le test contrôle exactement l'utilisateur renvoyé.
class MockAuthResponse extends Mock implements supabase.AuthResponse {}
// Faux utilisateur Supabase : chaque propriété peut être configurée.
class MockSupabaseUser extends Mock implements supabase.User {}

void main() {
  // late signifie que ces variables seront initialisées avant chaque test.
  late MockSupabaseAuthDataSource mockDataSource;
  late AuthRepositoryImpl repository;

  // setUp est exécuté avant chaque test pour repartir d'un état propre.
  setUp(() {
    // On crée un nouveau faux datasource.
    mockDataSource = MockSupabaseAuthDataSource();
    // Le repository reçoit le faux plutôt qu'un vrai client réseau.
    repository = AuthRepositoryImpl(mockDataSource);
  });

  // group rassemble les tests concernant AuthRepositoryImpl.
  group('AuthRepositoryImpl', () {
    // Constantes partagées par les scénarios d'authentification.
    const email = 'test@example.com';
    const password = 'password123';

    // Sous-groupe consacré à la connexion.
    group('signIn', () {
      // Ce test vérifie le chemin heureux : Supabase renvoie un utilisateur.
      test('should return Right(User) when signIn is successful', () async {
        // On prépare les deux réponses simulées nécessaires.
        final mockAuthResponse = MockAuthResponse();
        final mockSupabaseUser = MockSupabaseUser();

        // Chaque when configure une propriété du faux utilisateur.
        when(() => mockSupabaseUser.id).thenReturn('user-id-123');
        when(() => mockSupabaseUser.email).thenReturn(email);
        when(() => mockSupabaseUser.phone).thenReturn('123456');
        when(() => mockSupabaseUser.createdAt).thenReturn('2026-08-05T00:00:00Z');
        when(() => mockSupabaseUser.userMetadata).thenReturn({'name': 'Justin'});
        // La réponse Supabase contient cet utilisateur.
        when(() => mockAuthResponse.user).thenReturn(mockSupabaseUser);

        // Quand le repository appellera signIn, le mock répondra avec la réponse préparée.
        // thenAnswer est asynchrone car la vraie méthode retourne un Future.
        when(() => mockDataSource.signInWithPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockAuthResponse);

        // await attend le Future du repository.
        final result = await repository.signIn(email: email, password: password);

        // Un résultat Right signifie que la connexion a réussi.
        expect(result.isRight(), true);
        // fold parcourt Left ou Right ; ici Left serait une erreur de test.
        result.fold(
          (failure) => fail('Should not return Left'),
          (user) {
            // Ces assertions vérifient le mapping Supabase -> User du domaine.
            expect(user.id, 'user-id-123');
            expect(user.email, email);
            expect(user.phone, '123456');
            expect(user.createdAt, DateTime.parse('2026-08-05T00:00:00Z'));
            expect(user.metadata, {'name': 'Justin'});
          },
        );
        // verify confirme que l'appel a eu lieu exactement une fois avec les bons arguments.
        verify(() => mockDataSource.signInWithPassword(email: email, password: password)).called(1);
      });

      // Ce test vérifie la conversion d'une erreur d'authentification.
      test('should return Left(NetworkFailure) on AuthException', () async {
        // Le mock lance volontairement la même exception que Supabase.
        when(() => mockDataSource.signInWithPassword(
          email: email,
          password: password,
        )).thenThrow(const supabase.AuthException('Invalid credentials'));

        // Le repository doit intercepter cette exception.
        final result = await repository.signIn(email: email, password: password);

        // Left signifie que l'opération a échoué.
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            // L'exception doit être convertie en NetworkFailure.
            expect(failure, isA<NetworkFailure>());
            // On vérifie que le message original est conservé.
            expect((failure as NetworkFailure).message, 'Invalid credentials');
          },
          (user) => fail('Should not return Right'),
        );
        // Même en cas d'erreur, la datasource doit avoir été appelée une fois.
        verify(() => mockDataSource.signInWithPassword(email: email, password: password)).called(1);
      });
    });

    // Sous-groupe consacré à la création d'un compte.
    group('signUp', () {
      // Vérifie qu'une inscription réussie produit un User interne.
      test('should return Right(User) when signUp is successful', () async {
        final mockAuthResponse = MockAuthResponse();
        final mockSupabaseUser = MockSupabaseUser();

        // Configuration des champs que le repository doit recopier.
        when(() => mockSupabaseUser.id).thenReturn('user-id-123');
        when(() => mockSupabaseUser.email).thenReturn(email);
        when(() => mockSupabaseUser.phone).thenReturn('123456');
        when(() => mockSupabaseUser.createdAt).thenReturn('2026-08-05T00:00:00Z');
        when(() => mockSupabaseUser.userMetadata).thenReturn({'name': 'Justin'});
        when(() => mockAuthResponse.user).thenReturn(mockSupabaseUser);

        // Simulation du Future réussi de signUp.
        when(() => mockDataSource.signUp(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockAuthResponse);

        final result = await repository.signUp(email: email, password: password);

        // Le résultat doit être Right et contenir les données mappées.
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return Left'),
          (user) {
            expect(user.id, 'user-id-123');
            expect(user.email, email);
          },
        );
        // Vérifie les paramètres et le nombre d'appels.
        verify(() => mockDataSource.signUp(email: email, password: password)).called(1);
      });
    });

    // Sous-groupe consacré à la déconnexion.
    group('signOut', () {
      // Vérifie qu'une déconnexion sans valeur renvoie Right(unit).
      test('should return Right(unit) when signOut is successful', () async {
        // Le Future<void> simulé se termine avec succès.
        when(() => mockDataSource.signOut()).thenAnswer((_) async => {});

        final result = await repository.signOut();

        // On vérifie le côté droit puis la valeur spéciale unit.
        expect(result.isRight(), true);
        expect(result, const Right(unit));
        // La déconnexion doit être demandée une seule fois.
        verify(() => mockDataSource.signOut()).called(1);
      });
    });
  });
}
