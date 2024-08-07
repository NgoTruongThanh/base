import 'dart:ui';

import 'package:basestvgui/routers/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  app_dataStore.initStore().then((value) {
    initAppConfigFromNetwork().then((value) {
      runApp(const ProviderScope(
        child: MyDisplay(),
      ),);
    });
  });
}

class MyDisplay extends ConsumerWidget {
  const MyDisplay({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      scrollBehavior: const ScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
        scrollbars: true,
        overscroll: true,
      ),
      title: 'Base Code',
      debugShowCheckedModeBanner: false,
      routerConfig: ref.read(goRouterProvider),
    );
  }
}