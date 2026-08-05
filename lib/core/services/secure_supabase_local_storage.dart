import 'package:supabase_flutter/supabase_flutter.dart';
import 'secure_storage_service.dart';

class SecureSupabaseLocalStorage implements LocalStorage {
  final SecureStorageService _service;

  SecureSupabaseLocalStorage(this._service);

  @override
  Future<void> removeItem(String key) async => await _service.delete(key: key);

  @override
  Future<String?> getItem(String key) async => await _service.read(key: key);

  @override
  Future<void> setItem(String key, String value) async => await _service.write(key: key, value: value);
}
