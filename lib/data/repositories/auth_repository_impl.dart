// Couche data : relie le domaine aux services externes.
import '../../domain/repositories/auth_repository.dart'; // Contrat que cette classe respecte.
import '../../domain/entities/user.dart'; // Modèle User indépendant de Supabase.
import '../../core/error/failures.dart'; // Types d'erreurs de l'application.
import '../datasources/supabase_auth_datasource.dart'; // Réalise les appels Supabase.
import 'package:supabase_flutter/supabase_flutter.dart' as supabase; // Préfixe des types Supabase.
import 'package:fpdart/fpdart.dart'; // Either : Left = erreur, Right = succès.
import 'dart:io'; // Fournit SocketException.

// Implémentation concrète du contrat AuthRepository du domaine.
class AuthRepositoryImpl implements AuthRepository {
  // Dépendance injectée, donc facilement remplaçable par un mock en test.
  final SupabaseAuthDataSource _dataSource;

  // Le constructeur reçoit la datasource nécessaire.
  AuthRepositoryImpl(this._dataSource);

  // Convertit un utilisateur Supabase vers le modèle interne User.
  // Le ? indique que l'utilisateur peut être absent.
  User _mapSupabaseUser(supabase.User? supabaseUser) {
    // Sans utilisateur, le contrat actuel renvoie un User vide.
    if (supabaseUser == null) {
      return User(id: '', email: null);
    }
    // Copie et adapte chaque champ externe vers le domaine.
    return User(
      id: supabaseUser.id, // Identifiant unique.
      email: supabaseUser.email, // Adresse éventuellement nulle.
      phone: supabaseUser.phone, // Téléphone éventuellement nul.
      createdAt: DateTime.parse(supabaseUser.createdAt), // Texte ISO vers DateTime.
      metadata: supabaseUser.userMetadata, // Données complémentaires.
    );
  }

  // Future : résultat disponible plus tard. Either oblige à gérer succès et erreur.
  @override
  Future<Either<Failure, User>> signUp({required String email, required String password}) async {
    try {
      // await attend la réponse sans bloquer l'interface.
      final resp = await _dataSource.signUp(email: email, password: password);
      // Right représente le succès après conversion du User.
      return Right(_mapSupabaseUser(resp.user));
    } on supabase.AuthException catch (e) {
      // Erreur Supabase convertie en erreur compréhensible par le domaine.
      return Left(NetworkFailure(e.message));
    } on SocketException {
      // Coupure réseau convertie en NetworkFailure.
      return Left(NetworkFailure());
    } catch (e) {
      // Toute autre exception devient une erreur contrôlée.
      return Left(UnknownFailure(e.toString()));
    }
  }

  // Même principe pour la connexion d'un compte existant.
  @override
  Future<Either<Failure, User>> signIn({required String email, required String password}) async {
    try {
      // La datasource renvoie un AuthResponse après l'appel asynchrone.
      final resp = await _dataSource.signInWithPassword(email: email, password: password);
      // La réponse externe est isolée : l'UI reçoit seulement User.
      return Right(_mapSupabaseUser(resp.user));
    } on supabase.AuthException catch (e) {
      // Le message d'authentification est conservé.
      return Left(NetworkFailure(e.message));
    } on SocketException {
      // Réseau indisponible.
      return Left(NetworkFailure());
    } catch (e) {
      // Filet de sécurité pour toute erreur imprévue.
      return Left(UnknownFailure(e.toString()));
    }
  }

  // Unit signifie qu'une déconnexion réussie n'a pas de valeur à retourner.
  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      // On attend la fin de l'opération avant d'annoncer le succès.
      await _dataSource.signOut();
      // Right(unit) signifie « réussi, sans donnée supplémentaire ».
      return const Right(unit);
    } on supabase.AuthException catch (e) {
      return Left(NetworkFailure(e.message)); // Erreur Supabase.
    } on SocketException {
      return Left(NetworkFailure()); // Erreur de connexion.
    } catch (e) {
      return Left(UnknownFailure(e.toString())); // Erreur inattendue.
    }
  }

  // Lit la session courante ; il n'y a pas forcément d'utilisateur connecté.
  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // La lecture peut renvoyer null si aucune session n'existe.
      final supabaseUser = _dataSource.getCurrentUser();
      // Utilisateur présent : mapping ; absent : Right(null).
      return Right(supabaseUser != null ? _mapSupabaseUser(supabaseUser) : null);
    } catch (e) {
      // La lecture échoue proprement sous forme de Left.
      return Left(UnknownFailure(e.toString()));
    }
  }
}
