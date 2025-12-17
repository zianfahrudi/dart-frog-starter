// ignore_for_file: public_member_api_docs

import 'package:auth_feature/core/database.dart';
import 'package:bcrypt/bcrypt.dart';

abstract class AuthRepository {
  Future<UserData> createUser(String username, String password);
  Future<UserData?> findByUsername(String username);
  // Future<List<UserData>> findAllUsers();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._db);
  final AppDatabase _db;

  @override
  Future<UserData> createUser(String username, String password) async {
    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    return _db.into(_db.user).insertReturning(
          UserCompanion.insert(
            username: username,
            password: hashedPassword,
          ),
        );
  }

  @override
  Future<UserData?> findByUsername(String username) async {
    final result = await (_db.select(_db.user)
          ..where((t) => t.username.equals(username))
          ..limit(1))
        .get();

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }
}
