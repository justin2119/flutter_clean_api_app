import 'package:dio/dio.dart';

/// Centralized network error handling with French user‑friendly messages.
class NetworkErrorHandler {
  /// Returns a localized French message based on the [DioException].
  static String getMessage(DioException error) {
    // Network timeout / connection issues
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connexion expirée';
    }

    // HTTP status code based messages
    final status = error.response?.statusCode;
    switch (status) {
      case 400:
        return 'Mauvaise requête';
      case 401:
        return 'Non autorisé';
      case 403:
        return 'Interdit';
      case 404:
        return 'Non trouvé';
      case 408:
        return 'Connexion expirée';
      case 500:
        return 'Erreur serveur interne';
      case 502:
        return 'Mauvaise passerelle';
      case 503:
        return 'Service indisponible';
      case 504:
        return 'Passerelle expirée';
      default:
        return 'Erreur réseau inattendue';
    }
  }
}
