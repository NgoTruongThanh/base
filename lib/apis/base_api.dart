import 'package:basestvgui/apis/account_api.dart';
import 'package:dio/dio.dart';

import 'config_api.dart';
import 'custom_interceptor.dart';

class BaseApi {
  // final logger = Logger(
  //   filter: null, // Use the default LogFilter (-> only log in debug mode)
  //   printer: PrettyPrinter(
  //     methodCount: 2, // Number of method calls to be displayed
  //     errorMethodCount: 8, // Number of method calls if stacktrace is provided
  //     lineLength: 120, // Width of the output
  //     colors: true, // Colorful log messages
  //     printEmojis: true, // Print an emoji for each log message
  //     printTime: false // Should each log print contain a timestamp
  //   ), // Use the PrettyPrinter to format and print log
  //   output: null, // Use the default LogOutput (-> send everything to console)
  // );

  String baseUrl = "http://office.stvg.vn:59109";
  late Dio dio;
  bool enable = false;
  CancelToken? cancelToken;
  BaseApi() {
    dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {"Access-Control-Allow-Origin": "*"}));
    dio.interceptors.add(CustomInterceptors());
  }
  void cancelPreviousRequest() {
    if (cancelToken != null && !cancelToken!.isCancelled) {
      cancelToken!.cancel("Canceled by new request");
    }
    cancelToken = CancelToken();
  }
}

class Api extends BaseApi with AccountApi, ConfigApi {
  Api();
}
