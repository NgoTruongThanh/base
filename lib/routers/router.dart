import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../data/app_config.dart';
import '../data/app_menu.dart';
import '../data/models/user.dart';
import '../srceens/home/home_screen.dart';
import '../srceens/login/login_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

// final GoRouter system_router = GoRouter(
//     navigatorKey: _rootNavigatorKey,
//     initialLocation: '/',
//     // debugLogDiagnostics: true,
//     routes: [
//       GoRoute(
//         path: '/login',
//         name: 'login',
//         builder: (BuildContext context, GoRouterState state) {
//           return LoginScreen();
//         }
//       ),
//       ShellRoute(
//           navigatorKey: _shellNavigatorKey,
//           builder: (context, state, child) => HomeScreen(
//             child: child,
//           ),
//           routes: [
//             GoRoute(
//                 path: '/',
//                 name: 'home',
//                 pageBuilder: (BuildContext context, GoRouterState state) {
//                   return const NoTransitionPage(
//                       child: Text("Text")
//                     //child: NotificationListView(),
//                   );
//                   // return HomeUI(child: Text("Text"));
//                 }
//             ),
//             GoRoute(
//                 path: '/tab1',
//                 name: 'tab1',
//                 pageBuilder: (BuildContext context, GoRouterState state) {
//                   return const NoTransitionPage(
//                       child: Text("Text Item 1")
//                   );
//                   // return HomeUI(child: Text("Text"));
//                 }
//             ),
//             GoRoute(
//                 path: '/tab1/item_1_1',
//                 name: 'item_1_1',
//                 pageBuilder: (BuildContext context, GoRouterState state) {
//                   return const NoTransitionPage(
//                       child: Text("Text Item 1 - 1")
//                   );
//                   // return HomeUI(child: Text("Text"));
//                 }
//             ),
//             GoRoute(
//                 path: '/tab1/item_1_2',
//                 name: 'item_1_2',
//                 pageBuilder: (BuildContext context, GoRouterState state) {
//                   return const NoTransitionPage(
//                       child: Text("Text Item 1 - 2")
//                   );
//                   // return HomeUI(child: Text("Text"));
//                 }
//             ),
//             GoRoute(
//                 path: '/tab1/item_1_3',
//                 name: 'item_1_3',
//                 pageBuilder: (BuildContext context, GoRouterState state) {
//                   return const NoTransitionPage(
//                       child: Text("Text Item 1 - 3")
//                   );
//                   // return HomeUI(child: Text("Text"));
//                 }
//             ),
//
//             GoRoute(
//                 path: '/tab2',
//                 name: 'tab2',
//                 pageBuilder: (BuildContext context, GoRouterState state) {
//                   return const NoTransitionPage(
//                       child: Text("Text Item 2")
//                   );
//                   // return HomeUI(child: Text("Text"));
//                 }
//             ),
//             GoRoute(
//                 path: '/tab2/item_2_1',
//                 name: 'item_2_1',
//                 pageBuilder: (BuildContext context, GoRouterState state) {
//                   return const NoTransitionPage(
//                       child: Text("Text Item 2 - 1")
//                   );
//                   // return HomeUI(child: Text("Text"));
//                 }
//             ),
//             GoRoute(
//                 path: '/item2/item_2_2',
//                 name: 'item_2_2',
//                 pageBuilder: (BuildContext context, GoRouterState state) {
//                   return const NoTransitionPage(
//                       child: Text("Text Item 2 - 2")
//                   );
//                   // return HomeUI(child: Text("Text"));
//                 }
//             ),
//             GoRoute(
//                 path: '/tab2/item_2_3',
//                 name: 'item_2_3',
//                 pageBuilder: (BuildContext context, GoRouterState state) {
//                   return const NoTransitionPage(
//                       child: Text("Text Item 2 - 3")
//                   );
//                   // return HomeUI(child: Text("Text"));
//                 }
//             ),
//             GoRoute(
//                 path: '/tab2/item_2_4',
//                 name: 'item_2_4',
//                 pageBuilder: (BuildContext context, GoRouterState state) {
//                   return const NoTransitionPage(
//                       child: Text("Text Item 2 - 4")
//                   );
//                   // return HomeUI(child: Text("Text"));
//                 }
//             ),
//           ]
//       ),
//
//     ],
//     redirect: systemRedirect
// );

FutureOr<String?> systemRedirect (BuildContext context, GoRouterState state) {
  User? user = getUserFromStore();
  if(user == null) {
    return '/login';
  } else {
    List<MenuItem>? items = getAppConfigMenuFromStore();
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
      break;
    case 'item_1_1':
      return const Text("Text Item 1 In Tab 1");
      break;
    case 'item_1_2':
      return const Text("Text Item 1 In Tab 2");
      break;
    case 'item_1_3':
      return const Text("Text Item 1 In Tab 3");
      break;
    case 'tab2':
      return const Text("Text Tab 2");
      break;
    case 'item_2_1':
      return const Text("Text Item 2 In Tab 1");
      break;
    case 'item_2_2':
      return const Text("Text Item 2 In Tab 2");
      break;
    case 'item_2_3':
      return const Text("Text Item 2 In Tab 3");
      break;
    case 'item_2_4':
      return const Text("Text Item 2 In Tab 4");
      break;
    case 'home':
      return const Text("Text Home");
      break;
    default:
      return const Text("Empty");
  }
}

GoRouter genRoute() {
  List<MenuItem>? items = getAppConfigMenuFromStore();

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
            GoRoute route = GoRoute(
                path: "/${_item.name}/${_child.name}",
                name: _child.code,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return NoTransitionPage(
                    child: goRouteWidget(_child.code!),
                  );
                }
            );
            groupHome.add(route);
          }
        }
      } else {
        GoRoute route = GoRoute(
            path: "/${_item.name}",
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
            GoRoute route = GoRoute(
                path: "/${_item.name}/${_child.name}",
                name: _child.code,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return NoTransitionPage(
                    child: goRouteWidget(_child.code!),
                  );
                }
            );
            groupHome.add(route);
          }
        }
      }
    }
  }
  GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
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
    redirect: systemRedirect
  );
  return router;
}

final GoRouter system_router = genRoute();