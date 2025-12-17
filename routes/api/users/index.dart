// ignore_for_file: avoid_print, lines_longer_than_80_chars

import 'package:auth_feature/repository/auth_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }

  // OPTIONAL: Jika Anda butuh ID user yang sedang login (misal untuk log activity)
  // Data ini didapat dari provider di middleware tadi
  final currentUser = context.read<Map<String, dynamic>>();
  print('User yang merequest data ini adalah ID: ${currentUser['id']}');

  // --- LOGIC UTAMA (Bersih tanpa auth check) ---

  final repo = context.read<AuthRepository>();
  final users = await repo.findAllUsers();

  // Sanitasi data (buang password)
  final safeUsers = users.map((u) {
    return {
      'id': u.id,
      'username': u.username,
      // Password tidak dikirim
    };
  }).toList();

  return Response.json(
    body: {
      'message': 'Get User Success',
      'data': safeUsers,
    },
  );
}
