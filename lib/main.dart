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
  await _initializeLocalStorage();
  await _initializeSupabaseSafely();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _initializeLocalStorage() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    if (!Hive.isAdapterRegistered(ArticleAdapter().typeId)) {
      Hive.registerAdapter(ArticleAdapter());
    }
    if (!Hive.isBoxOpen('news_articles')) {
      await Hive.openBox<Article>('news_articles');
    }
  } catch (_) {
    // The UI remains usable in demo mode when platform storage is unavailable.
  }
}

Future<void> _initializeSupabaseSafely() async {
  final url = EnvConfig.supabaseUrl.trim();
  final key = EnvConfig.supabaseAnonKey.trim();
  final valid = url.startsWith('https://') &&
      !url.contains('your-project') &&
      key.isNotEmpty &&
      !key.contains('your-anon');
  if (!valid) return;
  try {
    await Supabase.initialize(
      url: url,
      anonKey: key,
      authLocalStorage: SecureSupabaseLocalStorage(SecureStorageService()),
    );
  } catch (_) {
    // Network/configuration errors intentionally fall back to offline demo mode.
  }
}
