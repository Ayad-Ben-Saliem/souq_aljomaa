import 'package:jhijri/jHijri.dart';
import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/utils.dart';
import 'package:intl/intl.dart';

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

  final DateTime date;

  Model1({
    super.id,
    super.at,
    super.documents,
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
    required this.date,
  });

  factory Model1.fromJson(JsonMap json) {
    return Model1(
      id: json['id'],
      at: DateTime.parse(json['at']),
      documents: json['documents'],
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
      date: DateTime.parse(json['date']),
    );
  }

  Model1.copyWith(
    Model1 super.model, {
    super.id,
    super.at,
    super.documents,
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
    DateTime? date,
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
        date = date ?? model.date,
        super.copyWith();

  @override
  Model1 copyWith({
    int? id,
    DateTime? at,
    Iterable<String>? documents,
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
    DateTime? date,
  }) =>
      Model1.copyWith(
        this,
        id: id,
        at: at,
        documents: documents,
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
        date: date,
      );

  String get fullName => '$firstName $fatherName $grandfatherName $lastName';

  String formattedDate([String? format = 'yyyy/MM/dd', String? locale]) {
    return DateFormat(format, locale).format(date);
  }

  HijriDate? get hijriDate => HijriDate.dateToHijri(date);

  @override
  JsonMap get toJson => super.toJson
    ..addAll({
      'locality': locality,
      'witness': witness,
      'responsible': responsible,
      'firstName': firstName,
      'fatherName': fatherName,
      'grandfatherName': grandfatherName,
      'lastName': lastName,
      'motherName': motherName,
      'identifierNo': identifierNo,
      'nationalId': nationalId,
      'testimony': testimony,
      'date': date.toIso8601String()
    });

  @override
  JsonMap get jsonify => toJson;

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
      date.toIso8601String(),
    ]);
}
