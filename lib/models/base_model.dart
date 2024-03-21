import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class BaseModel extends Equatable {
  const BaseModel({this.id, this.at});

  BaseModel.copyWith(BaseModel model, {int? id, DateTime? at})
      : id = id ?? model.id,
        at = at ?? model.at;

  String get documentType;

  String get documentTitle;

  final int? id;

  final DateTime? at;

  @override
  List<Object?> get props => [id, at];
}
