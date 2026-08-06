// Dio gère les requêtes HTTP et leurs intercepteurs.
import 'package:dio/dio.dart';
// Supabase donne accès à la session et au jeton JWT courant.
import 'package:supabase_flutter/supabase_flutter.dart';
// Import conservé tel quel : le stockage sécurisé est utilisé par d'autres services.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Un intercepteur observe les requêtes avant leur envoi et les erreurs après réception.
class AuthInterceptor extends Interceptor {
  // Appelée automatiquement juste avant l'envoi d'une requête Dio.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Récupère la session actuellement connue par le client Supabase.
    // Une session contient notamment le jeton JWT prouvant l'identité de l'utilisateur.
    final session = Supabase.instance.client.auth.currentSession;
    // On n'ajoute l'en-tête que si la session existe et que le jeton n'est pas vide.
    if (session != null && session.accessToken.isNotEmpty) {
      // Authorization est l'en-tête HTTP standard pour transmettre un jeton Bearer.
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }
    // Transmet la requête au prochain intercepteur puis au réseau.
    super.onRequest(options, handler);
  }

  // Appelée quand Dio reçoit une erreur pendant une requête.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 signifie généralement que le jeton n'est plus accepté.
    if (err.response?.statusCode == 401) {
      // Tente de renouveler le jeton avant d'abandonner.
      try {
        final refreshed = await Supabase.instance.client.auth.refreshSession();
        // Le renouvellement peut échouer ; on vérifie donc la présence d'une nouvelle session.
        if (refreshed.session != null) {
          // Récupère le nouveau JWT délivré par Supabase.
          final newToken = refreshed.session!.accessToken;
          // Reprend les options exactes de la requête originale.
          final request = err.requestOptions;
          // Remplace l'ancien jeton par le nouveau.
          request.headers['Authorization'] = 'Bearer $newToken';
          // Rejoue la requête avec Dio.
          final clone = await Dio().fetch(request);
          // Résout l'erreur avec la réponse obtenue lors de la nouvelle tentative.
          return handler.resolve(clone);
        }
      } catch (_) {
        // Si le renouvellement échoue, l'erreur originale sera transmise plus bas.
      }
    }
    // Transmet toute erreur non réparée au prochain gestionnaire.
    super.onError(err, handler);
  }
}
