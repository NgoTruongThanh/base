import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/app_color.dart';
import '../../../data/app_config.dart';
import '../../../data/local_value_key.dart';

class DialogUtils {
  static final DialogUtils _instance = DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void show(BuildContext context, {
    required String title,
    required Widget content,
  }) {
    final mediaQuery = MediaQuery.of(context);

    String? configColor = getAppColorsFromStore();
    // print(" config color : ${configColor}");
    AppColors? appColors;
    if(configColor != null) {
      appColors = getAppColors(configColor);
      appColors ??= default_app_colors;
    } else {
      appColors = default_app_colors;
    }

    String? configLang = getAppLangFromStore();
    // print(" config Lang : ${configLang}");
    LocalValueKey? appLang;
    if(configLang != null) {
      appLang = getValueKey(configLang);
      appLang ??= default_app_local_value_key;
    } else {
      appLang = default_app_local_value_key;
    }

    showDialog(
      context: context,
      builder: (context) {
        Dialog dialog = Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          // insetPadding: EdgeInsets.only(top: 10.0),
          child: Scaffold(
            backgroundColor: appColors!.mainColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(35),
              child: Material(
                color: appColors!.selectedColor,
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: appColors.textColor,
                    ),
                  ),
                ),
              ),
            )
          ),
          // Container(
          //   // width: mediaQuery.size.width*0.8,
          //   // height: mediaQuery.size.height*0.8,
          //   child: Center(
          //     child: Material(
          //       color: Colors.transparent,
          //       child: Column(
          //
          //       ),
          //     ),
          //   ),
          // ),
        );
        return dialog;
      }
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  HomePage ({
    super.key
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  //final _homepageKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // TODO: implement build
    return Container(
      width: mediaQuery.size.width,
      height: mediaQuery.size.height,
      child: Scaffold(
        body: Center(
          child: OutlinedButton(
            onPressed: () {
              DialogUtils.show(
                context,
                title: "Test",
                content: Text("abcd"),
              );
            },
            child: const Text('Open Dialog'),
          ),
        ),
      ),
    );
  }
}