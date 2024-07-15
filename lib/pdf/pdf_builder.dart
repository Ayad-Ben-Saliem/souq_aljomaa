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

const altitude = -3;

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
          fontSize: 14,
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
            child: pw.Builder(
              builder: (context) {
                if (model is Model1) return _getModel1Page(model);
                if (model is Model2) return _getModel2Page(model);
                if (model is Model3) return _getModel3Page(model);
                if (model is Model4) return _getModel4Page(model);
                if (model is Model5) return _getModel5Page(model);
                if (model is Model6) return _getModel6Page(model);
                if (model is Model7) return _getModel7Page(model);

                return pw.Center(child: pw.Text('غير مصممة بعد'));
              },
            ),
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
          top: altitude + 180,
          child: pw.Text(model.locality, textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 80,
          top: altitude + 305,
          child: pw.Container(
            width: 215,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.witness, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 375,
          top: altitude + 305,
          child: pw.Text(model.locality, textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 95,
          top: altitude + 345,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.firstName, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 215,
          top: altitude + 345,
          child: pw.Container(
            width: 65,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.fatherName, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 340,
          top: altitude + 345,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.grandfatherName, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 440,
          top: altitude + 345,
          child: pw.Text(model.lastName, textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 120,
          top: altitude + 387,
          child: pw.Container(
            width: 135,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.motherName, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 430,
          top: altitude + 388,
          child: pw.Text(model.identifierNo ?? '', textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 125,
          top: altitude + 436,
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
          top: altitude + 478,
          child: pw.Container(
            width: 325,
            height: 45,
            // color: PdfColors.amber,
            child: pw.Text(model.testimony, textAlign: pw.TextAlign.center),
          ),
        ),

        // =================== Hijri Date ===================
        pw.Positioned(
          right: 125,
          top: 565,
          child: pw.Text('${HijriDate.dateToHijri(model.date).day}'),
        ),
        pw.Positioned(
          right: 175,
          top: 565,
          child: pw.Text('${HijriDate.dateToHijri(model.date).month}'),
        ),
        pw.Positioned(
          right: 213,
          top: 565,
          child: pw.Text(HijriDate.dateToHijri(model.date).year.toString().substring(2)),
        ),

        // =================== Date ===================
        pw.Positioned(
          right: 350,
          top: 565,
          child: pw.Text('${model.date.day}'),
        ),
        pw.Positioned(
          right: 400,
          top: 565,
          child: pw.Text('${model.date.month}'),
        ),
        pw.Positioned(
          right: 433,
          top: 565,
          child: pw.Text(model.date.year.toString().substring(2)),
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
          top: altitude + 165,
          child: pw.Text(model.locality, textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 65,
          top: altitude + 278,
          child: pw.Container(
            width: 220,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.witness, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 370,
          top: altitude + 278,
          child: pw.Text(model.locality, textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 85,
          top: altitude + 319,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.firstName, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 205,
          top: altitude + 319,
          child: pw.Container(
            width: 65,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.fatherName, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 330,
          top: altitude + 319,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.grandfatherName, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 430,
          top: altitude + 319,
          child: pw.Text(model.lastName, textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 200,
          top: altitude + 359,
          child: pw.Text(model.identifierNo ?? '', textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 375,
          top: altitude + 359,
          child: pw.Text(model.identifierFrom ?? '', textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 117,
          top: altitude + 407,
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
          top: altitude + 440,
          child: pw.Container(
            width: 350,
            height: 42,
            // color: PdfColors.amber,
            child: pw.Text(model.testimony, textAlign: pw.TextAlign.center),
          ),
        ),

        // =================== Hijri Date ===================
        pw.Positioned(
          right: 115,
          top: 522,
          child: pw.Text('${HijriDate.dateToHijri(model.date).day}'),
        ),
        pw.Positioned(
          right: 160,
          top: 522,
          child: pw.Text('${HijriDate.dateToHijri(model.date).month}'),
        ),
        pw.Positioned(
          right: 198,
          top: 522,
          child: pw.Text(HijriDate.dateToHijri(model.date).year.toString().substring(2)),
        ),

        // =================== Date ===================
        pw.Positioned(
          right: 330,
          top: 522,
          child: pw.Text('${model.date.day}'),
        ),
        pw.Positioned(
          right: 380,
          top: 522,
          child: pw.Text('${model.date.month}'),
        ),
        pw.Positioned(
          right: 419,
          top: 522,
          child: pw.Text(model.date.year.toString().substring(2)),
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
          top: altitude + 165,
          child: pw.Text(model.locality, textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 65,
          top: altitude + 278,
          child: pw.Container(
            width: 220,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.witness, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 370,
          top: altitude + 278,
          child: pw.Text(model.locality, textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 85,
          top: altitude + 319,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.firstName, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 205,
          top: altitude + 319,
          child: pw.Container(
            width: 65,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.fatherName, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 330,
          top: altitude + 319,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.grandfatherName, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 430,
          top: altitude + 319,
          child: pw.Text(model.lastName, textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 200,
          top: altitude + 359,
          child: pw.Text(model.identifierNo ?? '', textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 375,
          top: altitude + 359,
          child: pw.Text(model.identifierFrom ?? '', textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 117,
          top: altitude + 407,
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
            top: altitude + 440,
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
          child: pw.Text('${HijriDate.dateToHijri(model.date).day}'),
        ),
        pw.Positioned(
          right: 160,
          top: 550,
          child: pw.Text('${HijriDate.dateToHijri(model.date).month}'),
        ),
        pw.Positioned(
          right: 198,
          top: 550,
          child: pw.Text(HijriDate.dateToHijri(model.date).year.toString().substring(2)),
        ),

        // =================== Date ===================
        pw.Positioned(
          right: 330,
          top: 550,
          child: pw.Text('${model.date.day}'),
        ),
        pw.Positioned(
          right: 380,
          top: 550,
          child: pw.Text('${model.date.month}'),
        ),
        pw.Positioned(
          right: 419,
          top: 550,
          child: pw.Text(model.date.year.toString().substring(2)),
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
          top: altitude + 153,
          child: pw.Text(model.locality, textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 75,
          top: altitude + 262,
          child: pw.Container(
            width: 220,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.witness, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 375,
          top: altitude + 262,
          child: pw.Text(model.locality, textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 90,
          top: altitude + 301,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.firstName, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 210,
          top: altitude + 301,
          child: pw.Container(
            width: 65,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.fatherName, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 335,
          top: altitude + 301,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.grandfatherName, textAlign: pw.TextAlign.center),
          ),
        ),
        pw.Positioned(
          right: 440,
          top: altitude + 301,
          child: pw.Text(model.lastName, textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 225,
          top: altitude + 346,
          child: pw.Text(model.identifierNo ?? '', textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 410,
          top: altitude + 343,
          child: pw.Text(model.identifierFrom ?? '', textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 122,
          top: altitude + 393,
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
          top: altitude + 435,
          child: pw.Container(
            width: 325,
            height: 75,
            // color: PdfColors.amber,
            child: pw.Text(model.testimony, textAlign: pw.TextAlign.center),
          ),
        ),

        // =================== Hijri Date ===================
        pw.Positioned(
          right: 115,
          top: 558,
          child: pw.Text('${HijriDate.dateToHijri(model.date).day}'),
        ),
        pw.Positioned(
          right: 160,
          top: 558,
          child: pw.Text('${HijriDate.dateToHijri(model.date).month}'),
        ),
        pw.Positioned(
          right: 200,
          top: 558,
          child: pw.Text(HijriDate.dateToHijri(model.date).year.toString().substring(2)),
        ),

        // =================== Date ===================
        pw.Positioned(
          right: 330,
          top: 557.5,
          child: pw.Text('${model.date.day}'),
        ),
        pw.Positioned(
          right: 380,
          top: 557.5,
          child: pw.Text('${model.date.month}'),
        ),
        pw.Positioned(
          right: 420,
          top: 557.5,
          child: pw.Text(model.date.year.toString().substring(2)),
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
        // pw.Positioned(right: 224, top: altitude + 170, child: dots(16)),
        pw.Positioned(
          right: 230,
          top: altitude + 160,
          child: pw.Text(model.locality, textAlign: pw.TextAlign.center),
        ),
        // pw.Positioned(right: 60, top: altitude + 243, child: dots(55)),
        pw.Positioned(
          right: 65,
          top: altitude + 234,
          child: pw.Container(
            width: 220,
            height: 40,
            // // color: PdfColors.amber,
            child: pw.Text(model.witness, textAlign: pw.TextAlign.center),
          ),
        ),
        // pw.Positioned(right: 365, top: altitude + 243, child: dots(30)),
        pw.Positioned(
          right: 370,
          top: altitude + 234,
          child: pw.Text(model.locality, textAlign: pw.TextAlign.center),
        ),
        // pw.Positioned(right: 81, top: altitude + 283, child: dots(16)),
        pw.Positioned(
          right: 81,
          top: altitude + 273,
          child: pw.Container(
            width: 68,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.firstName, textAlign: pw.TextAlign.center),
          ),
        ),
        // pw.Positioned(right: 200, top: altitude + 283, child: dots(16)),
        pw.Positioned(
          right: 205,
          top: altitude + 273,
          child: pw.Container(
            width: 65,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.fatherName, textAlign: pw.TextAlign.center),
          ),
        ),
        // pw.Positioned(right: 325, top: altitude + 283, child: dots(15)),
        pw.Positioned(
          right: 330,
          top: altitude + 273,
          child: pw.Container(
            width: 62,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.grandfatherName, textAlign: pw.TextAlign.center),
          ),
        ),
        // pw.Positioned(right: 427, top: altitude + 283, child: dots(15)),
        pw.Positioned(
          right: 430,
          top: altitude + 273,
          child: pw.Text(model.lastName, textAlign: pw.TextAlign.center),
        ),
        // pw.Positioned(right: 110, top: altitude + 325, child: dots(32)),
        pw.Positioned(
          right: 115,
          top: altitude + 316,
          child: pw.Container(
            width: 130,
            height: 40,
            // color: PdfColors.amber,
            child: pw.Text(model.motherName, textAlign: pw.TextAlign.center),
          ),
        ),
        // pw.Positioned(right: 415, top: altitude + 325, child: dots(18)),
        pw.Positioned(
          right: 420,
          top: altitude + 318,
          child: pw.Text(model.identifierNo ?? '', textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 116,
          top: altitude + 368,
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
        // pw.Positioned(right: 133, top: altitude + 407, child: dots(31)),
        pw.Positioned(
          right: 150,
          top: altitude + 400,
          child: pw.Text(model.familyBookletNumber, textAlign: pw.TextAlign.center),
        ),
        // pw.Positioned(right: 363, top: altitude + 407, child: dots(31)),
        pw.Positioned(
          right: 370,
          top: altitude + 399,
          child: pw.Text(model.familyDocumentNumber, textAlign: pw.TextAlign.center),
        ),
        // pw.Positioned(right: 132, top: altitude + 447, child: dots(32)),
        pw.Positioned(
          right: 135,
          top: altitude + 438,
          child: pw.Text(model.issuePlace, textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 365,
          top: altitude + 439,
          child: pw.Text(model.issueDate, textAlign: pw.TextAlign.center),
        ),
        pw.Positioned(
          right: 100,
          top: altitude + 479,
          child: pw.Text(model.residence, textAlign: pw.TextAlign.center),
        ),
        // pw.Positioned(right: 354, top: altitude + 488, child: dots(32)),
        pw.Positioned(
          right: 360,
          top: altitude + 477,
          child: pw.Container(
            width: 150,
            height: 45,
            // color: PdfColors.amber,
            child: pw.Text(model.nearestPoint, textAlign: pw.TextAlign.center),
          ),
        ),

        // =================== Hijri Date ===================
        // pw.Positioned(right: 101, top: altitude + 574, child: dots(10)),
        pw.Positioned(
          right: 115,
          top: 565,
          child: pw.Text('${HijriDate.dateToHijri(model.date).day}'),
        ),
        // pw.Positioned(right: 149, top: altitude + 574, child: dots(10)),
        pw.Positioned(
          right: 160,
          top: 565,
          child: pw.Text('${HijriDate.dateToHijri(model.date).month}'),
        ),
        // pw.Positioned(right: 194, top: altitude + 574, child: dots(5)),
        pw.Positioned(
          right: 199,
          top: 565,
          child: pw.Text(HijriDate.dateToHijri(model.date).year.toString().substring(2)),
        ),

        // =================== Date ===================
        // pw.Positioned(right: 324, top: altitude + 573, child: dots(9)),
        pw.Positioned(
          right: 330,
          top: 565,
          child: pw.Text('${model.date.day}'),
        ),
        // pw.Positioned(right: 367, top: altitude + 573, child: dots(9)),
        pw.Positioned(
          right: 375,
          top: 565,
          child: pw.Text('${model.date.month}'),
        ),
        // pw.Positioned(right: 412, top: altitude + 573, child: dots(5)),
        pw.Positioned(
          right: 419,
          top: 565,
          child: pw.Text(model.date.year.toString().substring(2)),
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
            child: pw.Text(model.documentTitle, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
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
