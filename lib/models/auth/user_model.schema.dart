// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint
// ignore_for_file: annotate_overrides
// dart format off

part of 'user_model.dart';

extension UserModelRepositories on Session {
  UserRepository get users => UserRepository._(this);
}

abstract class UserRepository
    implements
        ModelRepository,
        KeyedModelRepositoryInsert<UserInsertRequest>,
        ModelRepositoryUpdate<UserUpdateRequest>,
        ModelRepositoryDelete<int> {
  factory UserRepository._(Session db) = _UserRepository;

  Future<UserView?> queryUser(int id);
  Future<List<UserView>> queryUsers([QueryParams? params]);
}

class _UserRepository extends BaseRepository
    with
        KeyedRepositoryInsertMixin<UserInsertRequest>,
        RepositoryUpdateMixin<UserUpdateRequest>,
        RepositoryDeleteMixin<int>
    implements UserRepository {
  _UserRepository(super.db) : super(tableName: 'users', keyName: 'id');

  @override
  Future<UserView?> queryUser(int id) {
    return queryOne(id, UserViewQueryable());
  }

  @override
  Future<List<UserView>> queryUsers([QueryParams? params]) {
    return queryMany(UserViewQueryable(), params);
  }

  @override
  Future<List<int>> insert(List<UserInsertRequest> requests) async {
    if (requests.isEmpty) return [];
    var values = QueryValues();
    var rows = await db.execute(
      Sql.named(
        'INSERT INTO "users" ( "username", "password" )\n'
        'VALUES ${requests.map((r) => '( ${values.add(r.username)}:text, ${values.add(r.password)}:text )').join(', ')}\n'
        'RETURNING "id"',
      ),
      parameters: values.values,
    );
    var result = rows
        .map<int>((r) => TextEncoder.i.decode(r.toColumnMap()['id']))
        .toList();

    return result;
  }

  @override
  Future<void> update(List<UserUpdateRequest> requests) async {
    if (requests.isEmpty) return;

    final updateRequests = [
      for (final r in requests)
        if (r.username != null || r.password != null) r,
    ];

    if (updateRequests.isNotEmpty) {
      var values = QueryValues();
      await db.execute(
        Sql.named(
          'UPDATE "users"\n'
          'SET "username" = COALESCE(UPDATED."username", "users"."username"), "password" = COALESCE(UPDATED."password", "users"."password")\n'
          'FROM ( VALUES ${updateRequests.map((r) => '( ${values.add(r.id)}:int8::int8, ${values.add(r.username)}:text::text, ${values.add(r.password)}:text::text )').join(', ')} )\n'
          'AS UPDATED("id", "username", "password")\n'
          'WHERE "users"."id" = UPDATED."id"',
        ),
        parameters: values.values,
      );
    }
  }
}

class UserInsertRequest {
  UserInsertRequest({required this.username, required this.password});

  final String username;
  final String password;
}

class UserUpdateRequest {
  UserUpdateRequest({required this.id, this.username, this.password});

  final int id;
  final String? username;
  final String? password;
}

class UserViewQueryable extends KeyedViewQueryable<UserView, int> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(int key) => TextEncoder.i.encode(key);

  @override
  String get query =>
      'SELECT "users".*'
      'FROM "users"';

  @override
  String get tableAlias => 'users';

  @override
  UserView decode(TypedMap map) => UserView(
    id: map.get('id'),
    username: map.get('username'),
    password: map.get('password'),
  );
}

class UserView {
  UserView({required this.id, required this.username, required this.password});

  final int id;
  final String username;
  final String password;
}
