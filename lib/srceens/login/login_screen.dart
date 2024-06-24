import 'package:basestvgui/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../data/app_color.dart';
import '../../data/app_config.dart';
import '../../data/local_value_key.dart';
import '../../data/models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen ({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginKey = GlobalKey<FormState>();
  bool isSignIn = false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    String? configColor = getAppColorsFromStore();
    AppColors? appColors;
    if(configColor != null) {
      appColors = getAppColors(configColor);
      appColors ??= default_app_colors;
    } else {
      appColors = default_app_colors;
    }

    String? configLang = getAppLangFromStore();
    LocalValueKey? appLang;
    if(configLang != null) {
      appLang = getValueKey(configLang);
      appLang ??= default_app_local_value_key;
    } else {
      appLang = default_app_local_value_key;
    }

    Map<String, dynamic> store = appLang.toJson();

    String txt_tilte = "login";
    MapEntry? entry = store.entries.where((s) => s.key.compareTo(txt_tilte) == 0).firstOrNull;
    if (entry != null) {
      txt_tilte = entry.value.toString();
    }

    String txt_username = "username";
    entry = store.entries.where((s) => s.key.compareTo(txt_username) == 0).firstOrNull;
    if (entry != null) {
      txt_username = entry.value.toString();
    }

    String txt_password = "password";
    entry = store.entries.where((s) => s.key.compareTo(txt_password) == 0).firstOrNull;
    if (entry != null) {
      txt_password = entry.value.toString();
    }

    String txt_bt_signin = "btLogin";
    entry = store.entries.where((s) => s.key.compareTo(txt_bt_signin) == 0).firstOrNull;
    if (entry != null) {
      txt_bt_signin = entry.value.toString();
    }

    return Container(
      key: _loginKey,
      child: Scaffold(
        backgroundColor: appColors.mainColor,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 35,
                top: 130
              ),
              child: Text(
                txt_tilte,
                style: TextStyle(
                  color: appColors.textColor,
                  fontSize: 33,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5
                ),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox (
                        width: 300.0,
                        child: TextField(
                          controller: username,
                          style: TextStyle(
                            color: appColors.textColor,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            fillColor: appColors.selectedColor,
                            filled: true,
                            hintText: txt_username,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox (
                        width: 300.0,
                        child: TextField(
                          controller: password,
                          style: TextStyle(
                            color: appColors.textColor,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: appColors.selectedColor,
                            filled: true,
                            hintText: txt_password,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref, Widget? child) {
                          final useState = ref.watch(userControllerProvider);
                          return SizedBox(
                            width: 250.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appColors!.buttonColor, // background (button) color
                                foregroundColor: appColors!.selectedColor, // foreground (text) color
                              ),
                              onPressed: () {
                                isSignIn = true;
                                ref.read(userControllerProvider.notifier).login(username.text, password.text);
                              },
                              child: useState.when(
                                data: (value) {
                                  print("$value");
                                  if(value == null) {
                                    if(isSignIn) {
                                      Future.delayed(const Duration(milliseconds: 100),() {
                                        context.showFailureToast(
                                          title: appLang!.msg_title_login_fail,
                                          description: appLang!.msg_description_login_fail,
                                        );
                                      });
                                    }
                                    return Text (
                                      txt_bt_signin,
                                      style: TextStyle(
                                        color: appColors!.textColor,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  } else {
                                    Future.delayed(const Duration(milliseconds: 100), () {
                                      context.goNamed("home", extra: true);
                                      context.showSuccessToast(
                                        title: appLang!.msg_title_login_success,
                                        description: appLang!.msg_description_login_success + " ${value.name}",
                                      );
                                    });
                                    return CircularProgressIndicator();
                                    // return Text (
                                    //   txt_bt_signin,
                                    //   style: TextStyle(
                                    //     color: appColors!.textColor,
                                    //     fontStyle: FontStyle.normal,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // );
                                  }
                                },
                                error: (e, st) {
                                  Future.delayed(const Duration(milliseconds: 100), () {
                                    context.showFailureToast(
                                      title: "Login Fail",
                                      description: "Try again",
                                    );
                                  });
                                  return Text (
                                    txt_bt_signin,
                                    style: TextStyle(
                                      color: appColors!.textColor,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                                loading: () {
                                  return CircularProgressIndicator();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}