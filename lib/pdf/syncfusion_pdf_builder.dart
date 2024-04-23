import 'package:flutter/services.dart';
import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/models/model1.dart';
import 'package:souq_aljomaa/models/model2.dart';
import 'package:souq_aljomaa/models/model3.dart';
import 'package:souq_aljomaa/models/model4.dart';
import 'package:souq_aljomaa/models/model5.dart';
import 'package:souq_aljomaa/pdf/pdf_builder.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Uint8List? form1Bytes;
Uint8List? form2Bytes;
Uint8List? form3Bytes;
Uint8List? form4Bytes;
Uint8List? form5Bytes;

abstract class SyncfusionPdfBuilder {
  static Future<Uint8List> getDocument(BaseModel model) async {
    PdfDocument? document;
    if (model is Model1) {
      form1Bytes ??= (await rootBundle.load('assets/pdf/1.pdf')).buffer.asUint8List();
      document = PdfDocument(inputBytes: form1Bytes!.toList());
    } else if (model is Model2) {
      form2Bytes ??= (await rootBundle.load('assets/pdf/2.pdf')).buffer.asUint8List();
      document = PdfDocument(inputBytes: form2Bytes!.toList());
    } else if (model is Model3) {
      form3Bytes ??= (await rootBundle.load('assets/pdf/3.pdf')).buffer.asUint8List();
      document = PdfDocument(inputBytes: form3Bytes!.toList());
    } else if (model is Model4) {
      form4Bytes ??= (await rootBundle.load('assets/pdf/4.pdf')).buffer.asUint8List();
      document = PdfDocument(inputBytes: form4Bytes!.toList());
    } else if (model is Model5) {
      form5Bytes ??= (await rootBundle.load('assets/pdf/5.pdf')).buffer.asUint8List();
      document = PdfDocument(inputBytes: form5Bytes!.toList());
    }

    final formContent = await PdfBuilder.getFormContent(model);
    if (document != null) {
      document.pages[0].graphics.drawPdfTemplate(
        PdfDocument(inputBytes: formContent).pages[0].createTemplate(),
        Offset.zero,
      );
      return Uint8List.fromList(document.saveSync());
    } else {
      return formContent;
    }
  }
}
