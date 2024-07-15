import 'package:equatable/equatable.dart';
import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/utils.dart';

class Widow extends Equatable {
  final String? name;

  final int malesCount;
  final int femalesCount;

  const Widow({this.name, required this.malesCount, required this.femalesCount});

  factory Widow.fromJson(JsonMap json) {
    // print('json: $json');
    return Widow(
      name: json['name'],
      malesCount: json['malesCount'],
      femalesCount: json['femalesCount'],
    );
  }

  JsonMap toJson() => {'name': name, 'malesCount': malesCount, 'femalesCount': femalesCount};

  Widow.copyWith(Widow widow, {String? name, int? malesCount, int? femalesCount})
      : name = name ?? widow.name,
        malesCount = malesCount ?? widow.malesCount,
        femalesCount = femalesCount ?? widow.femalesCount;

  Widow copyWith({String? name, int? malesCount, int? femalesCount}) => Widow.copyWith(this, name: name, malesCount: malesCount, femalesCount: femalesCount);

  @override
  List<Object?> get props => [name, malesCount, femalesCount];
}

class Divorced extends Equatable {
  final String? name;

  final int malesCount;
  final int femalesCount;

  const Divorced({this.name, required this.malesCount, required this.femalesCount});

  factory Divorced.fromJson(JsonMap json) {
    return Divorced(
      name: json['name'],
      malesCount: json['malesCount'],
      femalesCount: json['femalesCount'],
    );
  }

  JsonMap toJson() => {'name': name, 'malesCount': malesCount, 'femalesCount': femalesCount};

  Divorced.copyWith(Divorced divorced, {String? name, int? malesCount, int? femalesCount})
      : name = name ?? divorced.name,
        malesCount = malesCount ?? divorced.malesCount,
        femalesCount = femalesCount ?? divorced.femalesCount;

  Divorced copyWith({String? name, int? malesCount, int? femalesCount}) => Divorced.copyWith(this, name: name, malesCount: malesCount, femalesCount: femalesCount);

  @override
  List<Object?> get props => [name, malesCount, femalesCount];
}

class Disabilities extends Equatable {
  final int malesCount;
  final int femalesCount;

  const Disabilities({required this.malesCount, required this.femalesCount});

  factory Disabilities.fromJson(JsonMap json) {
    return Disabilities(
      malesCount: json['malesCount'],
      femalesCount: json['femalesCount'],
    );
  }

  static Disabilities? tryFromJson(JsonMap? json) {
    return json != null ? Disabilities.fromJson(json) : null;
  }

  JsonMap toJson() => {'malesCount': malesCount, 'femalesCount': femalesCount};

  Disabilities.copyWith(Disabilities disabilities, {String? name, int? malesCount, int? femalesCount})
      : malesCount = malesCount ?? disabilities.malesCount,
        femalesCount = femalesCount ?? disabilities.femalesCount;

  Disabilities copyWith({String? name, int? malesCount, int? femalesCount}) => Disabilities.copyWith(this, name: name, malesCount: malesCount, femalesCount: femalesCount);

  @override
  List<Object?> get props => [malesCount, femalesCount];
}

class LowIncome extends Equatable {
  final String? name;
  final LowIncomeType type;

  const LowIncome({this.name, required this.type});

  factory LowIncome.fromJson(JsonMap json) {
    return LowIncome(
      name: json['name'],
      type: LowIncomeType.fromString(json['type']),
    );
  }

  JsonMap toJson() => {'name': name, 'type': type.name};

  LowIncome.copyWith(LowIncome lowIncome, {String? name, LowIncomeType? type})
      : name = name ?? lowIncome.name,
        type = type ?? lowIncome.type;

  LowIncome copyWith({String? name, LowIncomeType? type}) => LowIncome.copyWith(this, name: name, type: type);

  @override
  List<Object?> get props => [name, type];
}

enum LowIncomeType {
  employee('موظف'),
  retired('متقاعد'),
  solidarityFund('صندوق التضامن');

  final String name;

  const LowIncomeType(this.name);

  static LowIncomeType fromString(String type) {
    for (final lowIncomeType in LowIncomeType.values) {
      if (type == lowIncomeType.name) return lowIncomeType;
    }

    throw Exception('Type not supported');
  }

  @override
  String toString() => name;
}

class Unemployed extends Equatable {
  final String? name;
  final Gender gender;
  final Qualification qualification;

  const Unemployed({this.name, required this.gender, required this.qualification});

  factory Unemployed.fromJson(JsonMap json) {
    return Unemployed(
      name: json['name'],
      gender: Gender.fromString(json['gender']),
      qualification: Qualification.fromString(json['qualification']),
    );
  }

  JsonMap toJson() => {'name': name, 'gender': gender.name, 'qualification': qualification.name};

  Unemployed.copyWith(Unemployed unemployed, {String? name, Gender? gender, Qualification? qualification})
      : name = name ?? unemployed.name,
        gender = gender ?? unemployed.gender,
        qualification = qualification ?? unemployed.qualification;

  Unemployed copyWith({String? name, Gender? gender, Qualification? qualification}) => Unemployed.copyWith(this, name: name, gender: gender, qualification: qualification);

  @override
  List<Object?> get props => [name, gender, qualification];
}

enum Qualification {
  none('لا شيء'),
  diploma('دبلوم'),
  bachelor('بكالوريوس'),
  master('ماجستير'),
  doctorate('دكتوراه');

  final String name;

  const Qualification(this.name);

  static Qualification fromString(String value) {
    for (final qualification in Qualification.values) {
      if (qualification.name == value) return qualification;
    }
    throw Exception('Invalid qualification ($value)');
  }

  @override
  String toString() => name;
}

enum Gender {
  male('ذكر'),
  female('أنثى');

  final String name;

  const Gender(this.name);

  static Gender fromString(String value) {
    for (final gender in Gender.values) {
      if (gender.name == value) return gender;
    }
    throw Exception('Invalid qualification ($value)');
  }

  @override
  String toString() => name;
}

class FormFiller extends Equatable {
  final String name;
  final String phoneNo;

  const FormFiller({required this.name, required this.phoneNo});

  factory FormFiller.fromJson(JsonMap json) {
    return FormFiller(
      name: json['name'],
      phoneNo: json['phoneNo'],
    );
  }

  JsonMap toJson() => {'name': name, 'phoneNo': phoneNo};

  FormFiller.copyWith(FormFiller formFiller, {String? name, String? phoneNo})
      : name = name ?? formFiller.name,
        phoneNo = phoneNo ?? formFiller.phoneNo;

  FormFiller copyWith({String? name, String? phoneNo}) => FormFiller.copyWith(this, name: name, phoneNo: phoneNo);

  @override
  List<Object?> get props => [name, phoneNo];
}

class Model7 extends BaseModel {
  @override
  String get documentType => type;

  @override
  String get documentTitle => title;

  static String get type => 'Model7';

  static String get title => 'نموذج حصر العائلات الليبية محلة عرادة';

  final String streetNo;
  final String buildingNo;

  final String registrationNo;
  final String familyHeadName;

  final int malesCount;
  final int femalesCount;

  final List<Widow> widows;
  final List<Divorced> divorced;
  final Disabilities? disabilities;

  final List<LowIncome> lowIncome;
  final List<Unemployed> unemployed;

  final DateTime? familyHeadDeathDate;

  final String? currentFamilyHeadName;

  final FormFiller formFiller;

  final String? notes;

  Model7({
    super.id,
    super.at,
    super.scanner,
    required this.streetNo,
    required this.buildingNo,
    required this.registrationNo,
    required this.familyHeadName,
    required this.malesCount,
    required this.femalesCount,
    Iterable<Widow> widows = const [],
    Iterable<Divorced> divorced = const [],
    this.disabilities,
    Iterable<LowIncome> lowIncome = const [],
    Iterable<Unemployed> unemployed = const [],
    this.familyHeadDeathDate,
    this.currentFamilyHeadName,
    required this.formFiller,
    this.notes,
  })
      : widows = List<Widow>.unmodifiable(widows),
        divorced = List<Divorced>.unmodifiable(divorced),
        lowIncome = List<LowIncome>.unmodifiable(lowIncome),
        unemployed = List<Unemployed>.unmodifiable(unemployed);

  Model7.copyWith(Model7 super.model, {
    super.id,
    super.at,
    super.scanner,
    String? streetNo,
    String? buildingNo,
    String? registrationNo,
    String? familyHeadName,
    int? malesCount,
    int? femalesCount,
    Iterable<Widow>? widows,
    Iterable<Divorced>? divorced,
    Disabilities? disabilities,
    Iterable<LowIncome>? lowIncome,
    Iterable<Unemployed>? unemployed,
    DateTime? familyHeadDeathDate,
    String? currentFamilyHeadName,
    FormFiller? formFiller,
    String? notes,
  })
      :
        streetNo = streetNo ?? model.streetNo,
        buildingNo = buildingNo ?? model.buildingNo,
        registrationNo = registrationNo ?? model.registrationNo,
        familyHeadName = familyHeadName ?? model.familyHeadName,
        malesCount = malesCount ?? model.malesCount,
        femalesCount = femalesCount ?? model.femalesCount,
        widows = widows != null ? List<Widow>.unmodifiable(widows) : model.widows,
        divorced = divorced != null ? List<Divorced>.unmodifiable(divorced) : model.divorced,
        disabilities = disabilities ?? model.disabilities,
        lowIncome = lowIncome != null ? List<LowIncome>.unmodifiable(lowIncome) : model.lowIncome,
        unemployed = unemployed != null ? List<Unemployed>.unmodifiable(unemployed) : model.unemployed,
        familyHeadDeathDate = familyHeadDeathDate ?? model.familyHeadDeathDate,
        currentFamilyHeadName = currentFamilyHeadName ?? model.currentFamilyHeadName,
        formFiller = formFiller ?? model.formFiller,
        notes = notes ?? model.notes,
        super.copyWith();

  Model7 copyWith({
    int? id,
    DateTime? at,
    String? scanner,
    String? streetNo,
    String? buildingNo,
    String? registrationNo,
    String? familyHeadName,
    int? malesCount,
    int? femalesCount,
    List<Widow>? widows,
    List<Divorced>? divorced,
    Disabilities? disabilities,
    List<LowIncome>? lowIncome,
    List<Unemployed>? unemployed,
    DateTime? familyHeadDeathDate,
    String? currentFamilyHeadName,
    FormFiller? formFiller,
    String? notes,
  }) =>
      Model7.copyWith(
        this,
        id: id,
        at: at,
        scanner: scanner,
        streetNo: streetNo,
        buildingNo: buildingNo,
        registrationNo: registrationNo,
        familyHeadName: familyHeadName,
        malesCount: malesCount,
        femalesCount: femalesCount,
        widows: widows,
        divorced: divorced,
        disabilities: disabilities,
        lowIncome: lowIncome,
        unemployed: unemployed,
        familyHeadDeathDate: familyHeadDeathDate,
        currentFamilyHeadName: currentFamilyHeadName,
        formFiller: formFiller,
        notes: notes,
      );

  factory Model7.fromJson(JsonMap json) {
    return Model7(
      id: json['id'],
      at: DateTime.parse(json['at']),
      scanner: json['scanner'],
      streetNo: json['streetNo'],
      buildingNo: json['buildingNo'],
      registrationNo: json['registrationNo'],
      familyHeadName: json['familyHeadName'],
      malesCount: json['malesCount'],
      femalesCount: json['femalesCount'],
      widows: List<Widow>.unmodifiable([for (final widow in json['widows']) Widow.fromJson(widow)]),
      divorced: List<Divorced>.unmodifiable([for (final divorced in json['divorced']) Divorced.fromJson(divorced)]),
      disabilities: Disabilities.tryFromJson(json['disabilities']),
      lowIncome: List<LowIncome>.unmodifiable([for (final lowIncome in json['lowIncome']) LowIncome.fromJson(lowIncome)]),
      unemployed: List<Unemployed>.unmodifiable([for (final unemployed in json['unemployed']) Unemployed.fromJson(unemployed)]),
      familyHeadDeathDate: DateTime.tryParse(json['familyHeadDeathDate'] ?? ''),
      currentFamilyHeadName: json['currentFamilyHeadName'],
      formFiller: FormFiller.fromJson(json['formFiller']),
      notes: json['notes'],
    );
  }


  @override
  JsonMap toJson() =>
      super.toJson()
        ..addAll({
          'streetNo': streetNo,
          'buildingNo': buildingNo,
          '': registrationNo,
          'registrationNo': familyHeadName,
          'malesCount': malesCount,
          'femalesCount': femalesCount,
          'widows': [for(final widow in widows) widow.toJson()],
          'divorced': [for(final div in divorced) div.toJson()],
          'disabilities': disabilities,
          'lowIncome': [for(final low in lowIncome) low.toJson()],
          'unemployed': [for(final unEmp in unemployed) unEmp.toJson()],
          'familyHeadDeathDate': familyHeadDeathDate,
          'currentFamilyHeadName': currentFamilyHeadName,
          'formFiller': formFiller,
          'notes': notes,
        });


  @override
  List<Object?> get props =>
      super.props
        ..addAll([
          streetNo,
          buildingNo,
          registrationNo,
          familyHeadName,
          malesCount,
          femalesCount,
          ...widows,
          ...divorced,
          disabilities,
          ...lowIncome,
          ...unemployed,
          familyHeadDeathDate,
          currentFamilyHeadName,
          formFiller,
          notes,
        ]);
}
