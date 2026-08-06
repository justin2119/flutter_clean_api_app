// Entité métier représentant un utilisateur dans le domaine de l'application.
class User {
  // Identifiant unique et obligatoire de l'utilisateur.
  final String id;
  // Adresse e-mail facultative : le ? autorise la valeur null.
  final String? email;
  // Numéro de téléphone éventuellement fourni.
  final String? phone;
  // Date de création connue ou absente.
  final DateTime? createdAt;
  // Données supplémentaires flexibles venant par exemple d'un service distant.
  final Map<String, dynamic>? metadata;

  // Le constructeur crée un User à partir des informations disponibles.
  User({
    // required oblige l'appelant à fournir l'identifiant.
    required this.id,
    // Les propriétés optionnelles peuvent être omises.
    this.email,
    this.phone,
    this.createdAt,
    this.metadata,
  });
}
