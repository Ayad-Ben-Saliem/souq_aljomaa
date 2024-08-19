import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:souq_aljomaa/main.dart';
import 'package:souq_aljomaa/utils.dart';
import 'package:path/path.dart';

abstract class BaseModel extends Equatable {
  String get documentType;

  String get documentTitle;

  final int? id;

  final DateTime? at;

  final Iterable<String> documents;

  BaseModel({
    required this.id,
    required this.at,
    Iterable<String> documents = const [],
  }) : documents = List.unmodifiable(documents);

  BaseModel.copyWith(
    BaseModel model, {
    required int? id,
    required DateTime? at,
    required Iterable<String>? documents,
  })  : id = id ?? model.id,
        at = at ?? model.at,
        documents = List.unmodifiable(documents ?? model.documents);

  BaseModel copyWith({
    int? id,
    DateTime? at,
    Iterable<String>? documents,
  });

  @mustCallSuper
  JsonMap get toJson {
    return {
      'id': id,
      'at': at?.toIso8601String(),
      'documents': documents,
    };
  }

  Iterable<String> get documentsUrl {
    final serverUrl = sharedPreferences.getString('serverUrl');
    return List.unmodifiable(
      serverUrl == null ? [] : [for (final document in documents) isFileExist(document) ? document : join(serverUrl, 'files', document)],
    );
  }

  JsonMap get jsonify => toJson;

  @override
  List<Object?> get props => [id, at, documents];
}
