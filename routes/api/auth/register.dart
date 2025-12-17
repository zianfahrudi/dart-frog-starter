import 'dart:io';

import 'package:auth_feature/repository/auth_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final username = body['username'] as String?;
  final password = body['password'] as String?;

  if (username == null || password == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'message': 'Missing fields'},
    );
  }

  final repo = context.read<AuthRepository>();

  try {
    final userAlreadyExist = await repo.findByUsername(username);
    if (userAlreadyExist != null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'message': 'Username already exist'},
      );
    }

    if (username.length < 6) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'message': 'Username minimal 6 karakter'},
      );
    }

    final user = await repo.createUser(username, password);

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
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': e.toString()},
    );
  }
}
