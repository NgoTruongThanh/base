import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import '../data/app_config.dart';
import '../routers/router.dart';


class CustomInterceptors extends Interceptor {

  CustomInterceptors();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // print('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // print(
    //     'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    // print(
    //     'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    if (err.response?.statusCode == 401 && err.requestOptions.method == 'GET') {
      clearUserStore().then((value) {
        Future.delayed(const Duration(milliseconds: 100), () {
          final context = rootNavigatorKey.currentContext;

          if (context != null) {
            context.goNamed('login');
          }
        });
      });
      
    }
    super.onError(err, handler);
  }
}
