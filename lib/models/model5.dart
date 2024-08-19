import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/utils.dart';
import 'package:jhijri/jHijri.dart';
import 'package:intl/intl.dart';

class Model5 extends BaseModel {
  @override
  String get documentType => type;

  @override
  String get documentTitle => title;

  static String get type => 'Model5';

  static String get title => 'إفادة بالإقامة';

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

  final String familyBookletNumber;
  final String familyDocumentNumber;
  final String issuePlace;
  final String issueDate;
  final String residence;
  final String nearestPoint;

  final DateTime date;

  Model5({
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
    required this.familyBookletNumber,
    required this.familyDocumentNumber,
    required this.issuePlace,
    required this.issueDate,
    required this.residence,
    required this.nearestPoint,
    required this.date,
  });

  factory Model5.fromJson(JsonMap json) {
    return Model5(
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
      familyBookletNumber: json['familyBookletNumber'],
      familyDocumentNumber: json['familyDocumentNumber'],
      issuePlace: json['issuePlace'],
      issueDate: json['issueDate'],
      residence: json['residence'],
      nearestPoint: json['nearestPoint'],
      date: DateTime.parse(json['date']),
    );
  }

  Model5.copyWith(
    Model5 super.model, {
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
    String? familyBookletNumber,
    String? familyDocumentNumber,
    String? issuePlace,
    String? issueDate,
    String? residence,
    String? nearestPoint,
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
        familyBookletNumber = familyBookletNumber ?? model.familyBookletNumber,
        familyDocumentNumber = familyDocumentNumber ?? model.familyDocumentNumber,
        issuePlace = issuePlace ?? model.issuePlace,
        issueDate = issueDate ?? model.issueDate,
        residence = residence ?? model.residence,
        nearestPoint = nearestPoint ?? model.nearestPoint,
        date = date ?? model.date,
        super.copyWith();

  Model5 copyWith({
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
    String? familyBookletNumber,
    String? familyDocumentNumber,
    String? issuePlace,
    String? issueDate,
    String? residence,
    String? nearestPoint,
    DateTime? date,
  }) =>
      Model5.copyWith(
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
        familyBookletNumber: familyBookletNumber,
        familyDocumentNumber: familyDocumentNumber,
        issuePlace: issuePlace,
        issueDate: issueDate,
        residence: residence,
        nearestPoint: nearestPoint,
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
      'familyBookletNumber': familyBookletNumber,
      'familyDocumentNumber': familyDocumentNumber,
      'issuePlace': issuePlace,
      'issueDate': issueDate,
      'residence': residence,
      'nearestPoint': nearestPoint,
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
      familyBookletNumber,
      familyDocumentNumber,
      issuePlace,
      issueDate,
      residence,
      nearestPoint,
      date,
    ]);
}
