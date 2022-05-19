import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

final box = GetStorage();

final customInterceptor = InterceptorsWrapper(
  onRequest: (request, handler) async {
    final token = await box.read('token');
    if (token != null) {
      request.headers = {
        "Authorization": "Bearer $token",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Method": "*",
        "Access-Control-Allow-Headers": "*",
      };
    }
    return handler.next(request);
  },
  onResponse: (response, handler) {
    return handler.next(response);
  },
  onError: (DioError e, handler) {
    return handler.next(e);
  },
);
