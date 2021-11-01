import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tag/Controllers/export-controller.dart';

class ExportPdf extends StatelessWidget {
  final controller = Get.put(ExportController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Export PDF',
          style: GoogleFonts.sourceSansPro(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextFormField(
            onTap: () => showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2021, 1, 1),
              lastDate: DateTime(2022, 1, 1),
            ),
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Dari',
              suffixIcon: Icon(Icons.date_range_rounded),
            ),
          ),
          TextFormField(
            onTap: () => showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2021, 1, 1),
              lastDate: DateTime(2022, 1, 1),
            ),
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Sampai',
              suffixIcon: Icon(Icons.date_range_rounded),
            ),
          ),
          ElevatedButton(
            onPressed: () => controller.createPdf(),
            child: Text('Export'),
          ),
        ],
      ),
    );
  }
}
