import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:tag/Models/all-data-model.dart';
import 'package:tag/api-service.dart';

class ExportController extends GetxController {
  final pdf = Document();

  void getDataByDate() {
    // APIService().getDataByDate(1, fromDate, toDate)
  }

  void createPdf() async {
    final font = await rootBundle.load("assets/OpenSans-Regular.ttf");
    var myFont = pw.Font.ttf(font);
    var myStyle = pw.TextStyle(font: myFont);
    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Laporan Barang',
              style: pw.TextStyle(
                font: myFont,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        build: (context) {
          return [
            pw.Text(DateFormat('d MMMM y').format(DateTime.now())),
          ];
        },
      ),
    );
    final path = await getExternalStorageDirectory();
    final file = File('${path!.path}/report.pdf');
    await file.writeAsBytes(await pdf.save());
  }
}
