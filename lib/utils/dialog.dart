import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_config.dart';
import '../data/app_provider.dart';
import '../data/local_value_key.dart';

class DialogUtils {
  static final DialogUtils _instance = DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void show(BuildContext context, {
    required String title,
    required Widget content,
    required WidgetRef ref,

  }) {
    final appColors = ref.watch(getAppColor);


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
                backgroundColor: appColors.mainColor,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(35),
                  child: Material(
                    color: appColors.selectedColor,
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
          );
          return dialog;
        }
    );
  }
}
