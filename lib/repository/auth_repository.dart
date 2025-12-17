// ignore_for_file: public_member_api_docs

import 'package:auth_feature/models/auth/user_model.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:stormberry/stormberry.dart';

class AuthRepository {
  AuthRepository(this._db);
  final Database _db;

  Future<UserView?> createUser(String username, String password) async {
    // 1. HASHING PASSWORD
    // BCrypt.gensalt() membuat 'bumbu' acak agar hash selalu unik
    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    // 2. Simpan password yang SUDAH DI-HASH ke database
    final request = UserInsertRequest(
      username: username,
      password: hashedPassword, // <--- Jangan simpan 'password' asli!
    );

    final id = await _db.users.insertOne(request);
    return _db.users.queryUser(id);
  }

// READ ALL (Get All Users)
  Future<List<UserView>> findAllUsers() async {
    // QueryParams kosong artinya "SELECT * FROM users"
    // Stormberry akan mengembalikan List<UserView>
    return _db.users.queryUsers(const QueryParams());
  }

  Future<UserView?> findByUsername(String username) async {
    final users = await _db.users.queryUsers(
      QueryParams(
        where: 'username = @u',
        values: {
          'u': username,
        },
      ),
    );

    if (users.isEmpty) {
      return null;
    } else {
      return users.first;
    }
  }

  Future<UserView?> findById(String id) async {
    final intId = int.tryParse(id);
    if (intId == null) return null;

    return _db.users.queryUser(intId);
  }

  // UPDATE
  Future<UserView?> updateUser(String id, String newUsername) async {
    final intId = int.tryParse(id);
    if (intId == null) throw Exception('Invalid ID');

    // Buat request update
    final request = UserUpdateRequest(
      id: intId,
      username: newUsername,
      // password tidak diisi artinya tidak diubah
    );

    await _db.users.updateOne(request);
    return _db.users.queryUser(intId);
  }

  Future<void> deleteUser(String id) async {
    final intId = int.tryParse(id);
    if (intId == null) return;

    await _db.users.deleteOne(intId);
  }
}
