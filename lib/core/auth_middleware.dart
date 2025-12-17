// ignore_for_file: public_member_api_docs

import 'package:auth_feature/core/env.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

// Fungsi ini bisa dipanggil di _middleware.dart manapun
Handler authMiddleware(Handler handler) {
  return (context) async {
    // 1. Cek Header Authorization
    final authHeader = context.request.headers['Authorization'];

    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response.json(
        statusCode: 401,
        body: {
          'message': 'Unauthorized: Missing token',
        },
      );
    }

    // 2. Ambil & Verifikasi Token
    final token = authHeader.substring(7);

    try {
      // Gunakan ENV variable untuk secret key di production
      final jwt = JWT.verify(token, SecretKey(Env.get('JWT_SECRET')));

      final payload = jwt.payload as Map<String, dynamic>;

      // 3. SUKSES: Inject data user dan lanjutkan request
      return handler
          .use(provider<Map<String, dynamic>>((_) => payload))
          .call(context);
    } catch (e) {
      return Response.json(
        statusCode: 401,
        body: {
          'message': 'Unauthorized: Invalid token',
        },
      );
    }
  };
}
