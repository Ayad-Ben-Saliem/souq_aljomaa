import 'dart:convert';

import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/utils.dart';

class Model6 extends BaseModel {
  @override
  String get documentType => type;

  @override
  String get documentTitle => title;

  static String get type => 'Model6';

  static String get title => 'كشف بحصر الأنشطة التجارية داخل محلة عرادة النسخة المعدلة';

  final String ownerName;
  final String ownerPhone;

  final String tenantName;
  final String tenantPhone;

  final String streetCode;
  final String shopNo;
  final String businessType;
  final String businessCategory;

  Model6({
    super.id,
    super.at,
    super.documents,
    required this.ownerName,
    required this.ownerPhone,
    required this.tenantName,
    required this.tenantPhone,
    required this.streetCode,
    required this.shopNo,
    required this.businessType,
    required this.businessCategory,
  });

  factory Model6.fromJson(JsonMap json) {
    return Model6(
      id: json['id'],
      at: DateTime.parse(json['at']),
      documents: json['documents'],
      ownerName: json['ownerName'],
      ownerPhone: json['ownerPhone'],
      tenantName: json['tenantName'],
      tenantPhone: json['tenantPhone'],
      streetCode: json['streetCode'],
      shopNo: json['shopNo'],
      businessType: json['businessType'],
      businessCategory: json['businessCategory'],
    );
  }

  Model6.copyWith(
    Model6 super.model, {
    super.id,
    super.at,
    super.documents,
    String? ownerName,
    String? ownerPhone,
    String? tenantName,
    String? tenantPhone,
    String? streetCode,
    String? shopNo,
    String? businessType,
    String? businessCategory,
  })  : ownerName = ownerName ?? model.ownerName,
        ownerPhone = ownerPhone ?? model.ownerPhone,
        tenantName = tenantName ?? model.tenantName,
        tenantPhone = tenantPhone ?? model.tenantPhone,
        streetCode = streetCode ?? model.streetCode,
        shopNo = shopNo ?? model.shopNo,
        businessType = businessType ?? model.businessType,
        businessCategory = businessCategory ?? model.businessCategory,
        super.copyWith();

  @override
  Model6 copyWith({
    int? id,
    DateTime? at,
    Iterable<String>? documents,
    String? ownerName,
    String? ownerPhone,
    String? tenantName,
    String? tenantPhone,
    String? streetCode,
    String? shopNo,
    String? businessType,
    String? businessCategory,
  }) =>
      Model6.copyWith(
        this,
        id: id,
        at: at,
        documents: documents,
        ownerName: ownerName,
        ownerPhone: ownerPhone,
        tenantName: tenantName,
        tenantPhone: tenantPhone,
        streetCode: streetCode,
        shopNo: shopNo,
        businessType: businessType,
        businessCategory: businessCategory,
      );

  @override
  JsonMap get toJson => super.toJson
    ..addAll({
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'tenantName': tenantName,
      'tenantPhone': tenantPhone,
      'streetCode': streetCode,
      'shopNo': shopNo,
      'businessType': businessType,
      'businessCategory': businessCategory,
    });

  @override
  JsonMap get jsonify => toJson;

  @override
  List<Object?> get props => super.props
    ..addAll([
      ownerName,
      ownerPhone,
      tenantName,
      tenantPhone,
      streetCode,
      shopNo,
      businessType,
      businessCategory,
    ]);
}
