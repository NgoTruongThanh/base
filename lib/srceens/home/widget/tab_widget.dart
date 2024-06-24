import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/app_color.dart';
import '../../../data/app_config.dart';
import '../../../data/local_value_key.dart';

class TabColItem extends ConsumerWidget {
  final String title;
  final bool isSelected;
  const TabColItem({super.key, required this.title, this.isSelected = false});

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

    Map<String, dynamic> store = appLang.toJson();
    MapEntry? entry = store.entries.where((s) => s.key.compareTo(title) == 0).firstOrNull;
    String txt = title;
    if (entry != null) {
      txt = entry.value.toString();
    }

    return InkWell(
      onTap: () {
        context.goNamed(title);
        // List<MenuItem>? _items = getAppConfigMenuFromStore();
        // if(_items != null && _items.isNotEmpty) {
        //   MenuItem? _item = _items.where((s) => s.code != null && s.code != null && s.code!.compareTo(title) == 0).firstOrNull;;
        //   if(_item != null) {
        //     context.goNamed(_item!.code!);
        //   }
        // }
      },
      child: Ink(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: const Border.symmetric(
            vertical: BorderSide(color: Colors.grey, width: 0.5),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isSelected ? [appColors.selectedColor, appColors.selectedColor2] : [appColors.btnTextColor, appColors.btnTextColor],
          ),
        ),
        child: Text(
          txt,
          //keys(title == null ? title : _store[title]!,
          style: TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: appColors.textColor
          ),
        ),
      ),
    );
  }
}