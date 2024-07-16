import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/storage/restful.dart';


class RestfulController {
  final _models = <BaseModel>{};

  List<BaseModel> get models => _models.toList();

  Future<Iterable<BaseModel>> search({String? searchText, int limit = 10, int offset = 0}) async {
    final models = await Restful.search(searchText: searchText, limit: limit, offset: offset);
    _models.addAll(models);
    return models;
  }

  Future<BaseModel?> save(BaseModel model) async {
    final result = await Restful.saveModel(model);
    if (result != null) _models.add(result);
    return result;
  }

  Future<bool> deleteModel(BaseModel model) async {
    final deleted = await Restful.deleteModel(model);
    if (deleted) _models.remove(model);
    return deleted;
  }

  void clear() => _models.clear();
}
