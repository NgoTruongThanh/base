import 'package:basestvgui/apis/base_api.dart';
import 'package:dio/dio.dart';

import '../data/models/account.dart';

mixin AccountApi on BaseApi {
  static const String PATH_LOGIN = "/api/login";
  static const String PATH_RENEWTOKEN = "/api/renewtoken";

  Future<Account?> login(String username, String password) async {
    cancelPreviousRequest();
    try {
      Map<String, dynamic> headers = <String, dynamic>{};
      headers['Content-Type'] = 'application/json';
      headers['accept'] = '*/*';
      Object body = {'username':username, 'password':password};

      Response response = await dio.post(PATH_LOGIN, options: Options(headers: headers), data: body,cancelToken: cancelToken);
      if (response.statusCode == 200) {
        logger.i(" API_USER_LOGIN : ${response.data} ");
        Account account = Account.fromJson(response.data);
        if(account.token.isEmpty) {
          return account;
        } else {
          return account;
        }
      } else {
        return null;
      }
    } catch(e) {
      logger.e(" * API_USER_LOGIN : ${e.toString()} ");
      return null;
    }
  }

  Future<Account?> renewToken(String token) async {
    try {
      Map<String, dynamic> headers = <String, dynamic>{};
      headers['Content-Type'] = 'application/json';
      headers['accept'] = '*/*';
      headers['Authorization'] = "Bearer $token";
      Response response = await dio.put(PATH_RENEWTOKEN, options: Options(headers: headers), data: null);
      if (response.statusCode == 200) {
        logger.i(" API_USER_RENEWTOKEN : ${response.data} ");
        Account account = Account.fromJson(response.data);
        if(account.token.isEmpty) {
          return account;
        } else {
          return account;
        }
      } else {
        return null;
      }
    } catch(e) {
      logger.e(" * API_USER_RENEWTOKEN : ${e.toString()} ");
      return null;
    }
  }
}