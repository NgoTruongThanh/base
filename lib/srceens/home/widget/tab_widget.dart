import 'package:basestvgui/data/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class TabColItem extends ConsumerWidget {
  final String title;
  final bool isSelected;
  const TabColItem({super.key, required this.title, this.isSelected = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(getAppColor);
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
          ref.watch(getTextLanguageProvider(title))  ,
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