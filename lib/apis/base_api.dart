import 'package:basestvgui/apis/user_api.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class BaseApi {
  final logger = Logger(
    filter: null, // Use the default LogFilter (-> only log in debug mode)
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
    ), // Use the PrettyPrinter to format and print log
    output: null, // Use the default LogOutput (-> send everything to console)
  );

  String base_url = "";
  late Dio dio;
  bool enable = false;
  BaseApi({
    required this.base_url
  }) {
    dio = Dio(BaseOptions(baseUrl: base_url, headers: {"Access-Control-Allow-Origin": "*"}));
  }
}

class Api extends BaseApi with UserApi {
  Api({required super.base_url});
}
