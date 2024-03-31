import 'dart:convert';

import 'package:path_provider/path_provider.dart';
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
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:path/path.dart' as Path;

abstract class Database {
  static late final sqlite.Database _db;

  static bool _initialized = false;

  static void initialize() async {
    if (!_initialized) {
      final path = await getApplicationDocumentsDirectory();
      final filename = Path.join(path.path, 'database.db');
      _db = sqlite.sqlite3.open(filename);
      _initializeTables();
      // _db.execute('SELECT load_extension("libsqlitefunctions.so")');
      _initialized = true;
    }
  }

  static void _initializeTables() {
    _db.execute('''
      CREATE TABLE IF NOT EXISTS Model1 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        at TEXT NOT NULL,
        scanner TEXT,
        locality TEXT NOT NULL,
        witness TEXT NOT NULL,
        responsible TEXT NOT NULL,
        firstName TEXT NOT NULL,
        fatherName TEXT NOT NULL,
        grandfatherName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        motherName TEXT NOT NULL,
        identifierNo TEXT,
        nationalId TEXT NOT NULL,
        testimony TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS Model2 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        at TEXT NOT NULL,
        scanner TEXT,
        locality TEXT NOT NULL,
        witness TEXT NOT NULL,
        responsible TEXT NOT NULL,
        firstName TEXT NOT NULL,
        fatherName TEXT NOT NULL,
        grandfatherName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        identifierNo TEXT,
        identifierFrom TEXT,
        nationalId TEXT NOT NULL,
        testimony TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS Model3 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        at TEXT NOT NULL,
        scanner TEXT,
        locality TEXT NOT NULL,
        witness TEXT NOT NULL,
        responsible TEXT NOT NULL,
        firstName TEXT NOT NULL,
        fatherName TEXT NOT NULL,
        grandfatherName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        identifierNo TEXT,
        identifierFrom TEXT,
        nationalId TEXT NOT NULL,
        testimony TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS Model4 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        at TEXT NOT NULL,
        scanner TEXT,
        locality TEXT NOT NULL,
        witness TEXT NOT NULL,
        responsible TEXT NOT NULL,
        firstName TEXT NOT NULL,
        fatherName TEXT NOT NULL,
        grandfatherName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        identifierNo TEXT,
        identifierFrom TEXT,
        nationalId TEXT NOT NULL,
        testimony TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    // TODO: not completed
    _db.execute('''
      CREATE TABLE IF NOT EXISTS Model5 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        at TEXT NOT NULL,
        scanner TEXT,
        locality TEXT NOT NULL,
        witness TEXT NOT NULL,
        responsible TEXT NOT NULL,
        firstName TEXT NOT NULL,
        fatherName TEXT NOT NULL,
        grandfatherName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        motherName TEXT NOT NULL,
        identifierNo TEXT,
        nationalId TEXT NOT NULL,
        familyBookletNumber TEXT NOT NULL,
        familyDocumentNumber TEXT NOT NULL,
        issuePlace TEXT NOT NULL,
        issueDate TEXT NOT NULL,
        residence TEXT NOT NULL,
        nearestPoint TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS Model6 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        at TEXT NOT NULL,
        scanner TEXT,
        ownerName TEXT NOT NULL,
        ownerPhone TEXT NOT NULL,
        tenantName TEXT NOT NULL,
        tenantPhone TEXT NOT NULL,
        streetCode TEXT NOT NULL,
        shopNo TEXT NOT NULL,
        businessType TEXT NOT NULL,
        businessCategory TEXT NOT NULL
      )
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS Model7 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        at TEXT NOT NULL,
        scanner TEXT,
        streetNo TEXT NOT NULL,
        buildingNo TEXT NOT NULL,
        registrationNo TEXT NOT NULL,
        familyHeadName TEXT NOT NULL,
        malesCount INTEGER NOT NULL,
        femalesCount INTEGER NOT NULL,
        widows INTEGER,
        divorced INTEGER,
        disabilities TEXT,
        lowIncome TEXT,
        unemployed TEXT,
        familyHeadDeathDate TEXT,
        currentFamilyHeadName TEXT,
        formFiller TEXT NOT NULL,
        notes TEXT
      )
    ''');
  }

  // ========================= BaseModel =========================

  static Future<BaseModel> saveModel(BaseModel model) async {
    if (model is Model1) return saveModel1(model);
    if (model is Model2) return saveModel2(model);
    if (model is Model3) return saveModel3(model);
    if (model is Model4) return saveModel4(model);
    if (model is Model5) return saveModel5(model);
    if (model is Model6) return saveModel6(model);
    if (model is Model7) return saveModel7(model);

    throw Exception('Model (${model.runtimeType}) not supported.');
  }

  static Future<T?> getModel<T extends BaseModel>(int id) async {
    if (T == Model1) return getModel1(id) as T;
    if (T == Model2) return getModel2(id) as T;
    if (T == Model3) return getModel3(id) as T;
    if (T == Model4) return getModel4(id) as T;
    if (T == Model5) return getModel5(id) as T;
    if (T == Model6) return getModel6(id) as T;

    throw Exception('Model (${T.runtimeType}) not supported');
  }

  static String _whereQuery(List<String> fieldsName, String searchText) {
    if (fieldsName.isEmpty || searchText.isEmpty) return '';

    var result = 'WHERE ';
    for (final txt in searchText.split(' ')) {
      result += '(';
      for (final fieldName in fieldsName) {
        result += "$fieldName LIKE '%$txt%' OR ";
      }
      result = result.substring(0, result.length - 4);
      result += ') AND ';
    }

    result = result.substring(0, result.length - 5);
    return result;
  }

  static Future<Iterable<BaseModel>> search({int limit = 10, int offset = 0, SearchOptions? searchOptions}) async {
    final model1Fields = [
      'locality',
      'witness',
      'responsible',
      'firstName',
      'fatherName',
      'grandfatherName',
      'lastName',
      'motherName',
      'identifierNo',
      'nationalId',
      'testimony',
    ];
    final model234Fields = [
      'locality',
      'witness',
      'responsible',
      'firstName',
      'fatherName',
      'grandfatherName',
      'lastName',
      'identifierNo',
      'identifierFrom',
      'nationalId',
      'testimony',
    ];
    final model5Fields = [
      'locality',
      'witness',
      'responsible',
      'firstName',
      'fatherName',
      'grandfatherName',
      'lastName',
      'motherName',
      'identifierNo',
      'nationalId',
      'familyBookletNumber',
      'familyDocumentNumber',
      'issuePlace',
      'issueDate',
      'residence',
      'nearestPoint',
    ];
    final model6Fields = [
      'ownerName',
      'ownerPhone',
      'tenantName',
      'tenantPhone',
      'streetCode',
      'shopNo',
      'businessType',
      'businessCategory',
    ];
    final model7Fields = [
      'streetNo',
      'buildingNo',
      'registrationNo',
      'familyHeadName',
      'malesCount',
      'femalesCount',
      'widows',
      'divorced',
      'disabilities',
      'lowIncome',
      'unemployed',
      'familyHeadDeathDate',
      'currentFamilyHeadName',
      'formFiller',
      'notes',
    ];

    final result = _db.select('''
      SELECT id, at, 'Model1' AS table_name FROM Model1
      ${_whereQuery(model1Fields, searchOptions?.text ?? '')}
      UNION ALL
      SELECT id, at, 'Model2' AS table_name FROM Model2
      ${_whereQuery(model234Fields, searchOptions?.text ?? '')}
      UNION ALL
      SELECT id, at, 'Model3' AS table_name FROM Model3
      ${_whereQuery(model234Fields, searchOptions?.text ?? '')}
      UNION ALL
      SELECT id, at, 'Model4' AS table_name FROM Model4
      ${_whereQuery(model234Fields, searchOptions?.text ?? '')}
      UNION ALL
      SELECT id, at, 'Model5' AS table_name FROM Model5
      ${_whereQuery(model5Fields, searchOptions?.text ?? '')}
      UNION ALL
      SELECT id, at, 'Model6' AS table_name FROM Model6
      ${_whereQuery(model6Fields, searchOptions?.text ?? '')}
      UNION ALL
      SELECT id, at, 'Model7' AS table_name FROM Model7
      ${_whereQuery(model7Fields, searchOptions?.text ?? '')}
      ORDER BY at DESC
      LIMIT $limit OFFSET $offset
    ''');

    final ids = _splitIds(result);
    final models = await _getModelsByIds(ids);

    models.sort((model1, model2) => model1.at!.compareTo(model2.at!));

    return models;
  }

  static Map<String, List<int>> _splitIds(sqlite.ResultSet result) {
    final tableNames = ['Model1', 'Model2', 'Model3', 'Model4', 'Model5', 'Model6', 'Model7'];
    final ids = <String, List<int>>{};

    for (final row in result) {
      for (final tableName in tableNames) {
        if (row['table_name'] == tableName) {
          if (!ids.containsKey(tableName)) {
            ids[tableName] = [row['id']];
          } else {
            ids[tableName]!.add(row['id']);
          }
          break;
        }
      }
    }
    return ids;
  }

  static Future<List<BaseModel>> _getModelsByIds(Map<String, List<int>> allIds) async {
    final result = <BaseModel>[];
    for (final tableName in allIds.keys) {
      final ids = allIds[tableName];
      switch (tableName) {
        case 'Model1':
          result.addAll(await getAllModel1(ids: ids));
        case 'Model2':
          result.addAll(await getAllModel2(ids: ids));
        case 'Model3':
          result.addAll(await getAllModel3(ids: ids));
        case 'Model4':
          result.addAll(await getAllModel4(ids: ids));
        case 'Model5':
          result.addAll(await getAllModel5(ids: ids));
        case 'Model6':
          result.addAll(await getAllModel6(ids: ids));
        case 'Model7':
          result.addAll(await getAllModel7(ids: ids));
        default:
          throw Exception('not implemented yet.');
      }
    }
    return result;
  }

  static Future<bool> deleteModel(BaseModel model) async {
    if (model.id == null) throw Exception('Invalid model!! cant delete model, id is null');
    if (model is Model1) return deleteModelById(model.id!, tableName: 'Model1');
    if (model is Model2) return deleteModelById(model.id!, tableName: 'Model2');
    if (model is Model3) return deleteModelById(model.id!, tableName: 'Model3');
    if (model is Model4) return deleteModelById(model.id!, tableName: 'Model4');
    if (model is Model5) return deleteModelById(model.id!, tableName: 'Model5');
    if (model is Model6) return deleteModelById(model.id!, tableName: 'Model6');
    if (model is Model7) return deleteModelById(model.id!, tableName: 'Model7');

    throw Exception('Model (${model.runtimeType}) not supported');
  }

  static Future<bool> deleteModelById<T extends BaseModel>(int id, {String tableName = ''}) async {
    if (tableName.isEmpty) {
      switch (T) {
        case const (Model1):
          tableName = 'Model1';
          break;
        case const (Model2):
          tableName = 'Model1';
          break;
        case const (Model3):
          tableName = 'Model1';
          break;
        case const (Model4):
          tableName = 'Model1';
          break;
        case const (Model5):
          tableName = 'Model1';
          break;
        case const (Model6):
          tableName = 'Model1';
          break;
        case const (Model7):
          tableName = 'Model1';
          break;
        default:
          throw Exception('Model (${T.runtimeType}) not supported');
      }
    }

    _db.execute('DELETE FROM $tableName WHERE id = ?', [id]);

    return true;
  }

  // ========================= Model1 =========================

  static Future<Model1> saveModel1(Model1 model) async {
    model = model.copyWith(at: DateTime.now());
    return model.id == null ? _insertModel1(model) : _editModel1(model);
  }

  static Future<Model1> _insertModel1(Model1 model) async {
    assert(model.id == null, "can't insert, id not null");

    _db.execute(
      '''
      INSERT INTO Model1 (
        at,
        scanner,
        locality,
        witness,
        responsible,
        firstName,
        fatherName,
        grandfatherName,
        lastName,
        motherName,
        identifierNo,
        nationalId,
        testimony,
        date
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        model.at!.toIso8601String(),
        model.scanner,
        model.locality,
        model.witness,
        model.responsible,
        model.firstName,
        model.fatherName,
        model.grandfatherName,
        model.lastName,
        model.motherName,
        model.identifierNo,
        model.nationalId,
        model.testimony,
        model.date.toIso8601String(),
      ],
    );

    return model.copyWith(id: _db.lastInsertRowId);
  }

  static Future<Model1> _editModel1(Model1 model) async {
    assert(model.id != null, "Null id, can't edit");

    _db.execute(
      '''
      UPDATE Model1
      SET 
        at = ?,
        scanner = ?,
        locality = ?,
        witness = ?,
        responsible = ?,
        firstName = ?,
        fatherName = ?,
        grandfatherName = ?,
        lastName = ?,
        motherName = ?,
        identifierNo = ?,
        nationalId = ?,
        testimony = ?,
        date = ?
      WHERE
        id = ?;
      ''',
      [
        model.at!.toIso8601String(),
        model.scanner,
        model.locality,
        model.witness,
        model.responsible,
        model.firstName,
        model.fatherName,
        model.grandfatherName,
        model.lastName,
        model.motherName,
        model.identifierNo,
        model.nationalId,
        model.testimony,
        model.date.toIso8601String(),
        model.id,
      ],
    );

    return model;
  }

  static Future<Model1?> getModel1(int id) async {
    final result = _db.select('SELECT * FROM Model1 WHERE id = ?', [id]);
    if (result.isEmpty) return null;

    return Model1.fromJson(JsonMap.from(result.single));
  }

  static Future<Iterable<Model1>> getAllModel1({Iterable<int>? ids}) async {
    var query = 'SELECT * FROM Model1';
    if (ids != null) query += ' WHERE id IN ${_whereInQuery(ids)}';
    final result = _db.select(query);

    return [for (final row in result) Model1.fromJson(JsonMap.from(row))];
  }

  // ========================= Model2 =========================

  static Future<Model2> saveModel2(Model2 model) async {
    model = model.copyWith(at: DateTime.now());
    return model.id == null ? _insertModel2(model) : _editModel2(model);
  }

  static Future<Model2> _insertModel2(Model2 model) async {
    assert(model.id == null, "can't insert, id not null");

    _db.execute(
      '''
      INSERT INTO Model2 (
        at,
        scanner,
        locality,
        witness,
        responsible,
        firstName,
        fatherName,
        grandfatherName,
        lastName,
        identifierNo,
        identifierFrom,
        nationalId,
        testimony,
        date
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        model.at!.toIso8601String(),
        model.scanner,
        model.locality,
        model.witness,
        model.responsible,
        model.firstName,
        model.fatherName,
        model.grandfatherName,
        model.lastName,
        model.identifierNo,
        model.identifierFrom,
        model.nationalId,
        model.testimony,
        model.date.toIso8601String(),
      ],
    );

    return model.copyWith(id: _db.lastInsertRowId);
  }

  static Future<Model2> _editModel2(Model2 model) async {
    assert(model.id != null, "Null id, can't edit");

    _db.execute(
      '''
      UPDATE Model2
      SET 
        at = ?,
        scanner = ?,
        locality = ?,
        witness = ?,
        responsible = ?,
        firstName = ?,
        fatherName = ?,
        grandfatherName = ?,
        lastName = ?,
        identifierNo = ?,
        identifierFrom = ?,
        nationalId = ?,
        testimony = ?,
        date = ?
      WHERE
        id = ?;
      ''',
      [
        model.at!.toIso8601String(),
        model.scanner,
        model.locality,
        model.witness,
        model.responsible,
        model.firstName,
        model.fatherName,
        model.grandfatherName,
        model.lastName,
        model.identifierNo,
        model.identifierFrom,
        model.nationalId,
        model.testimony,
        model.date.toIso8601String(),
        model.id,
      ],
    );

    return model;
  }

  static Future<Model2?> getModel2(int id) async {
    final result = _db.select('SELECT * FROM Model2 WHERE id = ?', [id]);
    if (result.isEmpty) return null;

    return Model2.fromJson(JsonMap.from(result.single));
  }

  static Future<Iterable<Model2>> getAllModel2({Iterable<int>? ids}) async {
    var query = 'SELECT * FROM Model2';
    if (ids != null) query += ' WHERE id IN ${_whereInQuery(ids)}';
    final result = _db.select(query);

    return [for (final row in result) Model2.fromJson(JsonMap.from(row))];
  }

  // ========================= Model3 =========================

  static Future<Model3> saveModel3(Model3 model) async {
    model = model.copyWith(at: DateTime.now());
    return model.id == null ? _insertModel3(model) : _editModel3(model);
  }

  static Future<Model3> _insertModel3(Model3 model) async {
    assert(model.id == null, "can't insert, id not null");

    _db.execute(
      '''
      INSERT INTO Model3 (
        at,
        scanner,
        locality,
        witness,
        responsible,
        firstName,
        fatherName,
        grandfatherName,
        lastName,
        identifierNo,
        identifierFrom,
        nationalId,
        testimony,
        date
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        model.at!.toIso8601String(),
        model.scanner,
        model.locality,
        model.witness,
        model.responsible,
        model.firstName,
        model.fatherName,
        model.grandfatherName,
        model.lastName,
        model.identifierNo,
        model.identifierFrom,
        model.nationalId,
        model.testimony,
        model.date.toIso8601String(),
      ],
    );

    return model.copyWith(id: _db.lastInsertRowId);
  }

  static Future<Model3> _editModel3(Model3 model) async {
    assert(model.id != null, "Null id, can't edit");

    _db.execute(
      '''
      UPDATE Model3
      SET 
        at = ?,
        scanner = ?,
        locality = ?,
        witness = ?,
        responsible = ?,
        firstName = ?,
        fatherName = ?,
        grandfatherName = ?,
        lastName = ?,
        identifierNo = ?,
        identifierFrom = ?,
        nationalId = ?,
        testimony = ?,
        date = ?
      WHERE
        id = ?;
      ''',
      [
        model.at!.toIso8601String(),
        model.scanner,
        model.locality,
        model.witness,
        model.responsible,
        model.firstName,
        model.fatherName,
        model.grandfatherName,
        model.lastName,
        model.identifierNo,
        model.identifierFrom,
        model.nationalId,
        model.testimony,
        model.date.toIso8601String(),
        model.id,
      ],
    );

    return model;
  }

  static Future<Model3?> getModel3(int id) async {
    final result = _db.select('SELECT * FROM Model3 WHERE id = ?', [id]);
    if (result.isEmpty) return null;

    return Model3.fromJson(JsonMap.from(result.single));
  }

  static Future<Iterable<Model3>> getAllModel3({Iterable<int>? ids}) async {
    var query = 'SELECT * FROM Model3';
    if (ids != null) query += ' WHERE id IN ${_whereInQuery(ids)}';
    final result = _db.select(query);

    return [for (final row in result) Model3.fromJson(JsonMap.from(row))];
  }

  // ========================= Model4 =========================

  static Future<Model4> saveModel4(Model4 model) async {
    model = model.copyWith(at: DateTime.now());
    return model.id == null ? _insertModel4(model) : _editModel4(model);
  }

  static Future<Model4> _insertModel4(Model4 model) async {
    assert(model.id == null, "can't insert, id not null");

    _db.execute(
      '''
      INSERT INTO Model4 (
        at,
        scanner,
        locality,
        witness,
        responsible,
        firstName,
        fatherName,
        grandfatherName,
        lastName,
        identifierNo,
        identifierFrom,
        nationalId,
        testimony,
        date
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        model.at!.toIso8601String(),
        model.scanner,
        model.locality,
        model.witness,
        model.responsible,
        model.firstName,
        model.fatherName,
        model.grandfatherName,
        model.lastName,
        model.identifierNo,
        model.identifierFrom,
        model.nationalId,
        model.testimony,
        model.date.toIso8601String(),
      ],
    );

    return model.copyWith(id: _db.lastInsertRowId);
  }

  static Future<Model4> _editModel4(Model4 model) async {
    assert(model.id != null, "Null id, can't edit");

    _db.execute(
      '''
      UPDATE Model4
      SET 
        at = ?,
        scanner = ?,
        locality = ?,
        witness = ?,
        responsible = ?,
        firstName = ?,
        fatherName = ?,
        grandfatherName = ?,
        lastName = ?,
        identifierNo = ?,
        identifierFrom = ?,
        nationalId = ?,
        testimony = ?,
        date = ?
      WHERE
        id = ?;
      ''',
      [
        model.at!.toIso8601String(),
        model.scanner,
        model.locality,
        model.witness,
        model.responsible,
        model.firstName,
        model.fatherName,
        model.grandfatherName,
        model.lastName,
        model.identifierNo,
        model.identifierFrom,
        model.nationalId,
        model.testimony,
        model.date.toIso8601String(),
        model.id,
      ],
    );

    return model;
  }

  static Future<Model4?> getModel4(int id) async {
    final result = _db.select('SELECT * FROM Model4 WHERE id = ?', [id]);
    if (result.isEmpty) return null;

    return Model4.fromJson(JsonMap.from(result.single));
  }

  static Future<Iterable<Model4>> getAllModel4({Iterable<int>? ids}) async {
    var query = 'SELECT * FROM Model4';
    if (ids != null) query += ' WHERE id IN ${_whereInQuery(ids)}';
    final result = _db.select(query);

    return [for (final row in result) Model4.fromJson(JsonMap.from(row))];
  }

  // ========================= Model5 =========================

  static Future<Model5> saveModel5(Model5 model) async {
    model = model.copyWith(at: DateTime.now());
    return model.id == null ? _insertModel5(model) : _editModel5(model);
  }

  static Future<Model5> _insertModel5(Model5 model) async {
    assert(model.id == null, "can't insert, id not null");

    _db.execute(
      '''
      INSERT INTO Model5 (
        at,
        scanner,
        locality,
        witness,
        responsible,
        firstName,
        fatherName,
        grandfatherName,
        lastName,
        motherName,
        identifierNo,
        nationalId,
        familyBookletNumber,
        familyDocumentNumber,
        issuePlace,
        issueDate,
        residence,
        nearestPoint,
        date
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        model.at!.toIso8601String(),
        model.scanner,
        model.locality,
        model.witness,
        model.responsible,
        model.firstName,
        model.fatherName,
        model.grandfatherName,
        model.lastName,
        model.motherName,
        model.identifierNo,
        model.nationalId,
        model.familyBookletNumber,
        model.familyDocumentNumber,
        model.issuePlace,
        model.issueDate,
        model.residence,
        model.nearestPoint,
        model.date.toIso8601String(),
      ],
    );

    return model.copyWith(id: _db.lastInsertRowId);
  }

  static Future<Model5> _editModel5(Model5 model) async {
    assert(model.id != null, "Null id, can't edit");

    _db.execute(
      '''
      UPDATE Model3
      SET 
        at = ?,
        scanner = ?,
        locality = ?,
        witness = ?,
        responsible = ?,
        firstName = ?,
        fatherName = ?,
        grandfatherName = ?,
        lastName = ?,
        motherName = ?,
        identifierNo = ?,
        nationalId = ?,
        familyBookletNumber = ?,
        familyDocumentNumber = ?,
        issuePlace = ?,
        issueDate = ?,
        residence = ?,
        nearestPoint = ?,
        date = ?
      WHERE
        id = ?;
      ''',
      [
        model.at!.toIso8601String(),
        model.scanner,
        model.locality,
        model.witness,
        model.responsible,
        model.firstName,
        model.fatherName,
        model.grandfatherName,
        model.lastName,
        model.motherName,
        model.identifierNo,
        model.nationalId,
        model.familyBookletNumber,
        model.familyDocumentNumber,
        model.issuePlace,
        model.issueDate,
        model.residence,
        model.nearestPoint,
        model.date.toIso8601String(),
        model.id,
      ],
    );

    return model;
  }

  static Future<Model5?> getModel5(int id) async {
    final result = _db.select('SELECT * FROM Model5 WHERE id = ?', [id]);
    if (result.isEmpty) return null;

    return Model5.fromJson(JsonMap.from(result.single));
  }

  static Future<Iterable<Model5>> getAllModel5({Iterable<int>? ids}) async {
    var query = 'SELECT * FROM Model5';
    if (ids != null) query += ' WHERE id IN ${_whereInQuery(ids)}';
    final result = _db.select(query);

    return [for (final row in result) Model5.fromJson(JsonMap.from(row))];
  }

  // ========================= Model6 =========================

  static Future<Model6> saveModel6(Model6 model) async {
    model = model.copyWith(at: DateTime.now());
    return model.id == null ? _insertModel6(model) : _editModel6(model);
  }

  static Future<Model6> _insertModel6(Model6 model) async {
    assert(model.id == null, "can't insert, id not null");

    // TODO: not completed
    _db.execute(
      '''
      INSERT INTO Model6 (
        at,
        scanner,
        ownerName,
        ownerPhone,
        tenantName,
        tenantPhone,
        streetCode,
        shopNo,
        businessType,
        businessCategory
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        model.at!.toIso8601String(),
        model.scanner,
        model.ownerName,
        model.ownerPhone,
        model.tenantName,
        model.tenantPhone,
        model.streetCode,
        model.shopNo,
        model.businessType,
        model.businessCategory,
      ],
    );

    return model.copyWith(id: _db.lastInsertRowId);
  }

  static Future<Model6> _editModel6(Model6 model) async {
    assert(model.id != null, "Null id, can't edit");

    _db.execute(
      '''
      UPDATE Model3
      SET 
        at = ?,
        scanner = ?,
        ownerName = ?,
        ownerPhone = ?,
        tenantName = ?,
        tenantPhone = ?,
        streetCode = ?,
        shopNo = ?,
        businessType = ?,
        businessCategory = ?
      WHERE
        id = ?;
      ''',
      [
        model.at!.toIso8601String(),
        model.scanner,
        model.ownerName,
        model.ownerPhone,
        model.tenantName,
        model.tenantPhone,
        model.streetCode,
        model.shopNo,
        model.businessType,
        model.businessCategory,
        model.id,
      ],
    );

    return model;
  }

  static Future<Model6?> getModel6(int id) async {
    final result = _db.select('SELECT * FROM Model6 WHERE id = ?', [id]);
    if (result.isEmpty) return null;

    return Model6.fromJson(JsonMap.from(result.single));
  }

  static Future<Iterable<Model6>> getAllModel6({Iterable<int>? ids}) async {
    var query = 'SELECT * FROM Model6';
    if (ids != null) query += ' WHERE id IN ${_whereInQuery(ids)}';
    final result = _db.select(query);

    return [for (final row in result) Model6.fromJson(JsonMap.from(row))];
  }

  // ========================= Model7 =========================

  static Future<Model7> saveModel7(Model7 model) async {
    model = model.copyWith(at: DateTime.now());
    return model.id == null ? _insertModel7(model) : _editModel7(model);
  }

  static Future<Model7> _insertModel7(Model7 model) async {
    assert(model.id == null, "can't insert, id not null");

    const jsonEncoder = JsonEncoder();
    final widows = jsonEncoder.convert([for (final widow in model.widows) widow.toJson()]);
    final divorced = jsonEncoder.convert([for (final divorced in model.divorced) divorced.toJson()]);
    final disabilities = jsonEncoder.convert(model.disabilities?.toJson());
    final lowIncome = jsonEncoder.convert([for (final lowIncome in model.lowIncome) lowIncome.toJson()]);
    final unemployed = jsonEncoder.convert([for (final unemployed in model.unemployed) unemployed.toJson()]);
    final formFiller = jsonEncoder.convert(model.formFiller.toJson());

    _db.execute(
      '''
      INSERT INTO Model7 (
        at,
        scanner,
        streetNo,
        buildingNo,
        registrationNo,
        familyHeadName,
        malesCount,
        femalesCount,
        widows,
        divorced,
        disabilities,
        lowIncome,
        unemployed,
        familyHeadDeathDate,
        currentFamilyHeadName,
        formFiller,
        notes
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        model.at!.toIso8601String(),
        model.scanner,
        model.streetNo,
        model.buildingNo,
        model.registrationNo,
        model.familyHeadName,
        model.malesCount,
        model.femalesCount,
        widows,
        divorced,
        disabilities,
        lowIncome,
        unemployed,
        model.familyHeadDeathDate,
        model.currentFamilyHeadName,
        formFiller,
        model.notes
      ],
    );

    return model.copyWith(id: _db.lastInsertRowId);
  }

  static Future<Model7> _editModel7(Model7 model) async {
    assert(model.id != null, "Null id, can't edit");

    const jsonEncoder = JsonEncoder();
    final widows = jsonEncoder.convert([for (final widow in model.widows) widow.toJson()]);
    final divorced = jsonEncoder.convert([for (final divorced in model.divorced) divorced.toJson()]);
    final disabilities = jsonEncoder.convert(model.disabilities?.toJson());
    final lowIncome = jsonEncoder.convert([for (final lowIncome in model.lowIncome) lowIncome.toJson()]);
    final unemployed = jsonEncoder.convert([for (final unemployed in model.unemployed) unemployed.toJson()]);
    final formFiller = jsonEncoder.convert(model.formFiller.toJson());

    _db.execute(
      '''
      UPDATE Model3
      SET 
        at = ?,
        scanner = ?,
        streetNo = ?,
        buildingNo = ?,
        registrationNo = ?,
        familyHeadName = ?,
        malesCount = ?,
        femalesCount = ?,
        widows = ?,
        divorced = ?,
        disabilities = ?,
        lowIncome = ?,
        unemployed = ?,
        familyHeadDeathDate = ?,
        currentFamilyHeadName = ?,
        formFiller = ?,
        notes = ?
      WHERE
        id = ?;
      ''',
      [
        model.at!.toIso8601String(),
        model.scanner,
        model.streetNo,
        model.buildingNo,
        model.registrationNo,
        model.familyHeadName,
        model.malesCount,
        model.femalesCount,
        widows,
        divorced,
        disabilities,
        lowIncome,
        unemployed,
        model.familyHeadDeathDate,
        model.currentFamilyHeadName,
        formFiller,
        model.notes,
        model.id,
      ],
    );

    return model;
  }

  static Future<Model7?> getModel7(int id) async {
    final result = _db.select('SELECT * FROM Model7 WHERE id = ?', [id]);
    if (result.isEmpty) return null;

    return Model7.fromJson(_mapModel7Json(result.single));
  }

  static Future<Iterable<Model7>> getAllModel7({Iterable<int>? ids}) async {
    var query = 'SELECT * FROM Model7';
    if (ids != null) query += ' WHERE id IN ${_whereInQuery(ids)}';
    final result = _db.select(query);

    return [for (final row in result) Model7.fromJson(_mapModel7Json(row))];
  }

  static JsonMap _mapModel7Json(JsonMap jsonMap) {
    final json = JsonMap.from(jsonMap);

    const jsonDecoder = JsonDecoder();

    json['widows'] = jsonDecoder.convert(json['widows']).cast<JsonMap>();
    json['divorced'] = jsonDecoder.convert(json['divorced']).cast<JsonMap>();
    json['disabilities'] = jsonDecoder.convert(json['disabilities']);
    json['lowIncome'] = jsonDecoder.convert(json['lowIncome']).cast<JsonMap>();
    json['unemployed'] = jsonDecoder.convert(json['unemployed']).cast<JsonMap>();
    json['formFiller'] = jsonDecoder.convert(json['formFiller']);

    return json;
  }

  // ==================================================

  static String _whereInQuery(Iterable ids) {
    if (ids.isEmpty) log('Warning!!! empty ids in `WHERE id IN ()`');

    var query = '(';
    for (final id in ids) {
      query += "'$id',";
    }
    if (ids.isNotEmpty) query = query.substring(0, query.length - 1);
    query += ')';

    return query;
  }
}
