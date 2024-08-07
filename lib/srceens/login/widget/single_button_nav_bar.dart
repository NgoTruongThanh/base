import 'package:basestvgui/data/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/app_menu.dart';
class SingleButtonNavBar extends ConsumerStatefulWidget {
  final MenuItem item;
  const SingleButtonNavBar({super.key,required this.item});
  @override
  ConsumerState<SingleButtonNavBar> createState() => _SingleButtonNavBarState();
}

class _SingleButtonNavBarState extends ConsumerState<SingleButtonNavBar> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.goNamed(widget.item.code??"");
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        decoration: BoxDecoration(
          // color: getColorNavBarBackground(widget.item),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Text(ref.watch(getTextLanguageProvider(widget.item.code??""))),
      ),
    );
  }
}


