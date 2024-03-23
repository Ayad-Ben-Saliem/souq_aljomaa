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

  const Model6({
    super.id,
    super.at,
    super.scanner,
    required this.ownerName,
    required this.ownerPhone,
    required this.tenantName,
    required this.tenantPhone,
    required this.streetCode,
    required this.shopNo,
    required this.businessType,
    required this.businessCategory,
  });

  Model6.copyWith(
    Model6 super.model, {
    super.id,
    super.at,
    super.scanner,
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

  Model6 copyWith({
    int? id,
    DateTime? at,
    String? scanner,
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
        scanner: scanner,
        ownerName: ownerName,
        ownerPhone: ownerPhone,
        tenantName: tenantName,
        tenantPhone: tenantPhone,
        streetCode: streetCode,
        shopNo: shopNo,
        businessType: businessType,
        businessCategory: businessCategory,
      );

  factory Model6.fromJson(JsonMap json) {
    return Model6(
      id: json['id'],
      at: DateTime.parse(json['at']),
      scanner: json['scanner'],
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
