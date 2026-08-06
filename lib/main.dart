// Fournit les widgets et les fonctions de base de Flutter.
import 'package:flutter/material.dart';
// Fournit ProviderScope, le conteneur racine nécessaire à Riverpod.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Fournit Hive, une base de données locale légère pour le cache hors ligne.
import 'package:hive/hive.dart';
// Permet de trouver un dossier sûr appartenant à l'application.
import 'package:path_provider/path_provider.dart';
// Fournit l'initialisation du client Supabase et ses types.
import 'package:supabase_flutter/supabase_flutter.dart';
// Contient les URL et clés de configuration de l'environnement.
import 'core/config/env_config.dart';
// Adapte le stockage local de Supabase à un stockage sécurisé.
import 'core/services/secure_supabase_local_storage.dart';
// Implémentation du service qui protège les données locales sensibles.
import 'core/services/secure_storage_service.dart';
// Contient le widget racine de l'application.
import 'app.dart';
// Contient l'entité Article et son adaptateur généré pour Hive.
import 'domain/entities/article.dart';

// main est le premier code exécuté par l'application.
// Future<void> signifie que l'initialisation peut attendre des opérations asynchrones.
Future<void> main() async {
  // Prépare le moteur Flutter avant d'utiliser des plugins ou du code async.
  // Sans cette ligne, certains plugins peuvent être appelés trop tôt.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Supabase avant de lancer l'interface.
  // await attend la fin de cette préparation avant de continuer.
  // Le stockage sécurisé conserve les informations de session de façon protégée.
  await Supabase.initialize(
    // URL du projet Supabase, l'adresse du serveur distant.
    url: EnvConfig.supabaseUrl,
    // Clé anonyme prévue pour être utilisée par l'application cliente.
    anonKey: EnvConfig.supabaseAnonKey,
    // Remplace le stockage local standard par une solution sécurisée.
    authLocalStorage: SecureSupabaseLocalStorage(SecureStorageService()),
  );

  // Vérifie les variables d'environnement et signale une configuration incomplète.
  EnvConfig.validate();

  // Demande au système le dossier privé où l'application peut enregistrer ses fichiers.
  final appDocDir = await getApplicationDocumentsDirectory();
  // Configure Hive pour qu'il utilise ce dossier comme emplacement de stockage.
  Hive.init(appDocDir.path);
  // Enregistre la description nécessaire pour transformer Article en données Hive.
  // L'adaptateur permet de sauvegarder puis de reconstruire les objets Article.
  Hive.registerAdapter(ArticleAdapter());
  // Ouvre la boîte locale nommée news_articles pour le cache des actualités.
  // Le type <Article> indique le type d'objet attendu dans cette boîte.
  await Hive.openBox<Article>('news_articles');

  // ProviderScope crée l'espace partagé où Riverpod conserve ses providers.
  // MyApp devient son enfant et peut donc utiliser l'architecture Riverpod.
  // const indique que ces widgets n'ont pas de données variables à cette création.
  runApp(const ProviderScope(child: MyApp()));
}
