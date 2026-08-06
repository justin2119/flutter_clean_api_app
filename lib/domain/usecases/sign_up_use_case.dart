// Erreurs génériques utilisées dans le résultat du cas d'utilisation.
import '../../core/error/failures.dart';
// Contrat d'authentification du domaine.
import '../../domain/repositories/auth_repository.dart';
// Either encode le choix entre réussite et échec.
import 'package:fpdart/fpdart.dart';

// Entité produite après une inscription réussie.
import '../entities/user.dart';

// Cas d'utilisation Clean Architecture : une intention métier unique, l'inscription.
class SignUpUseCase {
  // Le cas d'utilisation connaît une abstraction, pas Supabase directement.
  final AuthRepository _repository;
  // Le constructeur reçoit sa dépendance, ce qui facilite les tests avec un faux dépôt.
  SignUpUseCase(this._repository);
  // call permet d'écrire useCase(email: ..., password: ...).
  // Right contient le User créé ; Left contient Failure si l'inscription échoue.
  Future<Either<Failure, User>> call({required String email, required String password}) => _repository.signUp(email: email, password: password);
}
