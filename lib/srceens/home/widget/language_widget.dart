import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/app_config.dart';
import '../../../data/app_provider.dart';
import '../../../data/local_value_key.dart';

class LanguageButton extends ConsumerWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(getAppColor);

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
          return appColors.mainColor;
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
              foregroundColor: appColors.accountColor,
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
                color: appColors.accountTextColor,
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
              color: appColors.accountTextColor,
            ),
          ),
          onPressed: () {
            setAppLangToStore(value).then((s) {
              ref.invalidate(configLanguageProvider);
            });
            ref.read(appConfigProvider.notifier).updateValueKey(value);
          },
        );
      }).toList(),
    );
  }
}