import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../../data/app_menu.dart';
import '../../../data/app_provider.dart';

class BaseSidebar extends ConsumerWidget {
  final List<MenuChildItem> items;
  final SidebarXController controller;
  final String root;
  const BaseSidebar({super.key, required this.root, required this.items, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(getAppColor);
    return SidebarX(
      controller : controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: appColors.mainColor,
          borderRadius: BorderRadius.circular(0),
        ),
        textStyle: TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            color: appColors.textColor
        ),
        selectedTextStyle: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: appColors.textColor
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: Colors.black),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          //   color: Colors.black.withOpacity(0.37),
          // ),
          gradient: LinearGradient(
            colors: [appColors.selectedColor, appColors.selectedColor2],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: appColors.iconBgColor,
          size: 20,
        ),
        selectedIconTheme: IconThemeData(
          color: appColors.iconBgColor,
          size: 20,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: appColors.mainColor,
        ),
      ),
      footerDivider: Divider(color: Colors.brown.withOpacity(0.3), height: 1),
      items: items.map((e) => SidebarXItem(
        icon: Icons.home,
        label: ref.watch(getTextLanguageProvider(e.code!)),
        onTap: () {
          // List<MenuItem>? _items = getAppConfigMenuFromStore();
          // if(_items != null && _items.isNotEmpty) {
          //   for (MenuItem _item in _items) {
          //     if(_item.children != null && _item.children!.isNotEmpty) {
          //       MenuChildItem? _tmp = _item.children!.where((s) => s.code != null && s.code!.compareTo(item.code!) == 0).firstOrNull;
          //       if(_tmp != null) {
          //         context.goNamed(_item!.code!);
          //       }
          //     }
          //   }
          // }
          context.goNamed(e.code!);
        },
      ),).toList(),
    );
  }
}