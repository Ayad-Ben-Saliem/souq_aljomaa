import 'package:souq_aljomaa/models/user.dart';
import 'package:souq_aljomaa/data_provider/restful.dart';
import 'package:souq_aljomaa/utils.dart';

class RestfulUserController {
  final _users = <User>{};

  List<User> get users => _users.toList();

  Future<Iterable<User>> getUsers() async {
    final users = await Restful.getUsers();
    _users.addAll(users);
    return users;
  }

  Future<User?> saveUser(User user) async {
    return user.id == null ? addUser(user) : editUser(user);
  }

  Future<User?> addUser(User user) async {
    final result = await Restful.addUser(user);
    if (result != null) _users.add(result);
    return result;
  }

  Future<User?> editUser(User user) async {
    final result = await Restful.editUser(user);
    if (result != null) _users.replaceWhere((user) => user.id == result.id ? result : user);
    return result;
  }

  Future<bool> deleteUser(User user) async {
    final deleted = await Restful.deleteUser(user);
    if (deleted) _users.remove(user);
    return deleted;
  }

  void clear() => _users.clear();
}
