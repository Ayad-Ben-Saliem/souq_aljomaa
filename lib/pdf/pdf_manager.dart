import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/models/model1.dart';
import 'package:souq_aljomaa/models/model2.dart';
import 'package:souq_aljomaa/models/model3.dart';
import 'package:souq_aljomaa/models/model4.dart';
import 'package:souq_aljomaa/models/model5.dart';
import 'package:souq_aljomaa/models/model6.dart';
import 'package:souq_aljomaa/models/model7.dart';
import 'package:intl/intl.dart';

pw.Font? harfFannanFont;
pw.Font? harfFannanFontBold;
pw.Font? arialFont;
pw.Font? arialFontBold;
Uint8List? headerImageData;
Uint8List? stamp1ImageData;
Uint8List? stamp2ImageData;
Uint8List? stamp3ImageData;
Uint8List? stamp4ImageData;
Uint8List? stamp5ImageData;

abstract class PdfManager {
  static Future<Uint8List> getDocument(BaseModel model) async {
    harfFannanFont ??= pw.Font.ttf(await rootBundle.load("assets/fonts/Harf-Fannan.ttf"));
    harfFannanFontBold ??= pw.Font.ttf(await rootBundle.load("assets/fonts/Harf-Fannan.ttf"));

    arialFont ??= pw.Font.ttf(await rootBundle.load("assets/fonts/arial/arial.ttf"));
    arialFontBold ??= pw.Font.ttf(await rootBundle.load("assets/fonts/arial/arial-bold.ttf"));

    headerImageData ??= (await rootBundle.load('assets/images/header.jpg')).buffer.asUint8List();
    stamp1ImageData ??= (await rootBundle.load('assets/images/stamp1.png')).buffer.asUint8List();
    stamp2ImageData ??= (await rootBundle.load('assets/images/stamp2.png')).buffer.asUint8List();
    stamp3ImageData ??= (await rootBundle.load('assets/images/stamp3.png')).buffer.asUint8List();
    stamp4ImageData ??= (await rootBundle.load('assets/images/stamp4.png')).buffer.asUint8List();
    stamp5ImageData ??= (await rootBundle.load('assets/images/stamp5.png')).buffer.asUint8List();

    final doc = pw.Document(
      theme: pw.ThemeData(
        defaultTextStyle: pw.TextStyle(
          font: harfFannanFont,
          fontBold: harfFannanFontBold,
          fontSize: 20,
        ),
      ),
    );

    final page = pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(0),
      build: (context) {
        return pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Builder(builder: (context) {
              if (model is Model1) return _getModel1Page(model);
              if (model is Model2) return _getModel2Page(model);
              if (model is Model3) return _getModel3Page(model);
              if (model is Model4) return _getModel4Page(model);
              if (model is Model5) return _getModel5Page(model);
              if (model is Model6) return _getModel6Page(model);
              if (model is Model7) return _getModel7Page(model);

              return pw.Center(child: pw.Text('غير مصممة بعد'));
            }),
          ),
        );
      },
    );
    doc.addPage(page);

    return doc.save();
  }
}

pw.Widget _getModel1Page(Model1 model) {
  return pw.Directionality(
    textDirection: pw.TextDirection.rtl,
    child: pw.Stack(
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Image(pw.MemoryImage(headerImageData!)),
            pw.SizedBox(height: 16),
            pw.Text('محلة: ${model.locality}'),
            pw.Padding(
              padding: const pw.EdgeInsets.all(32),
              child: pw.Text(model.documentTitle, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(child: pw.Text('يشهد:  ${model.witness}'), flex: 2),
                pw.Expanded(child: pw.Text('مختار محلة:  ${model.locality}'), flex: 1),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('بأن السيد:  ${model.firstName}'),
                pw.Text('اسم الأب:  ${model.fatherName}'),
                pw.Text('اسم الجد:  ${model.grandfatherName}'),
                pw.Text('اللقب:  ${model.lastName}'),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('اسم الأم ثلاثي:  ${model.motherName}'),
                pw.Text('الحامل للاثباث الشخصي رقم:  ${model.identifierNo}'),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('الرقم الوطني:  '),
                for (final num in model.nationalId.split('').reversed)
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(num, style: pw.TextStyle(font: arialFont)),
                  )
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text('مقيم بهذه المحلة وأنه:  ${model.testimony}'),
            ),
            pw.SizedBox(height: 24),
            pw.Text('لصحة ما ذكر أعلاه أعطيت له هذه الإفادة بناء على طلبه لاستعمالها فيما يسمح به القانون.'),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Text('التاريخ:  ${model.hijriDate} هـ.'),
                pw.Text('الموافق:  ${model.formattedDate()} م.'),
              ],
            ),
            pw.SizedBox(height: 64),
            pw.Text('مختار المحلة'),
            pw.SizedBox(height: 32),
            pw.Text(
              '.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .',
              style: const pw.TextStyle(fontSize: 6),
            ),
          ],
        ),
        pw.Positioned(
          top: 100,
          left: 64,
          child: pw.SizedBox(
            height: 64,
            child: pw.Image(pw.MemoryImage(stamp1ImageData!)),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _getModel2Page(Model2 model) {
  return pw.Directionality(
    textDirection: pw.TextDirection.rtl,
    child: pw.Stack(
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Image(pw.MemoryImage(headerImageData!)),
            pw.SizedBox(height: 16),
            pw.Text('محلة: ${model.locality}'),
            pw.Padding(
              padding: const pw.EdgeInsets.all(32),
              child: pw.Text(model.documentTitle, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(child: pw.Text('يشهد:  ${model.witness}'), flex: 2),
                pw.Expanded(child: pw.Text('مختار محلة:  ${model.locality}'), flex: 1),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('بأن السيد:  ${model.firstName}'),
                pw.Text('اسم الأب:  ${model.fatherName}'),
                pw.Text('اسم الجد:  ${model.grandfatherName}'),
                pw.Text('اللقب:  ${model.lastName}'),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('الحامل للاثباث الشخصي رقم:  ${model.identifierNo}'),
                pw.Text('الصادرة من:  ${model.identifierFrom}'),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('الرقم الوطني:  '),
                for (final num in model.nationalId.split('').reversed)
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(num, style: pw.TextStyle(font: arialFont)),
                  )
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text('مقيم بهذه المحلة وأنه:  ${model.testimony}'),
            ),
            pw.SizedBox(height: 24),
            pw.Text('لصحة ما ذكر أعلاه أعطيت له هذه الإفادة بناء على طلبه لاستعمالها فيما يسمح به القانون.'),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Text('التاريخ:  ${model.hijriDate} هـ.'),
                pw.Text('الموافق:  ${model.formattedDate()} م.'),
              ],
            ),
            pw.SizedBox(height: 64),
            pw.Text('مختار المحلة'),
            pw.SizedBox(height: 32),
            pw.Text(
              '.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .',
              style: const pw.TextStyle(fontSize: 6),
            ),
          ],
        ),
        pw.Positioned(
          top: 100,
          left: 64,
          child: pw.SizedBox(
            height: 64,
            child: pw.Image(pw.MemoryImage(stamp2ImageData!)),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _getModel3Page(Model3 model) {
  return pw.Directionality(
    textDirection: pw.TextDirection.rtl,
    child: pw.Stack(
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Image(pw.MemoryImage(headerImageData!)),
            pw.SizedBox(height: 16),
            pw.Text('محلة: ${model.locality}'),
            pw.Padding(
              padding: const pw.EdgeInsets.all(32),
              child: pw.Text(model.documentTitle, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(child: pw.Text('يشهد:  ${model.witness}'), flex: 2),
                pw.Expanded(child: pw.Text('مختار محلة:  ${model.locality}'), flex: 1),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('بأن السيد:  ${model.firstName}'),
                pw.Text('اسم الأب:  ${model.fatherName}'),
                pw.Text('اسم الجد:  ${model.grandfatherName}'),
                pw.Text('اللقب:  ${model.lastName}'),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('الحامل للاثباث الشخصي رقم:  ${model.identifierNo}'),
                pw.Text('الصادرة من:  ${model.identifierFrom}'),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('الرقم الوطني:  '),
                for (final num in model.nationalId.split('').reversed)
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(num, style: pw.TextStyle(font: arialFont)),
                  )
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text('مقيم بهذه المحلة:  ${model.testimony}'),
            ),
            pw.SizedBox(height: 24),
            pw.Text('مقيم بالمحلة ويتمتع بحسن السيرة والسلوك'),
            pw.SizedBox(height: 24),
            pw.Text('لصحة ما ذكر أعلاه أعطيت له هذه الإفادة بناء على طلبه لاستعمالها فيما يسمح به القانون.'),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Text('التاريخ:  ${model.hijriDate} هـ.'),
                pw.Text('الموافق:  ${model.formattedDate()} م.'),
              ],
            ),
            pw.SizedBox(height: 64),
            pw.Text('مختار المحلة'),
            pw.SizedBox(height: 32),
            pw.Text(
              '.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .',
              style: const pw.TextStyle(fontSize: 6),
            ),
          ],
        ),
        pw.Positioned(
          top: 100,
          left: 64,
          child: pw.SizedBox(
            height: 64,
            child: pw.Image(pw.MemoryImage(stamp3ImageData!)),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _getModel4Page(Model4 model) {
  return pw.Directionality(
    textDirection: pw.TextDirection.rtl,
    child: pw.Stack(
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Image(pw.MemoryImage(headerImageData!)),
            pw.SizedBox(height: 16),
            pw.Text('محلة: ${model.locality}'),
            pw.Padding(
              padding: const pw.EdgeInsets.all(32),
              child: pw.Text(model.documentTitle, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(child: pw.Text('يشهد:  ${model.witness}'), flex: 2),
                pw.Expanded(child: pw.Text('مختار محلة:  ${model.locality}'), flex: 1),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('بأن السيد:  ${model.firstName}'),
                pw.Text('اسم الأب:  ${model.fatherName}'),
                pw.Text('اسم الجد:  ${model.grandfatherName}'),
                pw.Text('اللقب:  ${model.lastName}'),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('الحامل للاثباث الشخصي رقم:  ${model.identifierNo}'),
                pw.Text('الصادرة من:  ${model.identifierFrom}'),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('الرقم الوطني:  '),
                for (final num in model.nationalId.split('').reversed)
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(num, style: pw.TextStyle(font: arialFont)),
                  )
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text('مقيم بهذه المحلة وأنه:  ${model.testimony}'),
            ),
            pw.SizedBox(height: 24),
            pw.Text('لصحة ما ذكر أعلاه أعطيت له هذه الإفادة بناء على طلبه لاستعمالها فيما يسمح به القانون.'),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Text('التاريخ:  ${model.hijriDate} هـ.'),
                pw.Text('الموافق:  ${model.formattedDate()} م.'),
              ],
            ),
            pw.SizedBox(height: 64),
            pw.Text('مختار المحلة'),
            pw.SizedBox(height: 32),
            pw.Text(
              '.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .',
              style: const pw.TextStyle(fontSize: 6),
            ),
          ],
        ),
        pw.Positioned(
          top: 100,
          left: 64,
          child: pw.SizedBox(
            height: 64,
            child: pw.Image(pw.MemoryImage(stamp4ImageData!)),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _getModel5Page(Model5 model) {
  return pw.Directionality(
    textDirection: pw.TextDirection.rtl,
    child: pw.Stack(
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(-64),
              child: pw.Image(pw.MemoryImage(headerImageData!)),
              ),
            pw.SizedBox(height: 16),
            pw.Text('محلة: ${model.locality}'),
            pw.Padding(
              padding: const pw.EdgeInsets.all(32),
              child: pw.Text(model.documentTitle, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('يشهد:  ${model.witness}'), flex: 2),
                pw.Expanded(child: pw.Text('مختار محلة:  ${model.locality}'), flex: 1),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('بأن السيد:  ${model.firstName}'),
                pw.Text('اسم الأب:  ${model.fatherName}'),
                pw.Text('اسم الجد:  ${model.grandfatherName}'),
                pw.Text('اللقب:  ${model.lastName}'),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('اسم الأم ثلاثي:  ${model.motherName}'),
                pw.Text('الحامل للاثباث الشخصي رقم:  ${model.identifierNo}'),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('الرقم الوطني:  '),
                for (final num in model.nationalId.split('').reversed)
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text(num, style: pw.TextStyle(font: arialFont)),
                  )
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('رقم كتيب العائلة:  ${model.familyBookletNumber}'), flex: 2),
                pw.Expanded(child: pw.Text('رقم ورقة العائلة:  ${model.familyDocumentNumber}'), flex: 1),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('مكان الإصدار:  ${model.issuePlace}'), flex: 2),
                pw.Expanded(child: pw.Text('تاريخ الإصدار:  ${model.issueDate}'), flex: 1),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('مقيم بمحلة:  ${model.locality}'), flex: 2),
                pw.Expanded(child: pw.Text('أقرب نقطة دالة:  ${model.nearestPoint}'), flex: 1),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Text('لصحة ما ذكر أعلاه أعطيت له هذه الإفادة بناء على طلبه لاستعمالها فيما يسمح به القانون.'),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Text('التاريخ:  ${model.hijriDate} هـ.'),
                pw.Text('الموافق:  ${model.formattedDate()} م.'),
              ],
            ),
            pw.SizedBox(height: 64),
            pw.Text('مختار المحلة'),
            pw.SizedBox(height: 32),
            pw.Text(
              '.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .',
              style: const pw.TextStyle(fontSize: 6),
            ),
          ],
        ),
        pw.Positioned(
          top: 100,
          left: 64,
          child: pw.SizedBox(
            height: 64,
            child: pw.Image(pw.MemoryImage(stamp5ImageData!)),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _getModel6Page(Model6 model) {
  return pw.Directionality(
    textDirection: pw.TextDirection.rtl,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text('المجلس البلدي سوق الجمعة'),
        pw.Text('محلة عرادة'),
        pw.Padding(
          padding: const pw.EdgeInsets.all(32),
          child: pw.Text(model.documentTitle, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Row(
          children: [
            pw.Expanded(child: pw.Text('اسم مالك العقار:  ${model.ownerName}'), flex: 2),
            pw.Expanded(child: pw.Text('رقم الهاتف:  ${model.ownerPhone}'), flex: 1),
          ],
        ),
        pw.SizedBox(height: 24),
        pw.Row(
          children: [
            pw.Expanded(child: pw.Text('اسم المستأجر:  ${model.tenantName}'), flex: 2),
            pw.Expanded(child: pw.Text('رقم الهاتف:  ${model.tenantPhone}'), flex: 1),
          ],
        ),
        pw.SizedBox(height: 24),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('رمز الشارع:  ${model.streetCode}'),
            pw.Text('رمز المبنى:  ${model.shopNo}'),
          ],
        ),
        pw.SizedBox(height: 24),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('نوع النشاط:  ${model.businessType}'),
            pw.Text('تصنيف:  ${model.businessCategory}'),
          ],
        ),
        pw.SizedBox(height: 64),
        pw.Text('التاريخ:  ${DateFormat('yyyy/MM/dd').format(model.at!)} م.'),
        pw.SizedBox(height: 24),
        pw.Text('مختار المحلة'),
        pw.SizedBox(height: 32),
        pw.Text(
          '.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .',
          style: const pw.TextStyle(fontSize: 6),
        ),
      ],
    ),
  );
}

pw.Widget _getModel7Page(Model7 model) {
  return pw.Directionality(
    textDirection: pw.TextDirection.rtl,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Align(
          alignment: pw.Alignment.center,
          child: pw.Text('المجلس البلدي سوق الجمعة'),
        ),
        pw.SizedBox(height: 16),
        pw.Align(
          alignment: pw.Alignment.center,
          child: pw.Text('محلة عرادة'),
        ),
        pw.Align(
          alignment: pw.Alignment.center,
          child: pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Text(model.documentTitle, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          ),
        ),
        pw.Row(
          children: [
            pw.Expanded(child: pw.Text('رمز الشارع:  ${model.streetNo}')),
            pw.Expanded(child: pw.Text('رمز المبنى:  ${model.buildingNo}')),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Text('رقم القيد:  ${model.registrationNo}'),
        pw.SizedBox(height: 16),
        pw.Text('اسم رب الأسرة رباعي:  ${model.familyHeadName}'),
        pw.SizedBox(height: 16),
        pw.Row(
          children: [
            pw.Expanded(child: pw.Text('عدد أفراد الأسرة')),
            pw.Expanded(child: pw.Text('ذكور(${model.malesCount})')),
            pw.Expanded(child: pw.Text('إناث (${model.femalesCount})')),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          children: [
            pw.Expanded(child: pw.Text('ذوي الاحتياجات الخاصة')),
            pw.Expanded(child: pw.Text('ذكور(${model.disabilities?.malesCount ?? 0})')),
            pw.Expanded(child: pw.Text('إناث (${model.disabilities?.femalesCount ?? 0})')),
          ],
        ),
        pw.Divider(height: 16, indent: 24, endIndent: 24, thickness: 0.25),
        pw.Row(
          children: [
            pw.Text('الأرامل:   '),
            if (model.widows.isEmpty) pw.Text('/ / / / /'),
            if (model.widows.isNotEmpty)
              pw.Expanded(
                child: pw.Column(
                  children: [
                    for (final widow in model.widows)
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('الاسم:  ${widow.name}'),
                          pw.Text('ذكور(${widow.malesCount})'),
                          pw.Text('إناث (${widow.femalesCount})'),
                        ],
                      ),
                  ],
                ),
              ),
          ],
        ),
        pw.Divider(height: 16, indent: 24, endIndent: 24, thickness: 0.25),
        pw.Row(
          children: [
            pw.Text('المطلقات:   '),
            if (model.divorced.isEmpty) pw.Text('/ / / / /'),
            if (model.divorced.isNotEmpty)
              pw.Expanded(
                child: pw.Column(
                  children: [
                    for (final divorced in model.divorced)
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('الاسم:  ${divorced.name}'),
                          pw.Text('ذكور(${divorced.malesCount})'),
                          pw.Text('إناث (${divorced.femalesCount})'),
                        ],
                      ),
                  ],
                ),
              ),
          ],
        ),
        pw.Divider(height: 16, indent: 24, endIndent: 24, thickness: 0.25),
        pw.Row(
          children: [
            pw.Text('أصحاب الدخل المحدود:   '),
            if (model.lowIncome.isEmpty) pw.Text('/ / / / /'),
            if (model.lowIncome.isNotEmpty)
              pw.Column(
                children: [for (final lowIncome in model.lowIncome) pw.Text('${lowIncome.name} (${lowIncome.type})')],
              ),
          ],
        ),
        pw.Divider(height: 16, indent: 24, endIndent: 24, thickness: 0.25),
        pw.Row(
          children: [
            pw.Text('الباحثين عن العمل:   '),
            if (model.unemployed.isEmpty) pw.Text('/ / / / /'),
            if (model.unemployed.isNotEmpty)
              pw.Expanded(
                child: pw.Column(
                  children: [
                    for (final unemployed in model.unemployed)
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('الاسم:  ${unemployed.name}'),
                          pw.Text('الجنس:  ${unemployed.gender}'),
                          pw.Text('المؤهل العلمي:  ${unemployed.qualification}'),
                        ],
                      ),
                  ],
                ),
              ),
          ],
        ),
        pw.Divider(height: 16, indent: 24, endIndent: 24, thickness: 0.25),
        pw.Text(
          'تاريخ وفاة رب الأسرة:  ${() {
            if (model.familyHeadDeathDate == null) return '/ / / / /';
            return DateFormat('yyyy/MM/dd').format(model.familyHeadDeathDate!);
          }()}',
        ),
        pw.SizedBox(height: 16),
        pw.Text('اسم رب الأسرة الحالي:  ${model.currentFamilyHeadName ?? '/ / / / /'}'),
        pw.Divider(height: 16, indent: 24, endIndent: 24, thickness: 0.25),
        pw.Text('اسم مدخل البيانات:  ${model.formFiller.name}'),
        pw.SizedBox(height: 16),
        pw.Text('رقم الهاتف:  ${model.formFiller.phoneNo}'),
        pw.SizedBox(height: 16),
        pw.Text('التوقيع:  .  .  .  .  .  .  .  .  .  .  .  .'),
        pw.Divider(height: 16, indent: 24, endIndent: 24, thickness: 0.25),
        pw.Row(
          children: [
            pw.Text('ملاحظات:  '),
            pw.Text(model.notes ?? '/ / / / /'),
          ],
        ),
        pw.SizedBox(height: 24),
        pw.Align(
          alignment: pw.Alignment.center,
          child: pw.Text('مختار المحلة'),
        ),
        pw.SizedBox(height: 16),
        pw.Align(
          alignment: pw.Alignment.center,
          child: pw.Text(
            '.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .',
            style: const pw.TextStyle(fontSize: 6),
          ),
        ),
      ],
    ),
  );
}
