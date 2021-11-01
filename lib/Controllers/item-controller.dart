import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag/Controllers/user-controller.dart';
import 'package:tag/Grid/data-grid-source.dart';
import 'package:tag/Models/all-data-model.dart';
import 'package:tag/api-service.dart';

class ItemController extends GetxController {
  var page = 1.obs;
  var allData = AllDataModel().obs;
  var data = [Datum()].obs;

  final itemDataSource = ItemDataSource([]).obs;

  var hasMore = false.obs;

  var safety = 0.obs;

  late ScrollController scrollController;

  void getInitialData() {
    APIService().getAllTag(1).then((value) {
      data.value = value.data!;
    }, onError: (e) {});
  }

  void getData() {
    APIService().getAllTag(page.value + 1).then((value) {
      print(value.data);
      if (value.data!.isNotEmpty) {
        data.addAll(value.data!);
        page.value++;
        hasMore.value = true;
      } else {
        hasMore.value = false;
      }
    }, onError: (e) {});
  }

  @override
  void onInit() {
    super.onInit();
    debounce(safety, (_) => getData());
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        safety.value++;
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    debounce(safety, (_) => getData());
    scrollController.dispose();
  }
}
