// Failure représente une erreur métier compréhensible par le domaine.
import '../../core/error/failures.dart';
// Le cas d'utilisation dépend du contrat, jamais d'une implémentation concrète.
import '../../domain/repositories/auth_repository.dart';
// Unit représente une absence volontaire de valeur de résultat.
import 'package:fpdart/fpdart.dart';

// Cas d'utilisation correspondant à l'action « se déconnecter ».
class SignOutUseCase {
  // Dépendance injectée pour respecter l'inversion des dépendances.
  final AuthRepository _repository;
  // Reçoit le dépôt au moment de la construction.
  SignOutUseCase(this._repository);
  // call rend l'objet appelable comme une fonction.
  // Right(Unit) signifie que la déconnexion a réussi ; Left(Failure) signale un problème.
  Future<Either<Failure, Unit>> call() => _repository.signOut();
}
