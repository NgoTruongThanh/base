import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ContextExtension on BuildContext {
  void showSuccessToast({required String title, required String description}) {
    ElegantNotification.success(
      width: 300,
      height: 80,
      border: Border.all(),
      position: Alignment.bottomRight,
      stackedOptions: StackedOptions(
        key: 'above',
        type: StackedType.above,
      ),
      description: Text(
        style: const TextStyle(
          color: Colors.black,
        ),
        description,
      ),
      title: Text(
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        title,
      ),
    ).show(this);
  }

  void showFailureToast({required String title, required String description}) {
    ElegantNotification.error(
      width: 300,
      height: 80,
      position: Alignment.bottomRight,
      border: Border.all(),
      stackedOptions: StackedOptions(
        key: 'above',
        type: StackedType.above,
      ),
      description: Text(
        style: const TextStyle(
          color: Colors.black,
        ),
        description,
      ),
      title: Text(
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        title,
      ),
    ).show(this);
  }

  String get currrentRoute => GoRouter.of(this).routeInformationProvider.value.uri.path;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
}