class EnvConfig {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  static const String newsApiUrl = String.fromEnvironment('NEWS_API_URL', defaultValue: '');
  static const String newsApiKey = String.fromEnvironment('NEWS_API_KEY', defaultValue: '');
}
