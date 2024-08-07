import 'dart:async';
import 'dart:convert';

import 'package:encrypt/encrypt.dart' as EncryptSys;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../apis/base_api.dart';
import '../utils/data_store.dart';
import 'app_color.dart';
import 'app_menu.dart';
import 'app_provider.dart';
import 'local_value_key.dart';
import 'models/account.dart';
import 'models/config.dart';

const bool app_encryption = false;
final EncryptSys.IV app_iv = EncryptSys.IV.fromUtf8('DyPas7CdtRd1mby4');
final EncryptSys.Key app_key = EncryptSys.Key.fromUtf8('066emyhZzpvKjKQP3PZM3SP1IdEAZoMh');

final DataStore app_dataStore = DataStore(key: app_key, iv: app_iv, isEncryption: app_encryption);

/// Save menu config to local storage
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

/// Get language from local storage
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

/// Set language to local storage
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

/// Get color from local storage

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
/*AppColors getAppColorsFromStore() {
  try {
    final String? data = app_dataStore.loadFromLocal("cfg_colors");
    AppColors? appColors = getAppColors(data!);
    return  appColors ?? default_app_colors;
  } catch (e) {
    return default_app_colors;
  }
}*/

/// Set color to local storage
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

/// Get user from local storage
Account? getUserFromStore() {
  try {
    final String? data = app_dataStore.loadFromLocal("user");
    if(data == null) {
      return null;
    }
    Map<String, dynamic> map = jsonDecode(data);
    return Account.fromJson(map);
  } catch (e) {
    print(e);
    return null;
  }
}

/// Set user to local storage
Future<bool> setUserToStore(Account user) async {
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

/// Get user from local storage
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




class AppConfigNotifier extends Notifier<AppConfig> {
  @override
  AppConfig build() {

    final appColors = ref.watch(getAppColor);
    // Get menu from configMenuProvider
    List<MenuItem> appMenu = ref.read(configMenuProvider);

    String? appValue = getAppLangFromStore();
    if(appValue == null) {
      List<String> tmps = getListCodeValueKey();
      if(tmps.isNotEmpty) {
        appValue = tmps[0];
      }
    }


    return AppConfig(cfgMenu: appMenu, cfgValueKey: appValue!, cfgColors: appColors);
  }

  void updateMenu(List<MenuItem> items) {
    state = AppConfig(cfgMenu: items, cfgValueKey: state.cfgValueKey, cfgColors: state.cfgColors);
    // state.cfgMenu = items;
  }

  void updateColors(AppColors item) {
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

final Api app_api = Api();

class UserController extends AutoDisposeAsyncNotifier<Account?> {
  UserController() : super();

  @override
  FutureOr<Account?> build() {
    // TODO: implement build
    Account? user = getUserFromStore();
    state = AsyncData(user);
    return user;
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      Account? user = await app_api.login(username, password);
      if(user != null) {
        await setUserToStore(user);
      }
      return user;
    });
  }

  Future<void> renewToken() async {
    Account? tmpUser = state.value;
    if(tmpUser != null && tmpUser.token.isNotEmpty) {
      state = const AsyncLoading();
      state = await AsyncValue.guard(() async {
        Account? user = await app_api.renewToken(tmpUser.token);
        if(user != null) {
          await setUserToStore(user);
        }
        return user;
      });
    }
  }
}

final userControllerProvider = AsyncNotifierProvider.autoDispose<UserController,Account?>(() {
  return UserController();
});

/*Future<void> initAppConfig() async {
  setAppConfigMenuToStore(defaultAppMenu);
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

  // List<String> listCodeColors = getListCodeAppColors();
  // String? configColor = getAppColorsFromStore();
  // if(configColor == null || listCodeColors.contains(configColor) == false) {
  //   configColor = listCodeColors[0];
  //   await setAppColorsToStore(configColor);
  // }

  List<String> listCodeValues = getListCodeValueKey();
  String? configLang = getAppLangFromStore();
  if(configLang == null || listCodeValues.contains(configLang) == false) {
    configLang = listCodeValues[0];
    await setAppLangToStore(configLang);
  }
}*/

Future<void> initAppConfigFromNetwork() async {
  //  get cfg menu
  List<MenuItem>? cfgMenu = [];
  cfgMenu = await app_api.getListConfigMenu();
  cfgMenu ??= defaultAppMenu;
  setAppConfigMenuToStore(cfgMenu);

  //  get cfg lang
  List<ItemLocalValueKey>? cfgLang = await app_api.getListConfiglang();
  if(cfgLang == null) {
    cfgLang = [];
    cfgLang.add(
      ItemLocalValueKey(
        code: "default",
        keys: default_app_local_value_key,
      )
    );
  }
  localValueKeys.clear();
  localValueKeys.addAll(cfgLang);

  List<ItemColors>? tmpColors = await app_api.getListConfigColor();
  if(tmpColors == null) {
    tmpColors = [];
    tmpColors.add(
      ItemColors(
        code: "lightDisplay",
        colors: default_app_colors,
      )
    );
  }
  localColors.clear();
  localColors.addAll(tmpColors);

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