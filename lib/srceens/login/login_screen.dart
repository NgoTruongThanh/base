import 'package:basestvgui/data/app_provider.dart';
import 'package:basestvgui/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_config.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen ({
    super.key,
  });

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isSignIn = false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  String txt_tilte = "login";
  String txt_username = "username";
  String txt_password = "password";
  String txt_bt_signin = "btLogin";

  @override
  Widget build(BuildContext context) {
    final appColors = ref.watch(getAppColor);
    return Scaffold(
      backgroundColor: appColors.mainColor,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(
                left: 35,
                top: 130
            ),
            child: Text(
              ref.watch(getTextLanguageProvider(txt_tilte)),
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
                            hintText: ref.watch(getTextLanguageProvider(txt_username)),
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
                              backgroundColor: appColors.buttonColor, // background (button) color
                              foregroundColor: appColors.selectedColor, // foreground (text) color
                            ),
                            onPressed: () {
                              isSignIn = true;
                              ref.read(userControllerProvider.notifier).login(username.text, password.text);
                              useState.when(
                                data: (value) {
                                  print("$value");
                                  if(value == null) {
                                    if(isSignIn) {
                                      Future.delayed(const Duration(milliseconds: 100),() {
                                        context.showFailureToast(
                                          title: 'appLang!.msg_title_login_fail',
                                          description: 'appLang!.msg_description_login_fail',
                                        );
                                      });
                                    }
                                    return Text (
                                      txt_bt_signin,
                                      style: TextStyle(
                                        color: appColors.textColor,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  } else {
                                    Future.delayed(const Duration(milliseconds: 100), () {
                                      context.goNamed("home", extra: true);
                                      context.showSuccessToast(
                                        title: 'appLang!.msg_title_login_success',
                                        description: 'appLang!.msg_description_login_success + " ${value.name}"',
                                      );
                                    });
                                    return const CircularProgressIndicator();
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
                                      color: appColors.textColor,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                                loading: () {
                                  return const CircularProgressIndicator();
                                },
                              );
                            },
                            child: const Text('data'),
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
    );
  }
}