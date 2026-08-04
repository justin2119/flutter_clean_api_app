import '../../domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<AuthResponse> call({required String email, required String password}) async {
    return await _repository.signUp(email: email, password: password);
  }
}
