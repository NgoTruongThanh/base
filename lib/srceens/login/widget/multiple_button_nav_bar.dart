import 'package:basestvgui/data/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/app_menu.dart';
class MultipleButtonNavBar extends ConsumerWidget {
  final MenuItem item;
  const MultipleButtonNavBar({super.key,required this.item});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return MouseRegion(
      cursor:  SystemMouseCursors.click,
      child: GestureDetector(
        onTapUp: (TapUpDetails details) async{
          // setState(() {
          //   appController.getColorNavBar(main,true,Colors.white);
          // });
          double left = details.globalPosition.dx - details.localPosition.dx + 10;
          double top = details.globalPosition.dy - details.localPosition.dy + 50;
          await showMenu<MenuChildItem>(
            context: context,
            position: RelativeRect.fromLTRB(left,top,left,top),      //position where you want to show the menu on screen
            items: item.children?.map((button) => PopupMenuItem(
              height: 40,
              value: button,
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  Expanded(child: Container(
                    // color: appController.getColorNavBar(button,false,Colors.transparent),
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    child: Text(ref.watch(getTextLanguageProvider(item.code??""))),
                  ))
                ],
              ),
            )).toList() ??[],
            elevation: 8.0,
          ).then<void>((MenuChildItem ?value) {
            if(value != null) {
              context.goNamed(value.code!);
            }
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          decoration: BoxDecoration(
              // color: appController.getColorNavBarBackground(main),
              borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            children: [
              Text(ref.watch(getTextLanguageProvider(item.code??""))),
              const Icon(Icons.arrow_drop_down,size: 20,)
            ],
          ),
        ),
      ),
    );
  }


}

