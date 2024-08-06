import 'dart:io';

import 'package:dio/dio.dart';
import 'package:souq_aljomaa/main.dart';
import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/models/model1.dart';
import 'package:souq_aljomaa/models/model2.dart';
import 'package:souq_aljomaa/models/model3.dart';
import 'package:souq_aljomaa/models/model4.dart';
import 'package:souq_aljomaa/models/model5.dart';
import 'package:souq_aljomaa/models/model6.dart';
import 'package:souq_aljomaa/models/model7.dart';
import 'package:souq_aljomaa/models/user.dart';
import 'package:souq_aljomaa/utils.dart';
import 'package:path/path.dart' as path;

abstract class Restful {
  static late Dio _dio;

  static void initialize([String? serverUrl]) async {
    _dio = Dio(
      BaseOptions(
        baseUrl: serverUrl ?? sharedPreferences.getString('serverUrl') ?? '',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.getString('access_token') ?? ''}',
        },
      ),
    );
  }

  // ========================= Auth related methods =========================
  static Future<Pair<String, User>?> login(String username, String password) async {
    try {
      final result = await _dio.post('/login', data: {
        'username': username,
        'password': password,
      });

      if (result.statusCode == 200) {
        final accessToken = result.data['access_token'] as String;
        final user = User.fromJson(result.data['current_user']);
        return Pair(accessToken, user);
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  static Future<Pair<String, User>?> autoLogin(String accessToken) async {
    try {
      final result = await _dio.post('/auto_login');

      if (result.statusCode == 200) {
        final accessToken = result.data['access_token'] as String;
        final user = User.fromJson(result.data['current_user']);
        return Pair(accessToken, user);
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  static Future<void> logout() async {
    _dio.post('/logout');
  }

  // ========================= Users related methods =========================

  static Future<User?> getUserById(int id) async {
    try {
      final response = await _dio.get('/users/$id');
      final statusCode = response.statusCode;
      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  static Future<Iterable<User>> getUsers({Iterable<int> ids = const []}) async {
    try {
      final response = await _dio.get('/users', data: {'ids': ids});
      final statusCode = response.statusCode;
      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        return [for (final jsonUser in response.data) User.fromJson(jsonUser)];
      }
    } catch (e) {
      log(e);
    }
    return [];
  }

  Future<User?> saveUser(User user) async {
    return user.id == null ? addUser(user) : editUser(user);
  }

  static Future<User?> addUser(User user) async {
    try {
      final response = await _dio.post('/users', data: user.toJson());
      final statusCode = response.statusCode;
      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  static Future<User?> editUser(User user) async {
    try {
      final response = await _dio.put('/users/${user.id}', data: user.toJson());
      final statusCode = response.statusCode;
      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  static Future<bool> deleteUser(User user) async {
    try {
      final response = await _dio.delete('/users/${user.id}');
      final statusCode = response.statusCode;
      return statusCode != null && statusCode >= 200 && statusCode < 300;
    } catch (e) {
      log(e);
    }
    return false;
  }

  // ========================= Model related methods =========================

  static Future<BaseModel?> saveModel(BaseModel model) async {
    return model.id == null ? addModel(model) : editModel(model);
  }

  static Future<BaseModel?> getModel(BaseModel model) async {
    if (model.id == null) throw Exception('Invalid model!! cant fet model, id is null');
    return getModelById(model.documentType, model.id!);
  }

  static Future<BaseModel?> getModelById(String modelType, int id) async {
    try {
      final response = await _dio.get('/models/$modelType/$id');
      final statusCode = response.statusCode;
      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        return _getModelFromData(modelType, response.data);
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  static Future<Iterable<BaseModel>> getModels(Map<String, Iterable<int>> modelsIds) async {
    try {
      final response = await _dio.get('/models', data: {'modelsIds': modelsIds});
      final statusCode = response.statusCode;
      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        final result = <BaseModel>[];
        for (final modelType in modelsIds.keys) {
          for (final json in response.data[modelType]) {
            result.add(_getModelFromData(modelType, json));
          }
        }
        return result;
      }
    } catch (e) {
      log(e);
    }
    return [];
  }

  static Future<Iterable<BaseModel>> search({String? searchText, int limit = 10, int offset = 0}) async {
    try {
      final response = await _dio.get('/search', queryParameters: {
        if (searchText != null) 'search_text': searchText,
        'limit': limit,
        'offset': offset,
      });
      final statusCode = response.statusCode;
      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        final result = <BaseModel>[];
        final data = response.data as JsonMap;
        for (final modelType in data.keys) {
          for (final modelData in data[modelType]) {
            result.add(_getModelFromData(modelType, modelData));
          }
        }
        return result;
      }
    } catch (e) {
      log(e);
    }

    return [];
  }

  static Future<bool> deleteModel(BaseModel model) async {
    if (model.id == null) throw Exception('Invalid model!! cant delete model, id is null');
    return deleteModelById(model.documentType, model.id!);
  }

  static Future<bool> deleteModelById(String tableName, int id) async {
    try {
      if (id < 0) throw Exception('Invalid id ($id)');
      if (id == 0) throw Exception('Admin user can not be deleted');
      if (tableName.isEmpty) throw Exception('Invalid tableName ($tableName)');

      final response = await _dio.delete('/models/$tableName/$id');
      final statusCode = response.statusCode;
      return statusCode != null && statusCode >= 200 && statusCode < 300;
    } catch (e) {
      log(e);
    }
    return false;
  }

  static Future<BaseModel?> addModel(BaseModel model) async {
    try {
      assert(model.id == null, "can't insert, id not null");

      model = _prepareModel(model);

      final response = await _dio.post('/models/${model.documentType}', data: model.toJson());
      final statusCode = response.statusCode;
      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        return _getModelFromData(model.documentType, response.data);
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  static BaseModel _getModelFromData(String modelType, JsonMap modelData) {
    switch (modelType) {
      case 'Model1':
        return Model1.fromJson(modelData);
      case 'Model2':
        return Model2.fromJson(modelData);
      case 'Model3':
        return Model3.fromJson(modelData);
      case 'Model4':
        return Model4.fromJson(modelData);
      case 'Model5':
        return Model5.fromJson(modelData);
      case 'Model6':
        return Model6.fromJson(modelData);
      case 'Model7':
        return Model7.fromJson(modelData);
      default:
        throw Exception('Unsupported Model Type $modelType');
    }
  }

  static Future<BaseModel?> editModel(BaseModel model) async {
    try {
      assert(model.id != null, "Null id, can't edit");

      model = _prepareModel(model);

      final response = await _dio.put('/models/${model.documentType}/${model.id}', data: model.toJson());
      final statusCode = response.statusCode;
      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        return _getModelFromData(model.documentType, response.data);
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  static BaseModel _prepareModel(BaseModel model) {
    if (model is Model1) model = model.copyWith(at: DateTime.now());
    if (model is Model2) model = model.copyWith(at: DateTime.now());
    if (model is Model3) model = model.copyWith(at: DateTime.now());
    if (model is Model4) model = model.copyWith(at: DateTime.now());
    if (model is Model5) model = model.copyWith(at: DateTime.now());
    if (model is Model6) model = model.copyWith(at: DateTime.now());
    if (model is Model7) model = model.copyWith(at: DateTime.now());
    return model;
  }

  static Future<bool> backup({required String savePath, String? password}) async {
    try {
      if (!Directory(savePath).existsSync()) throw Exception('Invalid directory ($savePath)');

      final response = await _dio.download('/backup', path.join(savePath, 'backup.db'), data: {'password': password});
      final statusCode = response.statusCode;
      return statusCode != null && statusCode >= 200 && statusCode < 300;
    } catch (e) {
      log(e);
    }
    return false;
  }

  static Future<bool> checkServer() async {
    try {
      final response = await _dio.get('');
      final statusCode = response.statusCode;
      return statusCode != null && statusCode == 200 && response.data == 'OK';
    } catch (e) {
      return false;
    }
  }
}
