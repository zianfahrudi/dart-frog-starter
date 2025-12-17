// ... import ...

import 'dart:io';

import 'package:auth_feature/repository/auth_repository.dart';
import 'package:auth_feature/services/auth_service.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final authService = context.read<AuthService>();

  final body = await context.request.json() as Map<String, dynamic>;
  final username = body['username'] as String;
  final passwordInput = body['password'] as String; // Password ketikan user

  final repo = context.read<AuthRepository>();

  try {
    // 1. Cari user berdasarkan username
    final user = await repo.findByUsername(username);

    final isPasswordCorrect =
        authService.checkPassword(passwordInput, user.password);
    if (!isPasswordCorrect) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'message': 'Invalid credentials',
        },
      );
    }

    final token = authService.generateToken(user.id.toString(), user.username);
    final refreshToken =
        authService.generateRefreshToken(user.id.toString(), user.username);

    return Response.json(
      body: {
        'message': 'Login Successfully',
        'data': {
          'token': token,
          'refresh_token': refreshToken,
          'user': {
            'id': user.id,
            'username': user.username,
          },
        },
      },
    );
  } catch (e) {
    return Response.json(statusCode: 400, body: {'error': e.toString()});
  }

  // 2. Cek User & Password

  // 3. VERIFIKASI HASH (PENTING!)
  // Kita cek: Apakah 'passwordInput' cocok dengan 'user.password' (hash di DB)?
}
