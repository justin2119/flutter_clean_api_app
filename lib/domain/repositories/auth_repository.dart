// Importe l'entité métier User sans dépendre d'une implémentation technique.
import '../../domain/entities/user.dart';
// Failure représente les erreurs que le domaine sait communiquer.
import '../../core/error/failures.dart';
// Either, Left, Right et Unit permettent d'exprimer les résultats sans exceptions habituelles.
import 'package:fpdart/fpdart.dart';

// Contrat abstrait de l'authentification dans la couche Domain.
// Une interface décrit les capacités attendues sans imposer Supabase, Dio ou une autre technologie.
abstract class AuthRepository {
  // Inscrit un utilisateur et renvoie Right(User) ou Left(Failure).
  Future<Either<Failure, User>> signUp({required String email, required String password});
  // Connecte un utilisateur avec le même modèle de résultat explicite.
  Future<Either<Failure, User>> signIn({required String email, required String password});
  // Unit signifie « aucune valeur utile » : seul le succès ou l'échec compte.
  Future<Either<Failure, Unit>> signOut();
  // Le User peut être absent, d'où User? à l'intérieur du Either.
  Future<Either<Failure, User?>> getCurrentUser();
}
