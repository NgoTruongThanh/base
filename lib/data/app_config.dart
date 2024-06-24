import 'dart:async';
import 'dart:convert';

import 'package:encrypt/encrypt.dart' as EncryptSys;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../apis/base_api.dart';
import '../utils/data_store.dart';
import 'app_color.dart';
import 'app_menu.dart';
import 'local_value_key.dart';
import 'models/user.dart';

const bool app_encryption = true;
final EncryptSys.IV app_iv = EncryptSys.IV.fromUtf8('DyPas7CdtRd1mby4');
final EncryptSys.Key app_key = EncryptSys.Key.fromUtf8('066emyhZzpvKjKQP3PZM3SP1IdEAZoMh');

final DataStore app_dataStore = DataStore(key: app_key, iv: app_iv, isEncryption: app_encryption);

List<MenuItem>? getAppConfigMenuFromStore() {
  try {
    final String? data = app_dataStore.loadFromLocal("cfg_menu");
    if(data == null) {
      return null;
    }
    final List<dynamic> tmp = jsonDecode(data);
    final List<MenuItem> items = tmp.map((item) => MenuItem.fromJson(item)).toList();
    return items;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<bool> setAppConfigMenuToStore(List<MenuItem> items) async {
  try {
    String data = jsonEncode(items);
    return app_dataStore.saveToLocal("cfg_menu", data).then((value) {
      return value;
    });
  } catch (e) {
    print(e);
    return false;
  }
}

String? getAppLangFromStore() {
  try {
    final String? data = app_dataStore.loadFromLocal("cfg_lang");
    if(data == null) {
      return null;
    }
    return data;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<bool> setAppLangToStore(String item) async {
  try {
    return app_dataStore.saveToLocal("cfg_lang", item).then((value) {
      return value;
    });
  } catch (e) {
    print(e);
    return false;
  }
}

String? getAppColorsFromStore() {
  try {
    final String? data = app_dataStore.loadFromLocal("cfg_colors");
    if(data == null) {
      return null;
    }
    return data;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<bool> setAppColorsToStore(String item) async {
  try {
    return app_dataStore.saveToLocal("cfg_colors", item).then((value) {
      return value;
    });
  } catch (e) {
    print(e);
    return false;
  }
}

User? getUserFromStore() {
  try {
    final String? data = app_dataStore.loadFromLocal("user");
    if(data == null) {
      return null;
    }
    Map<String, dynamic> map = jsonDecode(data);
    return User.fromJson(map);
  } catch (e) {
    print(e);
    return null;
  }
}

Future<bool> setUserToStore(User user) async {
  try {
    String data = jsonEncode(user);
    return app_dataStore.saveToLocal("user", data).then((value) {
      return value;
    });
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> clearUserStore() async {
  try {
    return app_dataStore.deleteLocal("user").then((value) {
      return value;
    });
  } catch (e) {
    print(e);
    return false;
  }
}

class AppConfig {
  List<MenuItem> cfgMenu = [];
  String cfgValueKey;
  String cfgColors;

  AppConfig({required this.cfgMenu, required this.cfgValueKey, required this.cfgColors});

  void setConfigMenu(List<MenuItem> items) {
    cfgMenu = items;
  }

  List<MenuItem> getConfigMenu() {
    return cfgMenu;
  }

  void setConfigValueKey(String item) {
    cfgValueKey = item;
  }

  String getConfigValueKey() {
    return cfgValueKey;
  }

  void setConfigColors(String item) {
    cfgColors = item;
  }

  String getConfigColors() {
    return cfgColors;
  }
}

class AppConfigNotifier extends Notifier<AppConfig> {
  @override
  AppConfig build() {
    // TODO: implement build
    List<MenuItem>? app_menu = getAppConfigMenuFromStore();
    app_menu ??= default_app_menu;

    String? app_value = getAppLangFromStore();
    if(app_value == null) {
      List<String> tmps = getListCodeValueKey();
      if(tmps.isNotEmpty) {
        app_value = tmps[0];
      }
    }

    String? app_colors = getAppColorsFromStore();
    if(app_colors == null) {
      List<String> tmps = getListCodeAppColors();
      if(tmps.isNotEmpty) {
        app_colors = tmps[0];
      }
    }
    return AppConfig(cfgMenu: app_menu!, cfgValueKey: app_value!, cfgColors: app_colors!);
  }

  void updateMenu(List<MenuItem> items) {
    state = AppConfig(cfgMenu: items, cfgValueKey: state.cfgValueKey, cfgColors: state.cfgColors);
    // state.cfgMenu = items;
  }

  void updateColors(String item) {
    state = AppConfig(cfgMenu: state.cfgMenu, cfgValueKey: state.cfgValueKey, cfgColors: item);
    //state.cfgColors = item;
  }

  void updateValueKey(String item) {
    state = AppConfig(cfgMenu: state.cfgMenu, cfgValueKey: item, cfgColors: state.cfgColors);
    //state.cfgValueKey = item;
  }

  // void update(List<MenuItem> cfg_menus, String cfg_key, String cfg_color) {
  //   state = AppConfig(cfgMenu: cfg_menus, cfgValueKey: cfg_key, cfgColors: cfg_key);
  // }
}

final appConfigProvider = NotifierProvider<AppConfigNotifier, AppConfig>(AppConfigNotifier.new);

final Api app_api = Api(base_url: "https://dev.smartlook.com.vn:59108");

class UserController extends AutoDisposeAsyncNotifier<User?> {
  UserController() : super();

  @override
  FutureOr<User?> build() {
    // TODO: implement build
    User? _user = getUserFromStore();
    state = AsyncData(_user);
    return _user;
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      User? user = await app_api?.login(username, password);
      if(user != null) {
        await setUserToStore(user);
      }
      return user;
    });
  }

  Future<void> renewToken() async {
    User? tmpUser = state.value;
    if(tmpUser != null && tmpUser.token != null && tmpUser.token!.isNotEmpty) {
      state = const AsyncLoading();
      state = await AsyncValue.guard(() async {
        User? user = await app_api?.renewToken(tmpUser.token!);
        if(user != null) {
          await setUserToStore(user);
        }
        return user;
      });
    }
  }
}

final userControllerProvider = AsyncNotifierProvider.autoDispose<UserController,User?>(() {
  return UserController();
});

Future<void> initAppConfig() async {
  setAppConfigMenuToStore(default_app_menu);
  localValueKeys.add(
    ItemLocalValueKey(
      code: "en",
      keys: LocalValueKey(
        viLang: 'Vietnamese',
        enLang: 'English',
        login: 'Login',
        logout: 'Logout',
        username: 'Username',
        password: 'Password',
        btLogin: 'Sign in',
        lightDisplay: 'Light mode',
        darkDisplay: 'Dark mode',
        home: 'Home',
        tab1: 'Tab 1',
        tab2: 'Tab 2',
        item_1_1: 'Item 1 1',
        item_1_2: 'Item 1 2',
        item_1_3: 'Item 1 3',
        item_2_1: 'Item 2 1',
        item_2_2: 'Item 2 2',
        item_2_3: 'Item 2 3',
        item_2_4: 'Item 2 4',
        msg_title_login_fail : 'Login failed',
        msg_description_login_fail : 'Try again',
        msg_title_login_success : 'Login Successful',
        msg_description_login_success : 'Welcome '
      )
    )
  );
  localValueKeys.add(
    ItemLocalValueKey(
      code: "vi",
      keys: LocalValueKey(
        viLang: 'Tiếng Việt',
        enLang: 'Tiếng Anh',
        login:  'Đăng nhập',
        logout: 'Đăng xuất',
        username: 'Tên đăng nhập',
        password: 'Mật khẩu',
        btLogin: 'Đăng nhập',
        lightDisplay: 'Chế độ sáng',
        darkDisplay: 'Chế độ tối',
        home: 'Trang chủ',
        tab1: 'Mục 1',
        tab2: 'Mục 2',
        item_1_1: 'Chuyên mục 1 1',
        item_1_2: 'Chuyên mục 1 2',
        item_1_3: 'Chuyên mục 1 3',
        item_2_1: 'Chuyên mục 2 1',
        item_2_2: 'Chuyên mục 2 2',
        item_2_3: 'Chuyên mục 2 3',
        item_2_4: 'Chuyên mục 2 4',
        msg_title_login_fail : 'Đăng nhập thất bại',
        msg_description_login_fail : 'Hãy thử lại',
        msg_title_login_success : 'Đăng nhập thành công',
        msg_description_login_success : 'Xin chào '
      )
    )
  );

  localColors.add(
    ItemColors(
      code: "lightDisplay",
      colors: default_app_colors,
    )
  );

  localColors.add(
    ItemColors(
      code: "darkDisplay",
      colors: AppColors (
        mainColor: const Color(0xff282828),
        backgroundColor: const Color(0xff000000),
        selectedColor: const Color(0xff505860),
        selectedColor2: const Color(0xff66707A),
        tableBorder: Colors.white,
        alternateCellBg: Colors.grey.shade600,
        textColor: Colors.white,
        buttonColor: const Color(0xff501820),
        searchColor: const Color(0xff131214),
        activeTextColor:  Colors.black,
        btnTextColor: const Color(0xff404048),
        chartBgColor: const Color(0xff131214),
        lineChart: Colors.white,
        iconBgColor: Colors.grey,
        accountTextColor: Colors.white,
        accountColor: Colors.white,
        notificationExpandBgColor: Colors.grey.shade800,
        notificationWarning: Colors.amber.withOpacity(0.25),
      ),
    )
  );

  String data = jsonEncode(localValueKeys.map((v) => v.toJson()).toList());
  await app_dataStore.saveToLocal("store_values", data);

  data = jsonEncode(localColors.map((v) => v.toJson()).toList());
  await app_dataStore.saveToLocal("store_colors", data);

  List<String> listCodeColors = getListCodeAppColors();
  String? configColor = getAppColorsFromStore();
  if(configColor == null || listCodeColors.contains(configColor) == false) {
    configColor = listCodeColors[0];
    await setAppColorsToStore(configColor);
  }

  List<String> listCodeValues = getListCodeValueKey();
  String? configLang = getAppLangFromStore();
  if(configLang == null || listCodeValues.contains(configLang) == false) {
    configLang = listCodeValues[0];
    await setAppLangToStore(configLang);
  }
}