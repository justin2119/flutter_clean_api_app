// Classe de base commune à toutes les erreurs métier de l'application.
abstract class Failure {
  // Message lisible pouvant être affiché ou journalisé.
  final String message;
  // const permet de créer des erreurs immuables à la compilation.
  const Failure(this.message);
}

// Signale un problème de connexion ou de communication réseau.
class NetworkFailure extends Failure {
  // Le message est optionnel ; le texte par défaut aide les débutants à comprendre l'erreur.
  const NetworkFailure([String message = 'Network error']) : super(message);
}

// Signale que les identifiants fournis ne permettent pas de s'authentifier.
class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([String message = 'Invalid credentials']) : super(message);
}

// Signale un problème produit par le serveur distant.
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error']) : super(message);
}

// Représente une erreur qui ne correspond à aucune catégorie plus précise.
class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'Unknown error']) : super(message);
}
