import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/dialog.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage ({
    super.key
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SizedBox(
      width: mediaQuery.size.width,
      height: mediaQuery.size.height,
      child: Scaffold(
        body: Center(
          child: OutlinedButton(
            onPressed: () {
              DialogUtils.show(
                context,
                ref: ref,
                title: "Test",
                content: const Text("abcd"),
              );
            },
            child: const Text('Open Dialog'),
          ),
        ),
      ),
    );
  }
}