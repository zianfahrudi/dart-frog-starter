import 'dart:io';
import 'package:auth_feature/repository/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    HttpMethod.get => _getUserById(context, id),
    HttpMethod.delete => _deleteUser(context, id),
    HttpMethod.patch => _updateRoleUser(context, id),
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

Future<Response> _deleteUser(RequestContext context, String id) async {
  final repository = context.read<UserRepository>();
  final userId = int.parse(id);
  final user = await repository.deteleUser(userId);

  return !user
      ? Response.json(
          statusCode: HttpStatus.badRequest,
          body: {
            'message': 'Something went wrong',
          },
        )
      : Response.json(
          body: {
            'message': 'Delete User Successfully',
          },
        );
}

Future<Response> _updateRoleUser(RequestContext context, String id) async {
  final bodyString = await context.request.body();

  if (bodyString.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'message': 'Invalid Requests',
      },
    );
  }

  final repository = context.read<UserRepository>();
  final userId = int.parse(id);
  final body = await context.request.json() as Map<String, dynamic>;
  final inputNewRole = body['role'] as String;
  final user = await repository.updateRoleUser(userId, inputNewRole);

  // if (body.keys.isEmpty) {
  //   Response.json(
  //     statusCode: HttpStatus.badRequest,
  //     body: {
  //       'message': 'Invalid Request',
  //     },
  //   );
  // }

  return !user
      ? Response(statusCode: HttpStatus.notFound)
      : Response.json(
          body: {
            'message': 'Update User Successfully',
          },
        );
}
