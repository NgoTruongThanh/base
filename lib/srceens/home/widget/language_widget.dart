import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/app_color.dart';
import '../../../data/app_config.dart';
import '../../../data/local_value_key.dart';

class LanguageButton extends ConsumerWidget {
  LanguageButton({super.key});

  @override
  createState() {
    // TODO: implement createState
    return super.createState();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    List<String> langs = getListCodeValueKey();
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          return appColors!.mainColor;
        }
        ),
      ),
      builder: (context, controller, child) {
        return SizedBox(
          width: 100,
          child: TextButton.icon(
            icon: const Icon(Icons.language),
            onPressed: () {
              controller.open();
            },
            style: TextButton.styleFrom(
              foregroundColor: appColors!.accountColor,
            ),
            label: Text(
              configLang!,
              textWidthBasis: TextWidthBasis.parent,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: appColors!.accountTextColor,
              ),
            ),
          ),
        );
      },
      menuChildren: langs.map((String value) {
        return MenuItemButton(
          child: Text(
            value,
            style: TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: appColors!.accountTextColor,
            ),
          ),
          onPressed: () {
            setAppLangToStore(value).then((s) {
              ref.read(appConfigProvider.notifier).updateColors(value);
            });
            print("${value}");
            ref.read(appConfigProvider.notifier).updateValueKey(value);
          },
        );
      }).toList(),
    );
  }
}