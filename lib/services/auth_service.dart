// ignore_for_file: public_member_api_docs

import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthService {
  final String _secret = 'secret'; // Sebaiknya ambil dari Platform.environment

  // Helper untuk Hash Password
  String hashPassword(String plainPassword) {
    return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
  }

  // Helper untuk Cek Password
  bool checkPassword(String plainPassword, String hashedPassword) {
    return BCrypt.checkpw(plainPassword, hashedPassword);
  }

// 2. REFRESH TOKEN (Lama: 7 Hari)
  String generateRefreshToken(String userId, String username) {
    final jwt = JWT({
      'id': userId,
      'type': username, // Penanda tipe token
    });
    return jwt.sign(SecretKey(_secret), expiresIn: const Duration(days: 7));
  }

  // Helper untuk Bikin Token
  String generateToken(String userId, String username) {
    final jwt = JWT(
      {
        'id': userId,
        'username': username,
        // Bisa tambah exp (expiration) disini
      },
    );
    return jwt.sign(SecretKey(_secret), expiresIn: const Duration(minutes: 1));
  }
}
