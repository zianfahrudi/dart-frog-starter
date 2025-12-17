// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:auth_feature/models/auth/user_model.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';

part 'database.g.dart';

@DriftDatabase(tables: [User])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  static QueryExecutor _openConnection() {
    return NativeDatabase.opened(sqlite3.open('rare-transom.db'));
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      // Logika saat upgrade versi
      onUpgrade: (Migrator m, int from, int to) async {
        // Jika user update dari versi 1 ke 2 (atau lebih tinggi)
        if (from < 2) {
          // Tambahkan kolom 'role' ke tabel 'users'
          await m.addColumn(user, user.role);
        }

        // Jika nanti ada update ke versi 3, tambahkan logic if (from < 3) di sini
      },

      // (Opsional) Memastikan foreign key tetap jalan
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
