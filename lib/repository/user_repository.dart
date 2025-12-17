// ignore_for_file: public_member_api_docs

import 'package:auth_feature/core/database.dart';
import 'package:drift/drift.dart';

abstract class UserRepository {
  Future<bool> updateRoleUser(int id, String role);
  Future<UserData?> findById(int id);
  Future<List<UserData>> findAllUsers();
  Future<bool> deteleUser(int id);
}

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._db);
  final AppDatabase _db;
  @override
  Future<bool> updateRoleUser(int id, String role) async {
    final affectedRows =
        await (_db.update(_db.user)..where((t) => t.id.equals(id))).write(
      UserCompanion(
        role: Value(role),
      ),
    );
    return affectedRows > 0;
  }

  @override
  Future<bool> deteleUser(int id) async {
    final affectedRows =
        await (_db.delete(_db.user)..where((t) => t.id.equals(id))).go();
    return affectedRows > 0;
  }

  @override
  Future<UserData?> findById(int id) async {
    final result = await (_db.select(_db.user)
          ..where((t) => t.id.equals(id))
          ..limit(1))
        .get();

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  @override
  Future<List<UserData>> findAllUsers() async {
    return _db.select(_db.user).get();
  }
}
