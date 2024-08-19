import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/data_provider/restful.dart';
import 'package:souq_aljomaa/utils.dart';

class RestfulModelController {
  final _models = <BaseModel>{};

  List<BaseModel> get models => _models.toList();

  Future<Iterable<BaseModel>> search({String? searchText, int limit = 10, int offset = 0}) async {
    final models = await Restful.search(searchText: searchText, limit: limit, offset: offset);
    _models.addAll(models);
    return models;
  }

  Future<BaseModel?> saveModel(BaseModel model) async {
    return model.id == null ? addModel(model) : editModel(model);
  }


  Future<BaseModel?> addModel(BaseModel model) async {
    final result = await Restful.addModel(model);
    if (result != null) _models.add(result);
    return result;
  }

  Future<BaseModel?> editModel(BaseModel model) async {
    final result = await Restful.editModel(model);
    if (result != null) _models.replaceWhere((model) => model.id == result.id ? result : model);
    return result;
  }
  
  Future<bool> deleteModel(BaseModel model) async {
    final deleted = await Restful.deleteModel(model);
    if (deleted) _models.remove(model);
    return deleted;
  }

  void clear() => _models.clear();
}
