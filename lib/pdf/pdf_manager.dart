import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/models/model1.dart';
import 'package:souq_aljomaa/models/model2.dart';
import 'package:souq_aljomaa/models/model3.dart';
import 'package:souq_aljomaa/models/model4.dart';
import 'package:souq_aljomaa/models/model5.dart';

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
  static Future<Uint8List> getDocument(BaseModel model, [PdfPageFormat? format]) async {
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
          fontSize: 14,
        ),
      ),
    );

    final page = pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Builder(
            builder: (context) {
              if (model is Model1) return _getModel1Page(model);
              if (model is Model2) return _getModel2Page(model);
              if (model is Model3) return _getModel3Page(model);
              if (model is Model4) return _getModel4Page(model);
              if (model is Model5) return _getModel5Page(model);

              return pw.Center(child: pw.Text('غير مصممة بعد'));
            },
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
            pw.Image(pw.MemoryImage(headerImageData!)),
            pw.SizedBox(height: 16),
            pw.Text('محلة: ${model.locality}'),
            pw.Padding(
              padding: const pw.EdgeInsets.all(32),
              child: pw.Text(model.documentTitle, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
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
