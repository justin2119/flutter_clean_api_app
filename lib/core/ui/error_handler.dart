// DioException décrit les erreurs rencontrées lors des requêtes HTTP.
import 'package:dio/dio.dart';

// Centralise la conversion des erreurs techniques en messages français compréhensibles.
class NetworkErrorHandler {
  // Retourne un message localisé à partir de l'erreur Dio reçue.
  static String getMessage(DioException error) {
    // Les trois timeouts indiquent que la communication a attendu trop longtemps.
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connexion expirée';
    }

    // response peut être absente ; ?. évite une erreur si aucun serveur n'a répondu.
    final status = error.response?.statusCode;
    // Associe chaque code HTTP à une explication destinée à l'utilisateur.
    switch (status) {
      // 400 : la requête envoyée n'est pas correctement formée.
      case 400:
        return 'Mauvaise requête';
      // 401 : l'identité ou le jeton n'est pas accepté.
      case 401:
        return 'Non autorisé';
      // 403 : le serveur comprend la requête mais refuse l'accès.
      case 403:
        return 'Interdit';
      // 404 : la ressource demandée n'existe pas à cette adresse.
      case 404:
        return 'Non trouvé';
      // 408 : le serveur a attendu la requête trop longtemps.
      case 408:
        return 'Connexion expirée';
      // 500 : erreur interne générale du serveur.
      case 500:
        return 'Erreur serveur interne';
      // 502 : réponse invalide reçue par une passerelle.
      case 502:
        return 'Mauvaise passerelle';
      // 503 : le service est temporairement indisponible.
      case 503:
        return 'Service indisponible';
      // 504 : une passerelle n'a pas reçu sa réponse à temps.
      case 504:
        return 'Passerelle expirée';
      // Tous les autres cas reçoivent un message générique de secours.
      default:
        return 'Erreur réseau inattendue';
    }
  }
}
