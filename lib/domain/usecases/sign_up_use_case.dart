import '../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/user.dart';

class SignUpUseCase {
  final AuthRepository _repository;
  SignUpUseCase(this._repository);
  Future<Either<Failure, User>> call({required String email, required String password}) => _repository.signUp(email: email, password: password);
}
