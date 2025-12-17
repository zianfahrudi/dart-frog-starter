// ignore_for_file: public_member_api_docs

import 'package:auth_feature/core/database.dart';
import 'package:auth_feature/models/auth/user_model.dart' hide User;
import 'package:bcrypt/bcrypt.dart';
import 'package:stormberry/stormberry.dart';

class AuthRepository {
  AuthRepository(this._db);
  final AppDatabase _db;

  Future<UserData> createUser(String username, String password) async {
    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    return await _db.into(_db.user).insertReturning(
          UserCompanion.insert(
            username: username,
            password: hashedPassword,
          ),
        );
  }

// READ ALL (Get All Users)
  Future<List<UserData>> findAllUsers() async {
    return await _db.select(_db.user).get();
  }

  Future<UserData?> findByUsername(String username) async {
    final List<UserData> result = await (_db.select(_db.user)
          ..where((t) => t.username.equals(username))
          // Opsional: Limit 1 biar lebih hemat performa
          ..limit(1))
        .get();

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<UserData?> findById(String id) async {
    return await (_db.select(_db.user)
          ..where((t) => t.id.equals(int.parse(id))))
        .getSingleOrNull();
  }

  // // UPDATE
  // Future<bool> updateUser(int id, String newUsername) async {
  //   // final intId = int.tryParse(id);
  //   // if (intId == null) throw Exception('Invalid ID');

  //   // // Buat request update
  //   // final request = UserUpdateRequest(
  //   //   id: intId,
  //   //   username: newUsername,
  //   //   // password tidak diisi artinya tidak diubah
  //   // );

  //   // await _db.users.updateOne(request);
  //   // return _db.users.queryUser(intId);

  //   final affectedRows =
  //       await (_db.update(_db.user)..where((t) => t.id.equals(id))).write(
  //     UserCompanion(
  //       content: Value(content),
  //     ),
  //   );
  //   return affectedRows > 0;
  // }

  // Future<void> deleteUser(String id) async {
  //   final intId = int.tryParse(id);
  //   if (intId == null) return;

  //   await _db.users.deleteOne(intId);
  // }
}
