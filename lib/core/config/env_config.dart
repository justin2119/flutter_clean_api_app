import 'dart:developer' as developer;

class EnvConfig {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  static const String newsApiUrl = String.fromEnvironment('NEWS_API_URL', defaultValue: '');
  static const String newsApiKey = String.fromEnvironment('NEWS_API_KEY', defaultValue: '');

  /// Logs warnings for any missing environment variables.
  static void validate() {
    if (supabaseUrl.isEmpty) {
      developer.log('⚠️ SUPABASE_URL is not set', name: 'EnvConfig');
    }
    if (supabaseAnonKey.isEmpty) {
      developer.log('⚠️ SUPABASE_ANON_KEY is not set', name: 'EnvConfig');
    }
    if (newsApiUrl.isEmpty) {
      developer.log('⚠️ NEWS_API_URL is not set', name: 'EnvConfig');
    }
    if (newsApiKey.isEmpty) {
      developer.log('⚠️ NEWS_API_KEY is not set', name: 'EnvConfig');
    }
  }
}
