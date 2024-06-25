import 'dart:convert';

import 'package:dio/dio.dart';

import '../data/app_color.dart';
import '../data/app_menu.dart';
import '../data/local_value_key.dart';
import 'base_api.dart';

mixin ConfigApi on BaseApi {
  static const String PATH_CFG_COLOR = "/Config/color";
  static const String PATH_CFG_LANG = "/Config/lang";
  static const String PATH_CFG_MENU = "/Config/menu";

  Future<List<ItemColors>?> getListConfigColor() async {
    try {
      Map<String, dynamic> headers = <String, dynamic>{};
      headers['Content-Type'] = 'application/json';
      headers['accept'] = '*/*';

      Response response = await dio.get(PATH_CFG_COLOR, options: Options(headers: headers));
      if (response.statusCode == 200) {
        logger.i(" API_LIST_CONFIG_COLOR : ${response.toString()} ");
        List tmp = response.data as List;
        List<ItemColors> items = tmp.map((item) => ItemColors.fromJson(item)).toList();
        return items;
      } else {
        return null;
      }
    } catch(e) {
      logger.e(" * API_LIST_CONFIG_COLOR : ${e.toString()} ");
      return null;
    }
  }

  Future<List<ItemLocalValueKey>?> getListConfiglang() async {
    try {
      Map<String, dynamic> headers = <String, dynamic>{};
      headers['Content-Type'] = 'application/json';
      headers['accept'] = '*/*';

      Response response = await dio.get(PATH_CFG_LANG, options: Options(headers: headers));
      if (response.statusCode == 200) {
        logger.i(" API_LIST_CONFIG_LANG : ${response.toString()} ");
        List tmp = response.data as List;
        List<ItemLocalValueKey> items = tmp.map((item) => ItemLocalValueKey.fromJson(item)).toList();
        return items;
      } else {
        return null;
      }
    } catch(e) {
      logger.e(" * API_LIST_CONFIG_LANG : ${e.toString()} ");
      return null;
    }
  }

  Future<List<MenuItem>?> getListConfigMenu() async {
    try {
      Map<String, dynamic> headers = <String, dynamic>{};
      headers['Content-Type'] = 'application/json';
      headers['accept'] = '*/*';

      Response response = await dio.get(PATH_CFG_MENU, options: Options(headers: headers));
      if (response.statusCode == 200) {
        logger.i(" API_LIST_CONFIG_MENU : ${response.toString()} ");
        List tmp = response.data as List;
        List<MenuItem> items = tmp.map((item) => MenuItem.fromJson(item)).toList();
        return items;
      } else {
        return null;
      }
    } catch(e) {
      logger.e(" * API_LIST_CONFIG_MENU : ${e.toString()} ");
      return null;
    }
  }
}