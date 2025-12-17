import 'package:auth_feature/repository/auth_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final username = body['username'] as String?;
  final password = body['password'] as String?;

  if (username == null || password == null) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Missing fields'},
    );
  }

  // Ambil AuthRepository
  final repo = context.read<AuthRepository>();

  try {
    final user = await repo.createUser(username, password);

    // Stormberry UserView tidak punya method toJson() bawaan
    // Kita buat map manual atau tambahkan extension
    return Response.json(
      body: {
        'message': 'User created',
        'user': {
          'id': user.id,
          'username': user.username,
        },
      },
    );
  } catch (e) {
    return Response.json(statusCode: 400, body: {'error': e.toString()});
  }
}
