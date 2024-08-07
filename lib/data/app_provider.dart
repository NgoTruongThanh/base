import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_color.dart';
import 'app_config.dart';
import 'app_menu.dart';
import 'local_value_key.dart';

final configMenuProvider = StateProvider<List<MenuItem>>((ref) {
  try {
    final String? data = app_dataStore.loadFromLocal("cfg_menu");
    if (data == null) {
      return defaultAppMenu;
    }
    final List<dynamic> tmp = jsonDecode(data);
    final List<MenuItem> items = tmp.map((item) => MenuItem.fromJson(item)).toList();

    return items;
  } catch (e) {
    print(e);
    return defaultAppMenu;
  }
});

final configLanguageProvider = StateProvider<LocalValueKey>((ref) {
  String? configLang = getAppLangFromStore();
  LocalValueKey appLang;
  if (configLang != null) {
    appLang = getValueKey(configLang) ?? default_app_local_value_key;
  } else {
    appLang = default_app_local_value_key;
  }
  return appLang;
});


final getTextLanguageProvider = StateProvider.autoDispose.family<String,String>((ref,text) {
  final appLang = ref.watch(configLanguageProvider).toJson();
  MapEntry? entry = appLang.entries.where((s) => s.key.compareTo(text) == 0).firstOrNull;
  if (entry != null) {
    return  entry.value.toString();
  } else {
    return '';
  }
});

final getAppColor = StateProvider<AppColors>((ref) {
  String? configColor = getAppColorsFromStore();
  if(configColor !=null)
    {
      ItemColors? item = localColors.where((s) {
        if(s.code.compareTo(configColor) == 0)
          {
            themeTitle = s.code;
            return true;
          }
        return false;
      }).firstOrNull;
      AppColors? appColors = item?.colors;
      return appColors ?? default_app_colors;
    }
  else{
    return default_app_colors;
  }

});

String themeTitle ='';

