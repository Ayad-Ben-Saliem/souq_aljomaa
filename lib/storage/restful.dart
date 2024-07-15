import 'package:dio/dio.dart';
import 'package:souq_aljomaa/controllers/model_controller.dart';
import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/models/model1.dart';
import 'package:souq_aljomaa/models/model2.dart';
import 'package:souq_aljomaa/models/model3.dart';
import 'package:souq_aljomaa/models/model4.dart';
import 'package:souq_aljomaa/models/model5.dart';
import 'package:souq_aljomaa/models/model6.dart';
import 'package:souq_aljomaa/models/model7.dart';
import 'package:souq_aljomaa/utils.dart';

abstract class Restful {
  static final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5000'));

  // ========================= BaseModel =========================

  static Future<BaseModel?> saveModel(BaseModel model) async {
    if (model is Model1) model = model.copyWith(at: DateTime.now());
    if (model is Model2) model = model.copyWith(at: DateTime.now());
    if (model is Model3) model = model.copyWith(at: DateTime.now());
    if (model is Model4) model = model.copyWith(at: DateTime.now());
    if (model is Model5) model = model.copyWith(at: DateTime.now());
    if (model is Model6) model = model.copyWith(at: DateTime.now());
    if (model is Model7) model = model.copyWith(at: DateTime.now());

    return model.id == null ? _insertModel(model) : _editModel(model);
  }

  static Future<BaseModel?> getModel(BaseModel model) async {
    if (model.id == null) throw Exception('Invalid model!! cant fet model, id is null');
    return getModelById(model.documentType, model.id!);
  }

  static Future<BaseModel?> getModelById(String modelType, int id) async {
    final response = await _dio.get('/models/$modelType/$id');
    final statusCode = response.statusCode;
    if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      return _getModelFromData(modelType, response.data);
    }

    return null;
  }

  static Future<Iterable<BaseModel>> getModels(Map<String, Iterable<int>> modelsIds) async {
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
    return [];
  }

  static Future<Iterable<BaseModel>> search({int limit = 10, int offset = 0, SearchOptions? searchOptions}) async {
    final response = await _dio.get('/search', queryParameters: {
      'search_text': searchOptions?.text ?? '',
      'limit': limit,
      'offset': offset,
    });
    final statusCode = response.statusCode;
    if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      final result = <BaseModel>[];
      final data = response.data as JsonMap;
      for(final modelType in data.keys) {
        for(final modelData in data[modelType]) {
          result.add(_getModelFromData(modelType, modelData));
        }
      }
      return result;
    }
    return [];
  }
  
  static Future<bool> deleteModel(BaseModel model) async {
    if (model.id == null) throw Exception('Invalid model!! cant delete model, id is null');
    return deleteModelById(model.documentType, model.id!);
  }

  static Future<bool> deleteModelById(String tableName, int id) async {
    if (id < 0) throw Exception('Invalid id ($id)');
    if (tableName.isEmpty) throw Exception('Invalid tableName ($tableName)');

    final response = await _dio.delete('/models/$tableName/$id');
    final statusCode = response.statusCode;
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }

  static Future<BaseModel?> _insertModel(BaseModel model) async {
    assert(model.id == null, "can't insert, id not null");

    final response = await _dio.post('/models/${model.documentType}', data: model.toJson());
    final statusCode = response.statusCode;
    if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      return _getModelFromData(model.documentType, response.data);
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

  static Future<BaseModel?> _editModel(BaseModel model) async {
    assert(model.id != null, "Null id, can't edit");

    final response = await _dio.put('/models/${model.documentType}/${model.id}', data: model.toJson());
    final statusCode = response.statusCode;
    if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      return _getModelFromData(model.documentType, response.data);
    }

    return null;
  }
}
