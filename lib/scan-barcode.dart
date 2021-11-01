import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tag/Controllers/data-controller.dart';
import 'package:tag/Controllers/user-controller.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Barcode result;
  late QRViewController controller;

  final DataController data = Get.find();
  final UserController userController = Get.find();

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) {
        controller.pauseCamera();
        Get.back();
        data.fetchDataFromScan(scanData.code);
        // showMaterialModalBottomSheet(
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        //   context: context,
        //   builder: (context) {
        //     return Padding(
        //       padding: const EdgeInsets.all(10),
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           Obx(
        //             () => SizedBox(
        //               width: Get.width,
        //               child: ElevatedButton(
        //                 onPressed: data.isNewData.value == false || userController.user.value.role! == 2
        //                     ? null
        //                     : () {
        //                         Get.back();
        //                         Get.toNamed('/input');
        //                       },
        //                 child: Text('Buat data baru'),
        //               ),
        //             ),
        //           ),
        //           SizedBox(height: 10),
        //           Obx(
        //             () => SizedBox(
        //               width: Get.width,
        //               child: ElevatedButton(
        //                 onPressed: data.isUpdatableData.value == false
        //                     ? null
        //                     : () {
        //                         Get.back();
        //                         Get.toNamed('/edit');
        //                       },
        //                 child: Text('Update data'),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    data.isUpdatableData.value = false;
    data.isNewData.value = false;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Scan QR'),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            overlay: QrScannerOverlayShape(borderColor: Colors.white, borderRadius: 20, borderWidth: 10),
            onQRViewCreated: _onQRViewCreated,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 64),
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: OutlinedButton(
          //       style: OutlinedButton.styleFrom(
          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          //         side: BorderSide(color: Colors.white, width: 1),
          //       ),
          //       onPressed: () {},
          //       child: Text(
          //         'Input Manual',
          //         style: GoogleFonts.sourceSansPro(color: Colors.white),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
