import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/utils.dart';
import 'package:jhijri/jHijri.dart';
import 'package:intl/intl.dart';

class Model3 extends BaseModel {
  @override
  String get documentType => type;

  @override
  String get documentTitle => title;

  static String get type => 'Model3';

  static String get title => 'إفادة بحسن السيرة والسلوك';

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

  final DateTime date;

  const Model3({
    super.id,
    super.at,
    super.scanner,
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
    required this.date,
  });

  Model3.copyWith(
    Model3 super.model, {
    super.id,
    super.at,
    super.scanner,
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
    DateTime? date,
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
        date = date ?? model.date,
        super.copyWith();

  Model3 copyWith({
    int? id,
    DateTime? at,
    String? scanner,
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
    DateTime? date,
  }) =>
      Model3.copyWith(
        this,
        id: id,
        at: at,
        scanner: scanner,
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
        date: date,
      );

  factory Model3.fromJson(JsonMap json) {
    return Model3(
      id: json['id'],
      at: DateTime.parse(json['at']),
      scanner: json['scanner'],
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
      date: DateTime.parse(json['date']),
    );
  }

  String get fullName => '$firstName $fatherName $grandfatherName $lastName';

  String formattedDate([String? format = 'yyyy/MM/dd', String? locale]) {
    return DateFormat(format, locale).format(date);
  }

  HijriDate? get hijriDate => HijriDate.dateToHijri(date);

  @override
  JsonMap toJson() => super.toJson()..addAll({
    'locality': locality,
    'witness': witness,
    'responsible': responsible,
    'firstName': firstName,
    'fatherName': fatherName,
    'grandfatherName': grandfatherName,
    'lastName': lastName,
    'identifierNo' : identifierNo,
    'identifierFrom': identifierFrom,
    'nationalId': nationalId,
    'testimony': testimony,
    'date': date.toIso8601String()
  });


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
      date,
    ]);
}
