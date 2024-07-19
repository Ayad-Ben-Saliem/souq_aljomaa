import 'package:souq_aljomaa/main.dart';
import 'package:souq_aljomaa/models/user.dart';
import 'package:souq_aljomaa/data_provider/restful.dart';

class RestfulAuthController {
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<User?> login(String username, String password) async {
    final result = await Restful.login(username, password);
    if (result != null) {
      sharedPreferences.setString('access_token', result.key);
      Restful.initialize();
      _currentUser = result.value;
    }
    return _currentUser;
  }

  Future<void> logout() async {
    _currentUser = null;
    await Restful.logout();
    sharedPreferences.remove('access_token');
    Restful.initialize();
  }

  Future<User?> autoLogin(String accessToken) async {
    await Future.delayed(Duration(seconds: 1));
    final result = await Restful.autoLogin(accessToken);
    await Future.delayed(Duration(seconds: 1));
    if (result != null) {
      sharedPreferences.setString('access_token', result.key);
      _currentUser = result.value;
    }
    return _currentUser;

  }
}
