// ignore_for_file: lines_longer_than_80_chars, public_member_api_docs, avoid_print

import 'dart:io';
import 'package:dotenv/dotenv.dart';

class Env {
  // Simpan instance DotEnv sebagai static agar bisa diakses berulang kali
  static final DotEnv _env = DotEnv(includePlatformEnvironment: true);
  static bool _isLoaded = false;

  static void load() {
    if (_isLoaded) return;

    // Cek keberadaan file .env untuk debugging
    final file = File('.env');
    if (!file.existsSync()) {
      print(
        '⚠️ PERINGATAN: File .env tidak ditemukan di: ${Directory.current.path}',
      );
      print(
        'Pastikan file .env ada di root project sejajar dengan pubspec.yaml',
      );
    } else {
      print('✅ Memuat environment dari: ${file.absolute.path}');
      // Load file .env ke dalam variabel _env
      _env.load(['.env']);
    }

    _isLoaded = true;
  }

  static String get(String key, {String? fallback}) {
    // Pastikan sudah di-load sebelum mencoba mengambil data
    if (!_isLoaded) load();

    // 1. Coba ambil dari DotEnv (File .env + System Environment)
    // _env[] otomatis mengecek system env juga jika includePlatformEnvironment: true
    if (_env.isDefined(key)) {
      return _env[key]!;
    }

    // 2. Cek manual Platform environment (Backup untuk production/docker)
    final platformValue = Platform.environment[key];
    if (platformValue != null && platformValue.isNotEmpty) {
      return platformValue;
    }

    // 3. Fallback atau Error
    if (fallback != null) return fallback;
    throw Exception(
      'Missing environment variable: "$key". Pastikan variabel ini ada di file .env',
    );
  }

  static int getInt(String key, {int? fallback}) {
    final value = get(key, fallback: fallback?.toString());
    return int.tryParse(value) ?? fallback ?? 0;
  }

  static bool getBool(String key, {bool fallback = false}) {
    final value = get(key, fallback: fallback.toString()).toLowerCase();
    return value == 'true' || value == '1';
  }
}
