import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/app_color.dart';
import '../../../data/app_config.dart';
import '../../../data/local_value_key.dart';
import '../../../data/models/user.dart';

class AccountButton extends ConsumerWidget{
  const AccountButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // const String displayUser = "Admin";

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

    String txtTheme = "";
    if(configColor != null) {
      Map<String, dynamic> store = appLang.toJson();
      MapEntry? entry = store.entries.where((s) => s.key.compareTo(configColor) == 0).firstOrNull;
      if (entry != null) {
        txtTheme = entry.value.toString();
      } else {
        txtTheme = configColor;
      }
    }


    User? user = getUserFromStore();

    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            return appColors!.mainColor;
          }
        ),
      ),
      builder: (context, controller, child) {
        return SizedBox(
          width: 120,
          child: TextButton.icon(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              controller.open();
            },
            style: TextButton.styleFrom(
              foregroundColor: appColors!.accountColor,
            ),
            label: Text(
              user != null ? user.name : "",
              textWidthBasis: TextWidthBasis.parent,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: appColors.accountTextColor,
              ),
            ),
          ),
        );
      },
      menuChildren: [
        MenuItemButton(
          child: Text(
            txtTheme,
            style: TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: appColors.accountTextColor,
            ),
          ),
          onPressed: () {
            List<String> tmps = getListCodeAppColors();
            String? tmp = tmps.where((s) => s.compareTo(configColor!) != 0).firstOrNull;
            if(tmp != null) {
              setAppColorsToStore(tmp).then((value) {
                ref.read(appConfigProvider.notifier).updateColors(tmp);
              });
            }
          },
        ),
        MenuItemButton(
          child: Text(
            appLang.logout,
            style: TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: appColors.accountTextColor,
          //backgroundColor: appColors.mainColor
            ),
          ),
          onPressed: () {
            clearUserStore().then((value) {
              Future.delayed(const Duration(milliseconds: 100), () {
                context.goNamed("login");
              });
            });
          },
        ),
      ],
    );
  }
}