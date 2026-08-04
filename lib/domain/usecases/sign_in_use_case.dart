import '../../domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignInUseCase {
  final AuthRepository _repository;
  SignInUseCase(this._repository);
  Future<Either<Failure, User>> call({required String email, required String password}) => _repository.signIn(email: email, password: password);
}
