import 'dart:async';

import 'package:basestvgui/srceens/home/page/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/app_config.dart';
import '../data/app_menu.dart';
import '../data/app_provider.dart';
import '../data/models/account.dart';
import '../srceens/home/home_screen.dart';
import '../srceens/login/login_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

FutureOr<String?> systemRedirect (BuildContext context, GoRouterState state,Ref ref) {
  Account? account = getUserFromStore();
  if(account == null) {
    return '/login';
  } else {
    List<MenuItem>? items = ref.read(configMenuProvider);
    if(items != null && items.isNotEmpty) {
      for(MenuItem _item in items) {
        if(_item.children != null && _item.children!.isNotEmpty) {
          if (state.matchedLocation.compareTo("/${_item.name}") == 0) {
            return "/${_item.name}/${_item.children![0].name}";
          }
        }
      }
    }
  }
  return null;
}

Widget goRouteWidget(String code) {
  switch(code) {
    case 'tab1':
      return const Text("Text Tab 1");
    case 'item_1_1':
      return const Text("Text Item 1 In Tab 1");
    case 'item_1_2':
      return const Text("Text Item 1 In Tab 2");
    case 'item_1_3':
      return const Text("Text Item 1 In Tab 3");
    case 'tab2':
      return const Text("Text Tab 2");
    case 'item_2_1':
      return const Text("Text Item 2 In Tab 1");
    case 'item_2_2':
      return const Text("Text Item 2 In Tab 2");
    case 'item_2_3':
      return const Text("Text Item 2 In Tab 3");
    case 'item_2_4':
      return const Text("Text Item 2 In Tab 4");
    case 'home':
      return const HomePage();
    default:
      return const Text("Empty");
  }
}

final goRouterProvider = Provider<GoRouter>(
      (ref) {
        List<MenuItem>? items = ref.read(configMenuProvider);

        GoRoute screenLogin = GoRoute(
            path: '/login',
            name: 'login',
            builder: (BuildContext context, GoRouterState state) {
              return const LoginScreen();
            }
        );

        List<GoRoute> groupHome = [];

        if(items != null && items.isNotEmpty) {
          for(MenuItem _item in items) {
            if(_item.code!.compareTo("home") == 0) {
              GoRoute route = GoRoute(
                  path: "/",
                  name: _item.code,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return NoTransitionPage(
                      child: goRouteWidget(_item.code!),
                    );
                  }
              );
              groupHome.add(route);
              if(_item.children != null && _item.children!.isNotEmpty) {
                for(MenuChildItem _child in _item.children!) {
                  GoRoute route0 = GoRoute(
                      path: "/${_item.name}/${_child.name}",
                      name: _child.code,
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        return NoTransitionPage(
                          child: goRouteWidget(_child.code!),
                        );
                      }
                  );
                  groupHome.add(route0);
                }
              }
            } else {
              GoRoute route0 = GoRoute(
                  path: "/${_item.name}",
                  name: _item.code,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return NoTransitionPage(
                      child: goRouteWidget(_item.code!),
                    );
                  }
              );
              groupHome.add(route0);
              if(_item.children != null && _item.children!.isNotEmpty) {
                for(MenuChildItem _child in _item.children!) {
                  GoRoute route0 = GoRoute(
                      path: "/${_item.name}/${_child.name}",
                      name: _child.code,
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        return NoTransitionPage(
                          child: goRouteWidget(_child.code!),
                        );
                      }
                  );
                  groupHome.add(route0);
                }
              }
            }
          }
        }
        GoRouter router = GoRouter(
            navigatorKey: rootNavigatorKey,
            initialLocation: '/',
            routes: [
              screenLogin,
              ShellRoute(
                navigatorKey: _shellNavigatorKey,
                builder: (context, state, child) => HomeScreen(
                  child: child,
                ),
                routes: groupHome,
              ),
            ],
            redirect: (context, state) => systemRedirect(context, state, ref),
        );
        return router;
  },
);


