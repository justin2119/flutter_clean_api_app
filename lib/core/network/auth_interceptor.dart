import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Attach Supabase JWT if available
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null && session.accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Try to refresh the token
      try {
        final refreshed = await Supabase.instance.client.auth.refreshSession();
        if (refreshed.session != null) {
          final newToken = refreshed.session!.accessToken;
          // retry original request with new token
          final request = err.requestOptions;
          request.headers['Authorization'] = 'Bearer $newToken';
          final clone = await Dio().fetch(request);
          return handler.resolve(clone);
        }
      } catch (_) {}
    }
    super.onError(err, handler);
  }
}
