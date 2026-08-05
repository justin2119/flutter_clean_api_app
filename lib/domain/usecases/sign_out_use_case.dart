import '../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignOutUseCase {
  final AuthRepository _repository;
  SignOutUseCase(this._repository);
  Future<Either<Failure, Unit>> call() => _repository.signOut();
}
