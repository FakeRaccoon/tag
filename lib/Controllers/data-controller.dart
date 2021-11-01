import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as doi;
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tag/Controllers/initial-controller.dart';
import 'package:tag/Controllers/user-controller.dart';
import 'package:tag/Grid/data-grid-source.dart';
import 'package:tag/Models/all-data-model.dart';
import 'package:tag/Models/data-model.dart';
import 'package:tag/Models/item-model.dart';
import 'package:tag/Models/warehouse-model.dart';
import 'package:tag/api-service.dart';

import '../data-edit-page.dart';

class DataController extends GetxController {
  final user = Get.find<UserController>();

  var item = ItemModel().obs;
  var data = TagModel().obs;
  var warehouse = [WarehouseModel()].obs;
  var allListLoading = true.obs;
  var itemLoading = true.obs;
  var isLoading = true.obs;
  var isNewData = false.obs;
  var isUpdatableData = false.obs;
  var currentCode = ''.obs;
  var id = 0.obs;
  var query = ''.obs;

  var roleList = [
    'Gudang',
    'Teknisi',
    'Kepala Teknisi',
    'Owner',
  ];

  var done = false.obs;

  var isNewInput = true.obs;

  var itemId = 0.obs; //item_id

  var itemCodeController = TextEditingController().obs;
  var itemController = TextEditingController().obs;

  final InitialController authController = Get.find();
  final UserController userController = Get.find();

  fetchData(code) {
    currentCode.value = code;
    itemController.value.clear();
    APIService().getTag(code).then((value) {
      data.value = value;
      id.value = data.value.id!;
      // isUpdatableData.value = true;
    }, onError: (e) {
      // isNewData.value = true;
    });
  }

  fetchDataFromScan(code) {
    currentCode.value = code;
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
    APIService().getTag(code).then((value) {
      Get.back();
      data.value = value;
      id.value = data.value.id!;
      Get.toNamed('/edit');
      // isUpdatableData.value = true;
    }, onError: (e) {
      Get.back();
      isNewData.value = true;
      Get.toNamed('/input');
      // isNewData.value = true;
    });
  }

  fetchDataWeb(code) {
    currentCode.value = code;
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
    APIService().getTag(code).then((value) {
      Get.back();
      data.value = value;
      id.value = data.value.id!;
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: DataEditPage(),
        ),
      );
    }, onError: (e) {
      Get.back();
      // Get.dialog(
      //   Dialog(
      //     child: Padding(
      //       padding: const EdgeInsets.all(10),
      //       child: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           Text('Barang dengan kode ${currentCode.value} belum ada. Tambah baru?'),
      //           SizedBox(height: 20),
      //           ElevatedButton(
      //             onPressed: () {
      //               Get.back();
      //               Get.toNamed('/input');
      //             },
      //             child: Text('Buat data baru'),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // );
    });
  }

  fetchItem() {
    APIService().getItem(query.value).then((value) {
      item.value = value;
      itemLoading.value = false;
    }, onError: (e) {});
  }

  createData(description, location) {
    APIService().createTag(currentCode.value, description, itemId.value, location).then((value) {
      fetchData(currentCode.value);
      Get.back();
      Get.snackbar(
        'Success',
        'Berhasil menambahkan data',
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(10),
      );
    }, onError: (e) {});
  }

  createWarehouse(name, location) {
    APIService().createWarehouse(name, location).then((value) {
      fetchWarehouse();
      fetchData(currentCode.value);
      Get.back();
      Get.snackbar(
        'Success',
        'Berhasil menambahkan gudang',
        margin: EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
      );
    }, onError: (e) {});
  }

  editData(code, id, status, type, urgency, description, location) {
    APIService().editTag(code, id, status, type, urgency, description, location).then((value) {
      fetchData(currentCode.value);
      Get.snackbar(
        'Success',
        'Berhasil edit data',
        margin: EdgeInsets.all(10),
        colorText: Colors.white,
        backgroundColor: Colors.black54,
        snackPosition: SnackPosition.BOTTOM,
      );
    }, onError: (e) {});
  }

  // editLocation(code, id, description, location) {
  //   APIService().editTag(code, id, data.value.item!.id, description, location).then((value) {
  //     fetchData(currentCode.value);
  //     Get.snackbar(
  //       'Success',
  //       'Berhasil edit data',
  //       margin: EdgeInsets.all(10),
  //       colorText: Colors.white,
  //       backgroundColor: Colors.black54,
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }, onError: (e) {});
  // }

  addPart(id, name) {
    APIService().createPart(id, name).then((value) {
      fetchData(currentCode.value);
    }, onError: (e) {});
  }

  addDiagnoses(id, name) {
    APIService().createDiagnosis(id, name).then((value) {
      fetchData(currentCode.value);
    }, onError: (e) {});
  }

  addTreatment(id, name) {
    APIService().createTreatment(id, name).then((value) {
      fetchData(currentCode.value);
    }, onError: (e) {});
  }

  addImage(url) {
    APIService().createImage(data.value.id, url).then((value) {
      fetchData(currentCode.value);
    }, onError: (e) {});
  }

  addLog(log, type) {
    APIService().createLog(log, type);
  }

  uploadImage(File file) async {
    final box = GetStorage();
    final token = box.read('token');
    try {
      int progress = 0;
      int total = 0;
      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            value: total != 0 ? progress / total : null,
          ),
        ),
        barrierDismissible: false,
      );
      doi.FormData formData = doi.FormData.fromMap({
        'image': await doi.MultipartFile.fromFile(file.path),
      });
      var response = await doi.Dio().post(
        '${authController.url}/api/images/store',
        options: doi.Options(headers: {'Authorization': 'Bearer $token'}),
        data: formData,
        onSendProgress: (send, remaining) {
          progress = send;
          total = remaining;
        },
      );
      await addImage(response.data['data']);
      Get.back();
      return response.data;
    } on doi.DioError catch (e) {
      Get.back();
      print(e);
      throw e.message;
    }
  }

  fetchWarehouse() {
    isLoading.value = true;
    APIService().getWarehouse().then((value) {
      isLoading.value = false;
      warehouse.value = value;
    }, onError: (e) {});
  }

  @override
  void onInit() {
    super.onInit();
    fetchWarehouse();
    debounce(query, (_) => fetchItem());
  }

  @override
  void onClose() {
    super.onClose();
  }
}
