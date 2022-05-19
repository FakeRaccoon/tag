import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag/Controllers/user-controller.dart';
import 'package:tag/Models/all-data-model.dart';
import 'package:tag/Models/brand-model.dart';
import 'package:tag/Models/data-model.dart';
import 'package:tag/Models/group-model.dart';
import 'package:tag/Models/item-model.dart';
import 'package:tag/Models/user-model.dart';

import 'Models/categories-model.dart';
import 'Models/log-model.dart';
import 'Models/warehouse-model.dart';

const String cloud = "http://cloudamt.ddns.net:9999/api";
const String local = "http://192.168.0.251:8000/api";

BaseOptions cloudOptions = BaseOptions(
  baseUrl: cloud,
  connectTimeout: 5000,
  receiveTimeout: 5000,
  sendTimeout: 5000,
);
BaseOptions localOptions = BaseOptions(
  baseUrl: local,
  connectTimeout: 5000,
  receiveTimeout: 5000,
  sendTimeout: 5000,
);

Dio dio = Dio(cloudOptions);

class APIService {
  final UserController userController = Get.find();
  final box = GetStorage();

  Future<UserDetail?> getUserDetail() async {
    try {
      final response = await dio.get(
        '/users/detail',
      );
      return userFromJson(jsonEncode(response.data['data']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future getTag(String code) async {
    try {
      final response = await dio.get(
        '/tags/$code',
      );
      return tagModelFromJson(jsonEncode(response.data['data']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<AllDataModel> getAllTag(int page) async {
    try {
      final response = await dio.get(
        '/tags?page=$page',
      );
      return allDataModelFromJson(jsonEncode(response.data));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<AllDataModel> getAllTagWithFilter(
    int page, {
    String? name,
    String? category,
    String? brand,
    String? group,
    String? status,
  }) async {
    int? statusInt;
    switch (status) {
      case 'Pending':
        statusInt = 1;
        break;
      case 'Approve':
        statusInt = 2;
        break;
      case 'Reject':
        statusInt = 3;
        break;
    }
    try {
      var response = await dio.get(
        '/tags',
        queryParameters: {
          'name': name,
          'status': statusInt,
          'category': category,
          'brand': brand,
          'group': group,
        },
      );
      return allDataModelFromJson(jsonEncode(response.data));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<List<CategoriesModel>> getAllCategory() async {
    try {
      var response = await dio.get(
        '/categories',
      );
      return categoriesModelFromJson(jsonEncode(response.data['data']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<List<BrandModel>> getAllBrand() async {
    try {
      var response = await dio.get(
        '/brands',
      );
      return brandModelFromJson(jsonEncode(response.data['data']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<List<GroupModel>> getAllGroup() async {
    try {
      var response = await dio.get('/groups');
      return groupModelFromJson(jsonEncode(response.data['data']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<AllDataModel> getDataByDate(int page, String fromDate, String toDate) async {
    try {
      var response = await dio.get(
        '/tags?page=$page',
        queryParameters: {'from': fromDate, 'to': toDate},
      );
      return allDataModelFromJson(jsonEncode(response.data));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<ItemModel> getItem(item) async {
    try {
      var response = await dio.get(
        '/items',
        queryParameters: {
          'name': item,
        },
      );
      return itemModelFromJson(jsonEncode(response.data));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future editTag(String code, id, status, type, urgency, description, int location) async {
    try {
      var response = await dio.put(
        '/tags/$code',
        data: {
          'item_id': id,
          'status': status,
          'type': type,
          'urgency': urgency,
          // 'item_name': name,
          'location': location,
          'description': description,
        },
      );
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print(e.response!.data);
      throw e.message;
    }
  }

  Future createTag(String code, description, int id, location) async {
    try {
      var response = await dio.post(
        '/tags',
        data: {
          'item_code': code,
          'item_id': id,
          'status': 1,
          'type': 0,
          'urgency': 0,
          // 'item_name': name,
          'location': location,
          'description': description,
        },
      );
      return response.data;
    } on DioError catch (e) {
      print(e.response!.data);
      throw e.message;
    }
  }

  Future createWarehouse(name, location) async {
    try {
      var response = await dio.post('/warehouses', data: {
        'warehouse_name': name,
        'warehouse_location': location,
      });
      return response.data;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future createPart(id, name) async {
    try {
      var response = await dio.post('/parts', data: {
        'tag_id': id,
        'user_id': userController.user.value.id,
        'part_name': name,
      });
      return response.data;
    } on DioError catch (e) {
      print(e.response!.data);
      throw e.message;
    }
  }

  Future createDiagnosis(id, name) async {
    try {
      var response = await dio.post('/diagnoses', data: {
        'tag_id': id,
        'user_id': userController.user.value.id,
        'diagnosis': name,
      });
      return response.data;
    } on DioError catch (e) {
      print(e.response!.data);
      throw e.message;
    }
  }

  Future createTreatment(id, name) async {
    try {
      var response = await dio.post('/treatments', data: {
        'tag_id': id,
        'user_id': userController.user.value.id,
        'treatment': name,
      });
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print(e.response!.data);
      throw e.message;
    }
  }

  Future createImage(id, name) async {
    try {
      var response = await dio.post('/images', data: {
        'tag_id': id,
        'url': name,
      });
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print(e.response!.data);
      throw e.message;
    }
  }

  Future createLog(String log, int type) async {
    try {
      var response = await dio.post('/logs', data: {
        'log': log,
        'type': type,
      });
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print(e.response!.data);
      throw e.message;
    }
  }

  Future<List<WarehouseModel>> getWarehouse() async {
    try {
      var response = await dio.get('/warehouses');
      return warehouseModelFromJson(jsonEncode(response.data['data']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<LogModel> getLog() async {
    try {
      final response = await dio.get(
        '/logs',
      );
      return logModelFromJson(jsonEncode(response.data));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future register(name, String username, String password, role) async {
    try {
      Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
      await dio.post('/users/register', data: {
        'name': name,
        'role': role,
        'username': username.trim(),
        'password': password.trim(),
      });
      Get.back();
      Get.back();
      Get.defaultDialog(title: 'Success', middleText: 'Berhasil buat user baru');
    } on DioError catch (e) {
      Get.back();
      Get.back();
      Get.defaultDialog(title: 'Gagal', middleText: 'Gagal buat user baru, error ${e.response!.statusMessage}');
    }
  }

  Future login(String username, String password) async {
    try {
      var response = await dio.post(
        '/users/login',
        data: {
          'username': username.trim(),
          'password': password.trim(),
        },
      );
      return response.data;
    } on DioError catch (e) {
      if (e.response!.statusCode == 401) {
        Get.defaultDialog(title: 'Gagal Login', middleText: 'Cek email dan password');
      } else {
        Get.defaultDialog(title: 'Gagal Login', middleText: 'Cek koneksi');
      }
    }
  }

  Future logout() async {
    try {
      final response = await dio.post('/users/logout');
      return response.data;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
