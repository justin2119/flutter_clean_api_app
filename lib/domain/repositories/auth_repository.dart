import '../../domain/entities/user.dart';
import '../../core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUp({required String email, required String password});
  Future<Either<Failure, User>> signIn({required String email, required String password});
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, User?>> getCurrentUser();
}
