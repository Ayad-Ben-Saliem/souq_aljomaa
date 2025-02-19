import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/data_provider/db.dart';

class DatabaseController {
  final _models = <BaseModel>{};

  List<BaseModel> get models => _models.toList();

  Future<T?> getOne<T extends BaseModel>(int id) async {
    final model = await Database.getModel(id) as T;
    _models.add(model);
    return model;
  }

  Future<Iterable<BaseModel>> search({required String searchText, int limit = 10, int offset = 0}) async {
    final models = await Database.search(searchText: searchText, limit: limit, offset: offset);
    _models.addAll(models);
    return models;
  }

  Future<BaseModel> save(BaseModel model) async {
    model = await Database.saveModel(model);
    _models.add(model);
    return model;
  }

  Future<bool> deleteModel(BaseModel model) async {
    final deleted = await Database.deleteModel(model);
    if (deleted) _models.remove(model);
    return deleted;
  }

  Future<bool> deleteModelById<T extends BaseModel>(int id, {String tableName = ''}) async {
    final deleted = await Database.deleteModelById(id);
    if (deleted) {
      for (final model in _models) {
        if (model.id == id) {
          _models.remove(model);
          break;
        }
      }
    }
    return deleted;
  }

  void clear() => _models.clear();
}
