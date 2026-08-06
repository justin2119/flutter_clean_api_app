// Riverpod fournit les primitives pour exposer un état asynchrone à l'interface Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Entité métier représentant l'utilisateur connecté.
import '../../domain/entities/user.dart';
// Contrat abstrait utilisé par le notifier, sans dépendance directe à Supabase.
import '../../domain/repositories/auth_repository.dart';
// Implémentation concrète du dépôt d'authentification.
import '../../data/repositories/auth_repository_impl.dart';
// Adaptateur qui traduit les appels du dépôt vers Supabase.
import '../../data/datasources/supabase_auth_datasource.dart';
// L'alias supabase évite les collisions de noms et rend la provenance explicite.
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
// fpdart fournit Either et fold pour traiter succès et échec sans logique conditionnelle fragile.
import 'package:fpdart/fpdart.dart';

// AsyncNotifierProvider crée et surveille AuthNotifier.
// Le type User? signifie que l'état peut contenir un utilisateur ou null si personne n'est connecté.
// AsyncNotifier ajoute les états réactifs AsyncLoading, AsyncData et AsyncError.
final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(() => AuthNotifier());

// Ce notifier centralise l'état d'authentification observé par les widgets Flutter.
class AuthNotifier extends AsyncNotifier<User?> {
  // late indique que le dépôt sera initialisé pendant build avant toute action utilisateur.
  // Le type AuthRepository conserve l'abstraction et facilite les tests avec un faux dépôt.
  late final AuthRepository _repo;

  // Riverpod appelle build pour initialiser l'état avec l'utilisateur déjà connu.
  @override
  Future<User?> build() async {
    // Récupère le client Supabase singleton déjà configuré par l'application.
    final client = supabase.Supabase.instance.client;
    // Injecte ce client dans la datasource, puis la datasource dans le repository.
    // Cette chaîne sépare l'interface métier de la technologie concrète Supabase.
    _repo = AuthRepositoryImpl(SupabaseAuthDataSource(client));
    // Le dépôt renvoie Either<Failure, User?> : Left contient Failure, Right contient User? .
    final result = await _repo.getCurrentUser();
    // fold visite les deux possibilités : ici une erreur donne null et un succès donne l'utilisateur.
    return result.fold((l) => null, (r) => r);
  }

  // Lance une connexion et publie son résultat dans l'état réactif.
  Future<void> signIn(String email, String password) async {
    // Les widgets peuvent afficher un indicateur pendant l'opération.
    state = const AsyncLoading();
    final result = await _repo.signIn(email: email, password: password);
    // fold reçoit d'abord le chemin Left (failure), puis le chemin Right (user).
    result.fold(
      // Left représente l'échec : AsyncError conserve l'objet Failure et sa trace.
      (failure) => state = AsyncError(failure, StackTrace.current),
      // Right représente la réussite : AsyncData contient l'utilisateur résolu.
      (user) => state = AsyncData(user),
    );
  }

  // Crée un compte puis met à jour l'interface avec le même modèle fonctionnel.
  Future<void> signUp(String email, String password) async {
    // Réinitialise l'état visible en mode chargement avant la requête.
    state = const AsyncLoading();
    final result = await _repo.signUp(email: email, password: password);
    // Aucune exception conditionnelle n'est nécessaire : fold route les deux branches.
    result.fold(
      // Une Failure devient un état d'erreur observable par les widgets.
      (failure) => state = AsyncError(failure, StackTrace.current),
      // Un User valide devient la nouvelle donnée réactive.
      (user) => state = AsyncData(user),
    );
  }

  // Termine la session courante.
  Future<void> signOut() async {
    // Signale immédiatement que la déconnexion est en cours.
    state = const AsyncLoading();
    final result = await _repo.signOut();
    // Pour signOut, Right contient Unit : le succès n'a pas de donnée utilisateur à renvoyer.
    result.fold(
      // Left transmet l'erreur au système d'état Riverpod.
      (failure) => state = AsyncError(failure, StackTrace.current),
      // Right(Unit) signifie succès ; l'état devient alors explicitement null.
      (_) => state = const AsyncData(null),
    );
  }
}
