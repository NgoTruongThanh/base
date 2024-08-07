import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/app_color.dart';
import '../../../data/app_config.dart';
import '../../../data/app_provider.dart';

class AccountButton extends ConsumerWidget{
  const AccountButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(getAppColor);
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            return appColors.mainColor;
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
              foregroundColor: appColors.accountColor,
            ),
            label: Text(
              getUserFromStore()?.name ?? "",
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
            themeTitle,
            style: TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: appColors.accountTextColor,
            ),
          ),
          onPressed: () {
            List<String> tmps = getListCodeAppColors();
            String? tmp = tmps.where((s) => s.compareTo(themeTitle) != 0).firstOrNull;
            if(tmp != null) {
              setAppColorsToStore(tmp).then((value) {
                ref.invalidate(getAppColor);
              });
            }
          },
        ),
        MenuItemButton(
          child: Text(
            ref.watch(configLanguageProvider).logout,
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