import 'dart:io';

import 'package:auth_feature/repository/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    HttpMethod.get => _getUserById(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getUserById(RequestContext context, String id) async {
  final repository = context.read<UserRepository>();
  final userId = int.parse(id);
  final user = await repository.findById(userId);

  return user == null
      ? Response(statusCode: HttpStatus.notFound)
      : Response.json(
          body: {
            'message': 'Get User Successfully',
            'data': user.toJson(),
          },
        );
}
