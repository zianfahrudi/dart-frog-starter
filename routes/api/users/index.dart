// ignore_for_file: avoid_print, lines_longer_than_80_chars

import 'dart:io';
import 'package:auth_feature/repository/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getUsers(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getUsers(RequestContext context) async {
  final currentUser = context.read<Map<String, dynamic>>();
  print('User yang merequest data ini adalah ID: ${currentUser['id']}');

  final repo = context.read<UserRepository>();
  final users = await repo.findAllUsers();

  final safeUsers = users.map((u) {
    return {
      'id': u.id,
      'username': u.username,
    };
  }).toList();

  return Response.json(
    body: {
      'message': 'Get User Success',
      'data': safeUsers,
    },
  );
}
