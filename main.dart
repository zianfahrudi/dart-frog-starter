// ignore_for_file: lines_longer_than_80_chars, avoid_print

import 'dart:async';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';

Future<void> init(InternetAddress ip, int port) async {
  print('🚀 initialize function is working');

  // Any code initialized within this method will only run on server start, any hot reloads
  // afterwards will not trigger this method until a hot restart.
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  // 1. Jalankan Logic Tambahan Kita (Background Service)
  // Kita panggil fungsi pembersih sampah
  startTokenCleanupService();

  print('🚀 Custom Entrypoint: Service pembersih sampah sudah jalan!');

  // 2. Jalankan Server seperti biasa
  // Kita kembalikan server agar Dart Frog tetap bisa melayani request HTTP
  return serve(handler, ip, port);
}

// --- Logic Background Job ---

void startTokenCleanupService() {
  // Timer.periodic akan berjalan terus menerus di latar belakang
  // Contoh: Setiap 1 jam (Duration(hours: 1))
  Timer.periodic(const Duration(seconds: 10), (timer) {
    // Di real app: Panggil database -> DELETE FROM tokens WHERE expired_at < NOW()
    print(
      '🧹 [Background Job] Sedang membersihkan token expired... ${DateTime.now()}',
    );
  });
}
