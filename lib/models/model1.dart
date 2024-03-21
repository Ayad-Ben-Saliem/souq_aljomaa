import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/utils.dart';

class Model1 extends BaseModel {
  @override
  String get documentType => type;

  @override
  String get documentTitle => title;

  static String get type => 'Model1';

  static String get title => 'إفادة بعدم الزواج بغير ليبية';

  final String locality;

  final String witness;
  final String responsible;

  final String firstName;
  final String fatherName;
  final String grandfatherName;
  final String lastName;

  final String motherName;
  final String? identifierNo;
  final String nationalId;

  final String testimony;

  final String date1;
  final String? date2;

  const Model1({
    super.id,
    super.at,
    required this.locality,
    required this.witness,
    required this.responsible,
    required this.firstName,
    required this.fatherName,
    required this.grandfatherName,
    required this.lastName,
    required this.motherName,
    this.identifierNo,
    required this.nationalId,
    required this.testimony,
    required this.date1,
    this.date2,
  });

  Model1.copyWith(
    Model1 super.model, {
    super.id,
    super.at,
    String? locality,
    String? witness,
    String? responsible,
    String? firstName,
    String? fatherName,
    String? grandfatherName,
    String? lastName,
    String? motherName,
    String? identifierNo,
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
        motherName = motherName ?? model.motherName,
        identifierNo = identifierNo ?? model.identifierNo,
        nationalId = nationalId ?? model.nationalId,
        testimony = testimony ?? model.testimony,
        date1 = date1 ?? model.date1,
        date2 = date2 ?? model.date2,
        super.copyWith();

  Model1 copyWith({
    int? id,
    DateTime? at,
    String? locality,
    String? witness,
    String? responsible,
    String? firstName,
    String? fatherName,
    String? grandfatherName,
    String? lastName,
    String? motherName,
    String? identifierNo,
    String? nationalId,
    String? testimony,
    String? date1,
    String? date2,
  }) =>
      Model1.copyWith(
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
        motherName: motherName,
        identifierNo: identifierNo,
        nationalId: nationalId,
        testimony: testimony,
        date1: date1,
        date2: date2,
      );

  factory Model1.fromJson(JsonMap json) {
    return Model1(
      id: json['id'],
      at: DateTime.parse(json['at']),
      locality: json['locality'],
      witness: json['witness'],
      responsible: json['responsible'],
      firstName: json['firstName'],
      fatherName: json['fatherName'],
      grandfatherName: json['grandfatherName'],
      lastName: json['lastName'],
      motherName: json['motherName'],
      identifierNo: json['identifierNo'],
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
      motherName,
      identifierNo,
      nationalId,
      testimony,
      date1,
      date2,
    ]);
}
