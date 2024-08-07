
import 'dart:convert';

import 'package:dio/dio.dart';

import '../data/app_color.dart';
import '../data/app_menu.dart';
import '../data/local_value_key.dart';
import 'base_api.dart';

mixin ConfigApi on BaseApi {
  static const String pathCfgColor = "/Config/color";
  static const String patchCfgLang  = "/Config/lang";
  static const String patchCfgMenu = "/Config/menu";

  Future<List<ItemColors>?> getListConfigColor() async {
    try {
      Map<String, dynamic> headers = <String, dynamic>{};
      headers['Content-Type'] = 'application/json';
      headers['accept'] = '*/*';

      Response response = await dio.get(pathCfgColor, options: Options(headers: headers));
      if (response.statusCode == 200) {
        List tmp = jsonDecode(response.data) as List;
        List<ItemColors> items = tmp.map((item) => ItemColors.fromJson(item)).toList();
        return items;
      } else {
        return null;
      }
    } catch(e) {
      return null;
    }
  }

  Future<List<ItemLocalValueKey>?> getListConfiglang() async {
    try {
      Map<String, dynamic> headers = <String, dynamic>{};
      headers['Content-Type'] = 'application/json';
      headers['accept'] = '*/*';

      Response response = await dio.get(patchCfgLang, options: Options(headers: headers));
      if (response.statusCode == 200) {
        List tmp = jsonDecode(response.data) as List;
        List<ItemLocalValueKey> items = tmp.map((item) => ItemLocalValueKey.fromJson(item)).toList();
        return items;
      } else {
        return null;
      }
    } catch(e) {
      return null;
    }
  }

  Future<List<MenuItem>?> getListConfigMenu() async {
    try {
      Map<String, dynamic> headers = <String, dynamic>{};
      headers['Content-Type'] = 'application/json';
      headers['accept'] = '*/*';

      Response response = await dio.get(patchCfgMenu);
      if (response.statusCode == 200) {
        List tmp = response.data as List;
        List<MenuItem> items = tmp.map((item) => MenuItem.fromJson(item)).toList();
        return items;
      } else {
        return null;
      }
    } catch(e) {
      return null;
    }
  }
}