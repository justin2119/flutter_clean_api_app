abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error']) : super(message);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([String message = 'Invalid credentials']) : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error']) : super(message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'Unknown error']) : super(message);
}
