// Types d'erreurs renvoyés sans dépendre du fournisseur d'authentification.
import '../../core/error/failures.dart';
// Contrat abstrait que le cas d'utilisation consomme.
import '../../domain/repositories/auth_repository.dart';
// Either décrit explicitement le succès ou l'échec.
import 'package:fpdart/fpdart.dart';

// Entité utilisateur retournée si la connexion réussit.
import '../entities/user.dart';

// Un Use Case représente une action métier précise de l'application.
class SignInUseCase {
  // Le dépôt est injecté : le cas d'utilisation reste testable et indépendant de Supabase.
  final AuthRepository _repository;
  // Conserve exactement le dépôt fourni par la couche supérieure.
  SignInUseCase(this._repository);
  // call permet d'utiliser l'objet comme une fonction : signInUseCase(...).
  // Right contient User en cas de succès ; Left contient Failure en cas d'échec.
  Future<Either<Failure, User>> call({required String email, required String password}) => _repository.signIn(email: email, password: password);
}
