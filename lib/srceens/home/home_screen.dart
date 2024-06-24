
import 'package:basestvgui/srceens/home/widget/account_widget.dart';
import 'package:basestvgui/srceens/home/widget/base_sidebar_widget.dart';
import 'package:basestvgui/srceens/home/widget/language_widget.dart';
import 'package:basestvgui/srceens/home/widget/notification_widget.dart';
import 'package:basestvgui/srceens/home/widget/tab_widget.dart';
import 'package:basestvgui/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../data/app_color.dart';
import '../../data/app_config.dart';
import '../../data/app_menu.dart';
import '../../data/local_value_key.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final Widget child;

  const HomeScreen ({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _homeKey = GlobalKey<FormState>();
  // List<MenuItem> tabs = [];
  final SidebarXController _sidebarController = SidebarXController(selectedIndex: 0, extended: true);
  String _pre_selectMenuBar = "";
  String _pre_selectSideBar = "";
  //

  void _init() {
    String currentRoute = context.currrentRoute.replaceRange(0, 1, '');
    List<String> buf = currentRoute.split('/');
    if(buf.isNotEmpty) {
      if(buf[0].isNotEmpty) {
        MenuItem? tmp = default_app_menu.where((s) => s.code != null && s.name != null && s.name!.compareTo(buf[0]) == 0).firstOrNull;
        if(tmp != null) {
          _pre_selectMenuBar = tmp.code!;
          if(buf.length > 1) {
            if(tmp.children != null && tmp.children!.isNotEmpty) {
              MenuChildItem? temp = tmp.children!.where((s) => s.name != null && s.name!.compareTo(buf[1]) == 0).firstOrNull;
              if(temp != null && temp.code != null && temp.code!.isNotEmpty) {
                _pre_selectSideBar = temp.code!;
                _sidebarController.selectIndex(tmp.children!.indexOf(temp));
              }
            }
          } else {
            if(tmp.children != null && tmp.children!.isNotEmpty) {
              _pre_selectSideBar = tmp.children![0].code!;
              _sidebarController.selectIndex(0);
            }
          }
        }
      } else {
        if (default_app_menu.isNotEmpty && default_app_menu[0].name != null && default_app_menu[0].name!.isNotEmpty) {
          _pre_selectMenuBar = default_app_menu[0].code!;
        }
      }
    } else {
      if (default_app_menu.isNotEmpty && default_app_menu[0].name != null && default_app_menu[0].name!.isNotEmpty) {
        _pre_selectMenuBar = default_app_menu[0].code!;
      }
    }
  }

  List<Widget> getTab(List<MenuItem> menu) {
    List<Widget> tabs = [];
    if(menu.isNotEmpty) {
      for(MenuItem item in menu) {
        if(item.code != null) {
          tabs.add(TabColItem(
              title: item.code!,
              isSelected: item.code!.compareTo(_pre_selectMenuBar) == 0 ? true : false
          ));
        }
      }
    }
    return tabs;
  }

  List<Widget> getBody(MenuItem? itemMenu) {
    List<Widget> body = [];
    if(itemMenu == null || itemMenu.children == null || itemMenu.children!.isEmpty) {

    } else {
      if(itemMenu.type == null || itemMenu.type!.isEmpty) {

      } else if (itemMenu.type!.compareTo("base") == 0) {
        body.add(BaseSidebar(
          items: itemMenu != null ? (itemMenu.children != null ? itemMenu.children! : []) : [] ,
          controller: _sidebarController,
          root: itemMenu != null ? (itemMenu.code != null ? itemMenu.code! : "") : "",
        ));
      } else {

      }
    }

    body.add(widget.child);
    return body;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("Draw ...");
    _init();
    final appConfig = ref.watch(appConfigProvider);

    String? configColor = getAppColorsFromStore();
    print(" config color : $configColor");
    AppColors? appColors;
    if(configColor != null) {
      appColors = getAppColors(configColor);
      appColors ??= default_app_colors;
    } else {
      appColors = default_app_colors;
    }

    String? configLang = getAppLangFromStore();
    print(" config Lang : $configLang");
    LocalValueKey? appLang;
    if(configLang != null) {
      appLang = getValueKey(configLang);
      appLang ??= default_app_local_value_key;
    } else {
      appLang = default_app_local_value_key;
    }

    MenuItem? itemMenu;
    if(appConfig.cfgMenu.isNotEmpty) {
      itemMenu = appConfig.cfgMenu.where((s) => s.code != null && s.code!.compareTo(_pre_selectMenuBar) == 0).firstOrNull;
    }

    return Container(
      key: _homeKey,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(35),
          child: Material(
            color: appColors.mainColor,
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    children: getTab(appConfig.cfgMenu),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const NotificationButton(),
                const SizedBox(
                  width: 4,
                ),
                const LanguageButton(),
                const SizedBox(
                  width: 4,
                ),
                const AccountButton(),
              ],
            ),
          ),
        ),
        body: Row(
          children: getBody(itemMenu),
        ),
      ),
    );
  }
}
