class LocalValueKey {
  String viLang = 'Vietnamese';
  String enLang = 'English';
  String login = "Login";
  String logout = 'Logout';
  String username = "Username";
  String password = "Password";
  String btLogin = "Sign in";
  String lightDisplay = 'Light';
  String darkDisplay = 'Dark';
  String home = 'Home';
  String tab1 = 'Tab 1';
  String tab2 = 'Tab 2';
  String item_1_1 = 'Item 1 1';
  String item_1_2 = 'Item 1 2';
  String item_1_3 = 'Item 1 3';
  String item_2_1 = 'Item 2 1';
  String item_2_2 = 'Item 2 2';
  String item_2_3 = 'Item 2 3';
  String item_2_4 = 'Item 2 4';
  String msg_title_login_fail = "Login failed";
  String msg_title_login_success = "Login Successful";
  String msg_description_login_fail = "Try again";
  String msg_description_login_success = "Welcome ";

  LocalValueKey({
    required this.viLang,
    required this.enLang,
    required this.login,
    required this.logout,
    required this.username,
    required this.password,
    required this.btLogin,
    required this.lightDisplay,
    required this.darkDisplay,
    required this.home,
    required this.tab1,
    required this.tab2,
    required this.item_1_1,
    required this.item_1_2,
    required this.item_1_3,
    required this.item_2_1,
    required this.item_2_2,
    required this.item_2_3,
    required this.item_2_4,
    required this.msg_title_login_fail,
    required this.msg_description_login_fail,
    required this.msg_title_login_success,
    required this.msg_description_login_success,
  });

  LocalValueKey.fromJson(Map<String, dynamic> json) {
    viLang = json['viLang'];
    enLang = json['enLang'];
    login = json['login'];
    logout = json['logout'];
    username = json['username'];
    password = json['password'];
    btLogin = json["btLogin"];
    lightDisplay = json['lightDisplay'];
    darkDisplay = json['darkDisplay'];
    home = json['home'];
    tab1 = json['tab1'];
    tab2 = json['tab2'];
    item_1_1 = json['item_1_1'];
    item_1_2 = json['item_1_2'];
    item_1_3 = json['item_1_3'];
    item_2_1 = json['item_2_1'];
    item_2_2 = json['item_2_2'];
    item_2_3 = json['item_2_3'];
    item_2_4 = json['item_2_4'];
    msg_title_login_fail = json['msg_title_login_fail'];
    msg_description_login_fail = json['msg_description_login_fail'];
    msg_title_login_success = json['msg_title_login_success'];
    msg_description_login_success = json['msg_description_login_success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['viLang'] = viLang;
    data['enLang'] = enLang;
    data['login'] = login;
    data['logout'] = logout;
    data['username'] = username;
    data['password'] = password;
    data['btLogin'] = btLogin;
    data['lightDisplay'] = lightDisplay;
    data['darkDisplay'] = darkDisplay;
    data['home'] = home;
    data['tab1'] = tab1;
    data['tab2'] = tab2;
    data['item_1_1'] = item_1_1;
    data['item_1_2'] = item_1_2;
    data['item_1_3'] = item_1_3;
    data['item_2_1'] = item_2_1;
    data['item_2_2'] = item_2_2;
    data['item_2_3'] = item_2_3;
    data['item_2_4'] = item_2_4;
    data['msg_title_login_fail'] = msg_title_login_fail;
    data['msg_description_login_fail'] = msg_description_login_fail;
    data['msg_title_login_success'] = msg_title_login_success;
    data['msg_description_login_success'] = msg_description_login_success;
    return data;
  }
}

final LocalValueKey default_app_local_value_key = LocalValueKey (
  viLang: 'Vietnamese',
  enLang: 'English',
  login: 'Login',
  logout: 'Logout',
  username: 'Username',
  password: 'Password',
  btLogin: 'Sign in',
  lightDisplay: 'Light',
  darkDisplay: 'Dark',
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
);

class ItemLocalValueKey {
  String code = "default";
  LocalValueKey keys = default_app_local_value_key;

  ItemLocalValueKey({required this.code, required this.keys});

  ItemLocalValueKey.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    keys = json['keys'] != null
        ? LocalValueKey.fromJson(json['keys']!)
        : default_app_local_value_key;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['keys'] = keys.toJson();
    return data;
  }
}

final List<ItemLocalValueKey> localValueKeys = [];

List<String> getListCodeValueKey() {
  List<String> tmps = [];
  for (ItemLocalValueKey tmp in localValueKeys) {
    tmps.add(tmp.code);
  }
  return tmps;
}

LocalValueKey? getValueKey(String code) {
  ItemLocalValueKey? item = localValueKeys.where((s) => s.code.compareTo(code) == 0).firstOrNull;
  if(item == null) {
    return null;
  }
  return item.keys;
}

// class AppLocalValueKeyNotifier extends Notifier<ItemLocalValueKey> {
//   @override
//   LocalValueKey build() {
//     // TODO: implement build
//     return ItemLocalValueKey(code: "default", keys: default_app_local_value_key);
//     return default_app_local_value_key;
//   }
//
//   void update(LocalValueKey keys) {
//     state = keys;
//   }
//
//   bool setValue(String code) {
//     ItemLocalValueKey? item = localValueKeys.where((s) => s.code.compareTo(code) == 0).firstOrNull;
//     if (item != null) {
//       state = item.keys;
//       return true;
//     } else {
//       return false;
//     }
//   }
// }

// final appLocalValueKeyProvider = NotifierProvider<AppLocalValueKeyNotifier, ItemLocalValueKey>(AppLocalValueKeyNotifier.new);