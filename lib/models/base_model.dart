import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:souq_aljomaa/utils.dart';

abstract class BaseModel extends Equatable {
  const BaseModel({this.id, this.at, required this.scanner});

  BaseModel.copyWith(BaseModel model, {int? id, DateTime? at, required String? scanner})
      : id = id ?? model.id,
        at = at ?? model.at,
        scanner = scanner ?? model.scanner;

  String get documentType;

  String get documentTitle;

  final int? id;

  final DateTime? at;

  final String? scanner;

  @mustCallSuper
  JsonMap toJson() {
    return {
      'id': id,
      'at': at?.toIso8601String(),
      'scanner': scanner,
    };
  }

  @override
  List<Object?> get props => [id, at, scanner];
}
