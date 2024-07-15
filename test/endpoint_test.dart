import 'package:flutter_test/flutter_test.dart';

import 'package:souq_aljomaa/main.dart';
import 'package:souq_aljomaa/models/model1.dart';
import 'package:souq_aljomaa/storage/restful.dart';

void main() {
  test('description', () async {
    final model1 = Model1.fromJson(const {
      'id': null,
      'at': '2024-07-15T16:05:33.880397',
      'scanner': null,
      'locality': 'عرادة',
      'witness': 'خالد محمد جرانة',
      'responsible': 'عرادة',
      'firstName': 'عياد',
      'fatherName': 'مصطفى',
      'grandfatherName': 'عياد',
      'lastName': 'بن سليم',
      'motherName': 'فتحية علي النعيري',
      'identifierNo': '366166',
      'nationalId': '119920025083',
      'testimony': 'غير متزوج بغير ليبية',
      'date': '2024-07-15T16:02:05.106218',
    });

    final result = await Restful.saveModel(model1);
    print(result);
  });
}


var x = '''
INSERT INTO Model1 (
  at,
  scanner,
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
  date
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
''';