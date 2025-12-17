// ignore_for_file: public_member_api_docs

import 'package:stormberry/stormberry.dart';
part 'user_model.schema.dart';

@Model()
abstract class User {
  @PrimaryKey()
  @AutoIncrement()
  int get id;

  String get username;
  String get password;
}
