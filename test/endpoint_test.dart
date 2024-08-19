import 'package:flutter_test/flutter_test.dart';
import 'package:souq_aljomaa/data_provider/restful.dart';
import 'package:souq_aljomaa/models/model1.dart';
import 'package:souq_aljomaa/models/model7.dart';

void main() {
  test('save model test', () async {
    // final model1 = Model1.fromJson(const {
    //   'id': null,
    //   'at': '2024-07-15T16:05:33.880397',
    //   'scanner': null,
    //   'locality': 'عرادة',
    //   'witness': 'خالد محمد جرانة',
    //   'responsible': 'عرادة',
    //   'firstName': 'عياد',
    //   'fatherName': 'مصطفى',
    //   'grandfatherName': 'عياد',
    //   'lastName': 'بن سليم',
    //   'motherName': 'فتحية علي النعيري',
    //   'identifierNo': '366166',
    //   'nationalId': '119920025083',
    //   'testimony': 'غير متزوج بغير ليبية',
    //   'date': '2024-07-15T16:02:05.106218',
    // });

    final model7 = Model7(
      streetNo: 'streetNo',
      buildingNo: 'buildingNo',
      registrationNo: 'registrationNo',
      familyHeadName: 'familyHeadName',
      malesCount: 5,
      femalesCount: 3,
      formFiller: const FormFiller(name: 'name', phoneNo: 'phoneNo'),
      documents: const [
        '/home/ayad/Downloads/1.jpg',
        '/home/ayad/Downloads/dummy.pdf'
      ]
    );

    Restful.initialize('http://localhost:5000');
    final result = await Restful.saveModel(model7);
    print(result);
  });

  // test('backup test', () async {
  //   Restful.initialize('http://localhost:5000');
  //   await Restful.backup(savePath: '/home/', password: 'A5355850d.');
  // });
}
