import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:tag/Controllers/item-controller.dart';
import 'package:tag/Grid/data-grid-source.dart';
import 'package:tag/Models/categories-model.dart';
import 'package:tag/api-service.dart';

class FilterController extends GetxController {
  final controller = Get.find<ItemController>();


  late TextEditingController itemSearchControllerFilter;
  var filter = "Semua Barang".obs;
  var filterList = [
    'Semua Barang',
    'Status',
    'Kategori',
    'Merk',
    'Fungsi',
  ].obs;
  var subFilter = "".obs;
  var categoryList = <String>[].obs;

  void setFilter(String value) {
    if (value == 'Semua Barang') {
      APIService().getAllTag(1).then((value) {
        controller.itemDataSource.value = ItemDataSource(value.data!);
      }, onError: (e) {});
    }
    if (value == 'Kategori') {
      APIService().getAllCategory().then((value) => categoryList.value = value.map((e) => e.categoryName!).toList());
    }
    if (value == 'Merk') {
      APIService().getAllBrand().then((value) => categoryList.value = value.map((e) => e.brandName!).toList());
    }
    if (value == 'Fungsi') {
      APIService().getAllGroup().then((value) => categoryList.value = value.map((e) => e.groupName!).toList());
    }
    if (value == 'Status') {
      categoryList.value = ['Pending', 'Approve', 'Reject'];
    }
    // if (value == 'Semua Barang') {
    //   APIService().getAllTag(1).then((value) {
    //     controller.data.assignAll(value.data!);
    //   }, onError: (e) {});
    // }
    // if (value == 'Kategori') {
    //   APIService().getAllCategory().then((value) => categoryList.value = value.map((e) => e.categoryName!).toList());
    // }
    // if (value == 'Merk') {
    //   APIService().getAllBrand().then((value) => categoryList.value = value.map((e) => e.brandName!).toList());
    // }
    // if (value == 'Fungsi') {
    //   APIService().getAllGroup().then((value) => categoryList.value = value.map((e) => e.groupName!).toList());
    // }
    // if (value == 'Status') {
    //   categoryList.value = ['Pending', 'Approve', 'Reject'];
    // }
  }

  void getDataFromSearch() {
    APIService().getAllTagWithFilter(1, name: itemSearchControllerFilter.text).then((value) {
      controller.itemDataSource.value = ItemDataSource(value.data!);
    }, onError: (e) {});
  }

  void getData(value) {
    if (filter.value == 'Kategori') {
      APIService().getAllTagWithFilter(1, category: value).then((value) {
        controller.itemDataSource.value = ItemDataSource(value.data!);
      }, onError: (e) {});
    }
    if (filter.value == 'Merk') {
      APIService().getAllTagWithFilter(1, brand: value).then((value) {
        controller.itemDataSource.value = ItemDataSource(value.data!);
      }, onError: (e) {});
    }
    if (filter.value == 'Fungsi') {
      APIService().getAllTagWithFilter(1, group: value).then((value) {
        controller.itemDataSource.value = ItemDataSource(value.data!);
      }, onError: (e) {});
    }
    if (filter.value == 'Status') {
      APIService().getAllTagWithFilter(1,name: itemSearchControllerFilter.text, status: value).then((value) {
        controller.itemDataSource.value = ItemDataSource(value.data!);
      }, onError: (e) {});
    }
  }

  // void getData(value) {
  //   if (filter.value == 'Kategori') {
  //     APIService().getAllTagWithFilter(1, category: value).then((value) {
  //       controller.data.assignAll(value.data!);
  //     }, onError: (e) {});
  //   }
  //   if (filter.value == 'Merk') {
  //     APIService().getAllTagWithFilter(1, brand: value).then((value) {
  //       controller.data.assignAll(value.data!);
  //     }, onError: (e) {});
  //   }
  //   if (filter.value == 'Fungsi') {
  //     APIService().getAllTagWithFilter(1, group: value).then((value) {
  //       controller.data.assignAll(value.data!);
  //     }, onError: (e) {});
  //   }
  //   if (filter.value == 'Status') {
  //     APIService().getAllTagWithFilter(1, status: value).then((value) {
  //       controller.data.assignAll(value.data!);
  //     }, onError: (e) {});
  //   }
  // }

  @override
  void onInit() {
    ever(filter, (value) => setFilter(value as String));
    ever(subFilter, (value) => getData(value as String));
    itemSearchControllerFilter = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    itemSearchControllerFilter.dispose();
    super.onClose();
  }
}
