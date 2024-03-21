import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/utils.dart';

class Model2 extends BaseModel {
  @override
  String get documentType => type;

  @override
  String get documentTitle => title;

  static String get type => 'Model2';

  static String get title => 'إفادة بعدم ملكية مسكن';

  final String locality;

  final String witness;
  final String responsible;

  final String firstName;
  final String fatherName;
  final String grandfatherName;
  final String lastName;

  final String? identifierNo;
  final String? identifierFrom;
  final String nationalId;

  final String testimony;

  final String date1;
  final String? date2;

  const Model2({
    super.id,
    super.at,
    required this.locality,
    required this.witness,
    required this.responsible,
    required this.firstName,
    required this.fatherName,
    required this.grandfatherName,
    required this.lastName,
    this.identifierNo,
    this.identifierFrom,
    required this.nationalId,
    required this.testimony,
    required this.date1,
    this.date2,
  });

  Model2.copyWith(
    Model2 super.model, {
    super.id,
    super.at,
    String? locality,
    String? witness,
    String? responsible,
    String? firstName,
    String? fatherName,
    String? grandfatherName,
    String? lastName,
    String? identifierNo,
    String? identifierFrom,
    String? nationalId,
    String? testimony,
    String? date1,
    String? date2,
  })  : locality = locality ?? model.locality,
        witness = witness ?? model.witness,
        responsible = responsible ?? model.responsible,
        firstName = firstName ?? model.firstName,
        fatherName = fatherName ?? model.fatherName,
        grandfatherName = grandfatherName ?? model.grandfatherName,
        lastName = lastName ?? model.lastName,
        identifierNo = identifierNo ?? model.identifierNo,
        identifierFrom = identifierFrom ?? model.identifierFrom,
        nationalId = nationalId ?? model.nationalId,
        testimony = testimony ?? model.testimony,
        date1 = date1 ?? model.date1,
        date2 = date2 ?? model.date2,
        super.copyWith();

  Model2 copyWith({
    int? id,
    DateTime? at,
    String? locality,
    String? witness,
    String? responsible,
    String? firstName,
    String? fatherName,
    String? grandfatherName,
    String? lastName,
    String? identifierNo,
    String? identifierFrom,
    String? nationalId,
    String? testimony,
    String? date1,
    String? date2,
  }) =>
      Model2.copyWith(
        this,
        id: id,
        at: at,
        locality: locality,
        witness: witness,
        responsible: responsible,
        firstName: firstName,
        fatherName: fatherName,
        grandfatherName: grandfatherName,
        lastName: lastName,
        identifierNo: identifierNo,
        identifierFrom: identifierFrom,
        nationalId: nationalId,
        testimony: testimony,
        date1: date1,
        date2: date2,
      );

  factory Model2.fromJson(JsonMap json) {
    return Model2(
      id: json['id'],
      at: DateTime.parse(json['at']),
      locality: json['locality'],
      witness: json['witness'],
      responsible: json['responsible'],
      firstName: json['firstName'],
      fatherName: json['fatherName'],
      grandfatherName: json['grandfatherName'],
      lastName: json['lastName'],
      identifierNo: json['identifierNo'],
      identifierFrom: json['identifierFrom'],
      nationalId: json['nationalId'],
      testimony: json['testimony'],
      date1: json['date1'],
      date2: json['date2'],
    );
  }

  String get fullName => '$firstName $fatherName $grandfatherName $lastName';

  @override
  List<Object?> get props => super.props
    ..addAll([
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
      date1,
      date2,
    ]);
}
