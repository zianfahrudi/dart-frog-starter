import 'package:auth_feature/core/database.dart';
import 'package:auth_feature/repository/auth_repository.dart';
import 'package:auth_feature/repository/user_repository.dart';
import 'package:auth_feature/services/auth_service.dart';
import 'package:dart_frog/dart_frog.dart';

final _db = AppDatabase();

// Database _initDatabase() {
//   Env.load();

//   // return Database(
//   //   host: Env.get('DB_HOST'),
//   //   port: Env.getInt('DB_PORT'),
//   //   database: Env.get('DB_NAME'),
//   //   username: Env.get('DB_USER'),
//   //   // password: Env.get('DB_PASS'),
//   //   useSSL: Env.getBool('DB_SSL'),
//   // );
// }

// Inisialisasi Repository dengan DB tersebut
final _authRepo = AuthRepositoryImpl(_db);
final _userRepo = UserRepositoryImpl(_db);
final _authService = AuthService();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger()) // Log request yang masuk ke terminal

      // --- DEPENDENCY INJECTION ---
      .use(provider<AuthRepository>((_) => _authRepo))
      .use(provider<UserRepository>((_) => _userRepo))
      .use(provider<AuthService>((_) => _authService));
}
