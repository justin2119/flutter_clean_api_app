// Importe les outils de journalisation de Dart sous le nom developer.
// Cela permet d'afficher des messages utiles dans les logs sans modifier l'interface.
import 'dart:developer' as developer;

// Cette classe centralise les paramètres fournis par l'environnement de compilation.
class EnvConfig {
  // String.fromEnvironment lit une valeur passée avec --dart-define.
  // const signifie que la valeur est connue dès la compilation.
  // Une chaîne vide indique que la variable n'a pas été fournie.
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  // Clé publique utilisée par l'application cliente pour contacter Supabase.
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  // Adresse de l'API d'actualités.
  static const String newsApiUrl = String.fromEnvironment('NEWS_API_URL', defaultValue: '');
  // Clé permettant d'accéder à cette API d'actualités.
  static const String newsApiKey = String.fromEnvironment('NEWS_API_KEY', defaultValue: '');

  // Vérifie chaque paramètre et écrit un avertissement lorsqu'il manque.
  static void validate() {
    // isEmpty signifie que la chaîne ne contient aucun caractère.
    if (supabaseUrl.isEmpty) {
      // name regroupe ce message sous le nom EnvConfig dans les outils de développement.
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
