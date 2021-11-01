import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tag/Controllers/initial-controller.dart';
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

class APIService {
  final UserController userController = Get.find();
  late SharedPreferences sharedPreferences;
  static InitialController authController = Get.find();
  static final box = GetStorage();
  static BaseOptions options = BaseOptions(
    baseUrl: '${authController.url}/api',
    headers: {'Authorization': 'Bearer ${box.read('token')}'},
    connectTimeout: 5000,
    receiveTimeout: 5000,
    sendTimeout: 5000,
  );

  Dio dio = Dio(options);

  Future<UserDetail?> getUserDetail() async {
    try {
      final token = box.read('token');
      final response = await dio.get(
        '${authController.url}/api/users/detail',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return userFromJson(jsonEncode(response.data['data']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future getTag(String code) async {
    try {
      final token = box.read('token');
      final response = await dio.get(
        '${authController.url}/api/tags/$code',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return tagModelFromJson(jsonEncode(response.data['data']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<AllDataModel> getAllTag(int page) async {
    try {
      final token = box.read('token');
      final response = await dio.get(
        '${authController.url}/api/tags?page=$page',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
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
    var token = box.read('token');
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
        '${authController.url}/api/tags',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
    var token = box.read('token');
    try {
      var response = await dio.get(
        '${authController.url}/api/categories',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return categoriesModelFromJson(jsonEncode(response.data['data']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<List<BrandModel>> getAllBrand() async {
    var token = box.read('token');
    try {
      var response = await dio.get(
        '${authController.url}/api/brands',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return brandModelFromJson(jsonEncode(response.data['data']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<List<GroupModel>> getAllGroup() async {
    var token = box.read('token');
    try {
      var response = await dio.get(
        '${authController.url}/api/groups',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return groupModelFromJson(jsonEncode(response.data['data']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<AllDataModel> getDataByDate(int page, String fromDate, String toDate) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = box.read('token');
    try {
      var response = await dio.get(
        '${authController.url}/api/tags?page=$page',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {'from': fromDate, 'to': toDate},
      );
      return allDataModelFromJson(jsonEncode(response.data));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<ItemModel> getItem(item) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = box.read('token');
    try {
      var response = await dio.get(
        '${authController.url}/api/items',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
    var token = box.read('token');
    try {
      var response = await dio.put(
        '${authController.url}/api/tags/$code',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
    var token = box.read('token');
    try {
      var response = await dio.post(
        '${authController.url}/api/tags',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
    sharedPreferences = await SharedPreferences.getInstance();
    var token = box.read('token');
    try {
      var response = await dio.post('${authController.url}/api/warehouses',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
            'warehouse_name': name,
            'warehouse_location': location,
          });
      return response.data;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future createPart(id, name) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = box.read('token');
    try {
      var response = await dio.post('${authController.url}/api/parts',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
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
    sharedPreferences = await SharedPreferences.getInstance();
    var token = box.read('token');
    try {
      var response = await dio.post('${authController.url}/api/diagnoses',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
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
    sharedPreferences = await SharedPreferences.getInstance();
    var token = box.read('token');
    try {
      var response = await dio.post('${authController.url}/api/treatments',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
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
    sharedPreferences = await SharedPreferences.getInstance();
    var token = box.read('token');
    try {
      var response = await dio.post('${authController.url}/api/images',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
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
    sharedPreferences = await SharedPreferences.getInstance();
    var token = box.read('token');
    try {
      var response = await dio
          .post('${authController.url}/api/logs', options: Options(headers: {'Authorization': 'Bearer $token'}), data: {
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
    sharedPreferences = await SharedPreferences.getInstance();
    var token = box.read('token');
    try {
      var response = await dio.get('${authController.url}/api/warehouses',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return warehouseModelFromJson(jsonEncode(response.data['data']));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<LogModel> getLog() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = box.read('token');
    try {
      final response = await dio.get(
        '${authController.url}/api/logs',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return logModelFromJson(jsonEncode(response.data));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future register(name, String username, String password, role) async {
    try {
      Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
      await dio.post('${authController.url}/api/users/register', data: {
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
        '${authController.url}/api/users/login',
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
    sharedPreferences = await SharedPreferences.getInstance();
    final token = box.read('token');
    try {
      final response = await dio.post('${authController.url}/api/users/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response.data;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
