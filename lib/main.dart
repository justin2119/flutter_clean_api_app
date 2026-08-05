import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/env_config.dart';
import 'core/services/secure_supabase_local_storage.dart';
import 'core/services/secure_storage_service.dart';
import 'app.dart';
import 'domain/entities/article.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with secure local storage
  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
    authLocalStorage: SecureSupabaseLocalStorage(SecureStorageService()),
  );

  // Verify environment variables
  if (EnvConfig.supabaseUrl.isEmpty || EnvConfig.supabaseAnonKey.isEmpty) {
    // Log a warning – in a real app you might show a UI prompt
    debugPrint('Supabase environment variables are missing. Initialization may fail.');
  }

  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(ArticleAdapter());
  await Hive.openBox<Article>('articles_box');

  runApp(const ProviderScope(child: MyApp()));
}
