import 'dart:ui';

import 'package:basestvgui/routers/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'data/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  app_dataStore.initStore().then((value) {
    initAppConfig().then((value) {
      runApp(const ProviderScope(
        child: MyDisplay(),
      ),);
    });
  });
  // runApp(const MyApp());
}

class MyDisplay extends ConsumerWidget {
  const MyDisplay({super.key});
  @override
  createState() {
    // TODO: implement createState
    return super.createState();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    // final goRouter = ref.watch(goRouterProvider);
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
      // localizationsDelegates: [
      //   ...context.localizationDelegates,
      //   SfLocalizationsViDelegate(),
      //   SfGlobalLocalizations.delegate,
      // ],
      //supportedLocales: context.supportedLocales,
      //locale: context.locale,
      //theme: getTheme(appColors),
      debugShowCheckedModeBanner: false,
      routerConfig: system_router,
    );
  }
}