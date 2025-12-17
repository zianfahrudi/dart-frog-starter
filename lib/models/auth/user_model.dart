// // ignore_for_file: public_member_api_docs

// import 'package:stormberry/stormberry.dart';
// part 'user_model.schema.dart';

// @Model()
// abstract class User {
//   @PrimaryKey()
//   @AutoIncrement()
//   int get id;

// ignore_for_file: public_member_api_docs

//   String get username;
//   String get password;
// }
import 'package:drift/drift.dart';

class User extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(min: 6, max: 32)();
  TextColumn get password => text().named('password')();
  TextColumn get role => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}
