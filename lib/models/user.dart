import 'package:souq_aljomaa/utils.dart';

class User {
  final int? id;
  final String? name;
  final String? username;
  final String? password;
  final bool isAdmin;
  final bool modelsModifier;

  User({
    this.id,
    this.name,
    this.username,
    this.password,
    this.isAdmin = false,
    this.modelsModifier = false,
  });

  User.fromJson(JsonMap json)
      : id = json['id'],
        name = json['name'],
        username = json['username'],
        password = json['password'],
        isAdmin = json['isAdmin'] == 1,
        modelsModifier = json['modelsModifier'] == 1;

  User.copyWith(
    User user, {
    int? id,
    String? name,
    String? username,
    String? password,
    bool? isAdmin,
    bool? modelsModifier,
  })  : id = id ?? user.id,
        name = name ?? user.name,
        username = username ?? user.username,
        password = password ?? user.password,
        isAdmin = isAdmin ?? user.isAdmin,
        modelsModifier = modelsModifier ?? user.modelsModifier;

  String get fullName => '${name ?? 'User'} ($username)';

  User copyWith({
    int? id,
    String? name,
    String? username,
    String? password,
    bool? isAdmin,
    bool? modelsModifier,
  }) =>
      User.copyWith(
        this,
        id: id,
        name: name,
        username: username,
        password: password,
        isAdmin: isAdmin,
        modelsModifier: modelsModifier,
      );

  JsonMap get toJson => {
        'id': id,
        'name': name,
        'username': username,
        'password': password,
        'isAdmin': isAdmin,
        'modelsModifier': modelsModifier,
      };

  bool get canModifyModels => isAdmin || modelsModifier;

  @override
  String toString() => Utils.getPrettyString(toJson);
}
