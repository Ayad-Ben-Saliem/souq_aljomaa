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
import 'package:jhijri/jHijri.dart';
import 'package:intl/intl.dart';

pw.Font? arialFont;
pw.Font? arialFontBold;
Uint8List? govLogoData;

abstract class PdfBuilder {
  static Future<Uint8List> getFormContent(BaseModel model) async {
    arialFont ??= pw.Font.ttf(await rootBundle.load("assets/fonts/arial/arial.ttf"));
    arialFontBold ??= pw.Font.ttf(await rootBundle.load("assets/fonts/arial/arial-bold.ttf"));

    govLogoData ??= (await rootBundle.load('assets/images/government_logo.jpg')).buffer.asUint8List();

    final doc = pw.Document(
      theme: pw.ThemeData(
        defaultTextStyle: pw.TextStyle(
          font: arialFont,
          fontBold: arialFontBold,
          fontSize: 18,
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
        pw.Positioned(
          right: 215,
          top: 4,
          child: pw.Image(
            pw.MemoryImage(govLogoData!),
            width: 101,
            height: 101,
          ),
        ),
        pw.Positioned(
          right: 240,
          top: 180,
          child: pw.Text(model.locality),
        ),
        pw.Positioned(
          right: 80,
          top: 305,
          child: pw.Container(
            width: 215,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.witness),
          ),
        ),
        pw.Positioned(
          right: 375,
          top: 305,
          child: pw.Text(model.locality),
        ),
        pw.Positioned(
          right: 95,
          top: 345,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.firstName),
          ),
        ),
        pw.Positioned(
          right: 215,
          top: 345,
          child: pw.Container(
            width: 65,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.fatherName),
          ),
        ),
        pw.Positioned(
          right: 340,
          top: 345,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.grandfatherName),
          ),
        ),
        pw.Positioned(
          right: 440,
          top: 345,
          child: pw.Text(model.lastName),
        ),
        pw.Positioned(
          right: 120,
          top: 387,
          child: pw.Container(
            width: 135,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.motherName),
          ),
        ),
        pw.Positioned(
          right: 430,
          top: 382,
          child: pw.Text(model.identifierNo ?? ''),
        ),
        pw.Positioned(
          right: 125,
          top: 430,
          child: pw.Container(
            width: 355,
            child: pw.Builder(
              builder: (_) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    for (final num in model.nationalId.split('').reversed) pw.Text(num),
                    pw.Text('/'),
                  ],
                );
              },
            ),
          ),
        ),
        pw.Positioned(
          right: 170,
          top: 478,
          child: pw.Container(
            width: 325,
            height: 45,
            // color: PdfColors.amber,
            child: pw.Text(model.testimony),
          ),
        ),

        // =================== Hijri Date ===================
        pw.Positioned(
          right: 125,
          top: 565,
          child: pw.Text('${HijriDate.dateToHijri(model.date).day}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(
          right: 175,
          top: 565,
          child: pw.Text('${HijriDate.dateToHijri(model.date).month}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(
          right: 213,
          top: 565,
          child: pw.Text(HijriDate.dateToHijri(model.date).year.toString().substring(2), style: const pw.TextStyle(fontSize: 14)),
        ),

        // =================== Date ===================
        pw.Positioned(
          right: 350,
          top: 565,
          child: pw.Text('${model.date.day}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(
          right: 400,
          top: 565,
          child: pw.Text('${model.date.month}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(
          right: 433,
          top: 565,
          child: pw.Text(model.date.year.toString().substring(2), style: const pw.TextStyle(fontSize: 14)),
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
        pw.Positioned(
          right: 215,
          top: 4,
          child: pw.Image(
            pw.MemoryImage(govLogoData!),
            width: 101,
            height: 101,
          ),
        ),
        pw.Positioned(
          right: 240,
          top: 165,
          child: pw.Text(model.locality),
        ),
        pw.Positioned(
          right: 65,
          top: 278,
          child: pw.Container(
            width: 220,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.witness),
          ),
        ),
        pw.Positioned(
          right: 370,
          top: 278,
          child: pw.Text(model.locality),
        ),
        pw.Positioned(
          right: 85,
          top: 319,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.firstName),
          ),
        ),
        pw.Positioned(
          right: 205,
          top: 319,
          child: pw.Container(
            width: 65,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.fatherName),
          ),
        ),
        pw.Positioned(
          right: 330,
          top: 319,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.grandfatherName),
          ),
        ),
        pw.Positioned(
          right: 430,
          top: 319,
          child: pw.Text(model.lastName),
        ),
        pw.Positioned(
          right: 200,
          top: 353,
          child: pw.Text(model.identifierNo ?? ''),
        ),
        pw.Positioned(
          right: 375,
          top: 359,
          child: pw.Text(model.identifierFrom ?? ''),
        ),
        pw.Positioned(
          right: 117,
          top: 401,
          child: pw.Container(
            width: 355,
            child: pw.Builder(
              builder: (_) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    for (final num in model.nationalId.split('').reversed) pw.Text(num),
                    pw.Text('/'),
                  ],
                );
              },
            ),
          ),
        ),
        pw.Positioned(
          right: 140,
          top: 440,
          child: pw.Container(
            width: 350,
            height: 42,
            // color: PdfColors.amber,
            child: pw.Text(model.testimony),
          ),
        ),

        // =================== Hijri Date ===================
        pw.Positioned(
          right: 115,
          top: 522,
          child: pw.Text('${HijriDate.dateToHijri(model.date).day}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(
          right: 160,
          top: 522,
          child: pw.Text('${HijriDate.dateToHijri(model.date).month}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(
          right: 198,
          top: 522,
          child: pw.Text(HijriDate.dateToHijri(model.date).year.toString().substring(2), style: const pw.TextStyle(fontSize: 14)),
        ),

        // =================== Date ===================
        pw.Positioned(
          right: 330,
          top: 522,
          child: pw.Text('${model.date.day}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(
          right: 380,
          top: 522,
          child: pw.Text('${model.date.month}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(
          right: 419,
          top: 522,
          child: pw.Text(model.date.year.toString().substring(2), style: const pw.TextStyle(fontSize: 14)),
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
        pw.Positioned(
          right: 215,
          top: 4,
          child: pw.Image(
            pw.MemoryImage(govLogoData!),
            width: 101,
            height: 101,
          ),
        ),
        pw.Positioned(
          right: 240,
          top: 165,
          child: pw.Text(model.locality),
        ),
        pw.Positioned(
          right: 65,
          top: 278,
          child: pw.Container(
            width: 220,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.witness),
          ),
        ),
        pw.Positioned(
          right: 370,
          top: 278,
          child: pw.Text(model.locality),
        ),
        pw.Positioned(
          right: 85,
          top: 319,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.firstName),
          ),
        ),
        pw.Positioned(
          right: 205,
          top: 319,
          child: pw.Container(
            width: 65,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.fatherName),
          ),
        ),
        pw.Positioned(
          right: 330,
          top: 319,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.grandfatherName),
          ),
        ),
        pw.Positioned(
          right: 430,
          top: 319,
          child: pw.Text(model.lastName),
        ),
        pw.Positioned(
          right: 200,
          top: 353,
          child: pw.Text(model.identifierNo ?? ''),
        ),
        pw.Positioned(
          right: 375,
          top: 359,
          child: pw.Text(model.identifierFrom ?? ''),
        ),
        pw.Positioned(
          right: 117,
          top: 401,
          child: pw.Container(
            width: 355,
            child: pw.Builder(
              builder: (_) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    for (final num in model.nationalId.split('').reversed) pw.Text(num),
                    pw.Text('/'),
                  ],
                );
              },
            ),
          ),
        ),
        pw.Positioned(
            right: 125,
            top: 440,
            child: pw.Container(
              width: 375,
              height: 40,
              // color: PdfColors.amber,
              child: pw.Text(model.testimony),
            )),

        // =================== Hijri Date ===================
        pw.Positioned(
          right: 115,
          top: 550,
          child: pw.Text('${HijriDate.dateToHijri(model.date).day}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(
          right: 160,
          top: 550,
          child: pw.Text('${HijriDate.dateToHijri(model.date).month}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(
          right: 198,
          top: 550,
          child: pw.Text(HijriDate.dateToHijri(model.date).year.toString().substring(2), style: const pw.TextStyle(fontSize: 14)),
        ),

        // =================== Date ===================
        pw.Positioned(
          right: 330,
          top: 550,
          child: pw.Text('${model.date.day}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(
          right: 380,
          top: 550,
          child: pw.Text('${model.date.month}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(
          right: 419,
          top: 550,
          child: pw.Text(model.date.year.toString().substring(2), style: const pw.TextStyle(fontSize: 14)),
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
        pw.Positioned(
          right: 215,
          top: 4,
          child: pw.Image(
            pw.MemoryImage(govLogoData!),
            width: 101,
            height: 101,
          ),
        ),
        pw.Positioned(
          right: 240,
          top: 153,
          child: pw.Text(model.locality),
        ),
        pw.Positioned(
          right: 75,
          top: 262,
          child: pw.Container(
            width: 220,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.witness),
          ),
        ),
        pw.Positioned(
          right: 375,
          top: 262,
          child: pw.Text(model.locality),
        ),
        pw.Positioned(
          right: 90,
          top: 301,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.firstName),
          ),
        ),
        pw.Positioned(
          right: 210,
          top: 301,
          child: pw.Container(
            width: 65,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.fatherName),
          ),
        ),
        pw.Positioned(
          right: 335,
          top: 301,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.grandfatherName),
          ),
        ),
        pw.Positioned(
          right: 440,
          top: 301,
          child: pw.Text(model.lastName),
        ),
        pw.Positioned(
          right: 225,
          top: 340,
          child: pw.Text(model.identifierNo ?? ''),
        ),
        pw.Positioned(
          right: 410,
          top: 343,
          child: pw.Text(model.identifierFrom ?? ''),
        ),
        pw.Positioned(
          right: 122,
          top: 387,
          child: pw.Container(
            width: 355,
            child: pw.Builder(
              builder: (_) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    for (final num in model.nationalId.split('').reversed) pw.Text(num),
                    pw.Text('/'),
                  ],
                );
              },
            ),
          ),
        ),
        pw.Positioned(
          right: 170,
          top: 435,
          child: pw.Container(
            width: 325,
            height: 75,
            // color: PdfColors.amber,
            child: pw.Text(model.testimony),
          ),
        ),

        // =================== Hijri Date ===================
        pw.Positioned(
          right: 115,
          top: 558,
          child: pw.Text('${HijriDate.dateToHijri(model.date).day}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(
          right: 160,
          top: 558,
          child: pw.Text('${HijriDate.dateToHijri(model.date).month}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(
          right: 200,
          top: 558,
          child: pw.Text(HijriDate.dateToHijri(model.date).year.toString().substring(2), style: const pw.TextStyle(fontSize: 14)),
        ),

        // =================== Date ===================
        pw.Positioned(
          right: 330,
          top: 557.5,
          child: pw.Text('${model.date.day}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(
          right: 380,
          top: 557.5,
          child: pw.Text('${model.date.month}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(
          right: 420,
          top: 557.5,
          child: pw.Text(model.date.year.toString().substring(2), style: const pw.TextStyle(fontSize: 14)),
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
        pw.Positioned(
          right: 215,
          top: 4,
          child: pw.Image(
            pw.MemoryImage(govLogoData!),
            width: 101,
            height: 101,
          ),
        ),
        pw.Positioned(right: 224, top: 170, child: dots(16)),
        pw.Positioned(
          right: 230,
          top: 160,
          child: pw.Text(model.locality),
        ),
        pw.Positioned(right: 60, top: 243, child: dots(55)),
        pw.Positioned(
          right: 65,
          top: 234,
          child: pw.Container(
            width: 220,
            height: 40,
            // // color: PdfColors.amber,
            child: pw.Text(model.witness),
          ),
        ),
        pw.Positioned(right: 365, top: 243, child: dots(30)),
        pw.Positioned(
          right: 370,
          top: 234,
          child: pw.Text(model.locality),
        ),
        pw.Positioned(right: 81, top: 283, child: dots(16)),
        pw.Positioned(
          right: 85,
          top: 274,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.firstName),
          ),
        ),
        pw.Positioned(right: 200, top: 283, child: dots(16)),
        pw.Positioned(
          right: 205,
          top: 274,
          child: pw.Container(
            width: 65,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.fatherName),
          ),
        ),
        pw.Positioned(right: 325, top: 283, child: dots(15)),
        pw.Positioned(
          right: 330,
          top: 274,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.grandfatherName),
          ),
        ),
        pw.Positioned(right: 427, top: 283, child: dots(15)),
        pw.Positioned(
          right: 430,
          top: 274,
          child: pw.Text(model.lastName),
        ),
        pw.Positioned(right: 110, top: 325, child: dots(32)),
        pw.Positioned(
          right: 115,
          top: 316,
          child: pw.Container(
            width: 130,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.motherName),
          ),
        ),
        pw.Positioned(right: 415, top: 325, child: dots(18)),
        pw.Positioned(
          right: 420,
          top: 313,
          child: pw.Text(model.identifierNo ?? ''),
        ),
        pw.Positioned(
          right: 116,
          top: 362,
          child: pw.Container(
            width: 355,
            child: pw.Builder(
              builder: (_) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    for (final num in model.nationalId.split('').reversed) pw.Text(num),
                    pw.Text('/'),
                  ],
                );
              },
            ),
          ),
        ),
        pw.Positioned(right: 133, top: 407, child: dots(31)),
        pw.Positioned(
          right: 150,
          top: 394,
          child: pw.Text(model.familyBookletNumber),
        ),
        pw.Positioned(right: 363, top: 407, child: dots(31)),
        pw.Positioned(
          right: 370,
          top: 394,
          child: pw.Text(model.familyDocumentNumber),
        ),
        pw.Positioned(right: 132, top: 447, child: dots(32)),
        pw.Positioned(
          right: 135,
          top: 438,
          child: pw.Text(model.issuePlace),
        ),
        pw.Positioned(right: 360, top: 447, child: dots(32)),
        pw.Positioned(
          right: 365,
          top: 435,
          child: pw.Text(model.issueDate),
        ),
        pw.Positioned(right: 100, top: 488, child: dots(40)),
        pw.Positioned(
          right: 100,
          top: 479,
          child: pw.Text(model.residence),
        ),
        pw.Positioned(right: 354, top: 488, child: dots(32)),
        pw.Positioned(
          right: 360,
          top: 477,
          child: pw.Container(
            width: 150,
            height: 45,
            // color: PdfColors.amber,
            child: pw.Text(model.nearestPoint),
          ),
        ),

        // =================== Hijri Date ===================
        pw.Positioned(right: 101, top: 574, child: dots(10)),
        pw.Positioned(
          right: 115,
          top: 565,
          child: pw.Text('${HijriDate.dateToHijri(model.date).day}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(right: 149, top: 574, child: dots(10)),
        pw.Positioned(
          right: 160,
          top: 565,
          child: pw.Text('${HijriDate.dateToHijri(model.date).month}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(right: 194, top: 574, child: dots(5)),
        pw.Positioned(
          right: 199,
          top: 565,
          child: pw.Text(HijriDate.dateToHijri(model.date).year.toString().substring(2), style: const pw.TextStyle(fontSize: 14)),
        ),

        // =================== Date ===================
        pw.Positioned(right: 324, top: 573, child: dots(9)),
        pw.Positioned(
          right: 330,
          top: 565,
          child: pw.Text('${model.date.day}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(right: 367, top: 573, child: dots(9)),
        pw.Positioned(
          right: 375,
          top: 565,
          child: pw.Text('${model.date.month}', style: const pw.TextStyle(fontSize: 14)),
        ),
        pw.Positioned(right: 412, top: 573, child: dots(5)),
        pw.Positioned(
          right: 419,
          top: 565,
          child: pw.Text(model.date.year.toString().substring(2), style: const pw.TextStyle(fontSize: 14)),
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
        pw.SizedBox(height: 24),
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
  pw.Widget separator() => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 8),
        child: pw.Text('    -----    ' * 70, style: const pw.TextStyle(fontSize: 2)),
      );
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
        separator(),
        // pw.Divider(height: 16, thickness: 0.1),
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
        separator(),
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
        separator(),
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
        separator(),
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
        separator(),
        pw.Text(
          'تاريخ وفاة رب الأسرة:  ${() {
            if (model.familyHeadDeathDate == null) return '/ / / / /';
            return DateFormat('yyyy/MM/dd').format(model.familyHeadDeathDate!);
          }()}',
        ),
        pw.SizedBox(height: 16),
        pw.Text('اسم رب الأسرة الحالي:  ${model.currentFamilyHeadName ?? '/ / / / /'}'),
        separator(),
        pw.Text('اسم مدخل البيانات:  ${model.formFiller.name}'),
        pw.SizedBox(height: 16),
        pw.Text('رقم الهاتف:  ${model.formFiller.phoneNo}'),
        pw.SizedBox(height: 16),
        pw.Row(children: [
          pw.Text('التوقيع: '),
          pw.Text('  .  ' * 10, style: const pw.TextStyle(fontSize: 10)),
        ]),
        separator(),
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
          child: pw.Text('  .  ' * 10, style: const pw.TextStyle(fontSize: 10)),
        ),
      ],
    ),
  );
}

const dotsTextStyle = pw.TextStyle(fontSize: 5);

pw.Widget dots(int times) {
  return pw.Container(
    color: PdfColors.white,
    child: pw.Text(' . ' * times, style: dotsTextStyle),
  );
}
