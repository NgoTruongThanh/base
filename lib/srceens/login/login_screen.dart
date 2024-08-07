import 'package:basestvgui/data/app_provider.dart';
import 'package:basestvgui/srceens/login/widget/auth_input.dart';
import 'package:basestvgui/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../data/app_assets.dart';
import '../../data/app_config.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> obscureText = ValueNotifier(true);
  String _userName = '';
  String _password = '';

  @override
  void dispose() {
    obscureText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = ref.watch(getAppColor);
    final appTrans = ref.watch(configLanguageProvider);
    return Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          /*Container(
            padding: const EdgeInsets.all(4),
            color: Colors.black26,
            child: const LanguageDropDown(),
          ),*/
          Center(
            child: SingleChildScrollView(
              child: FractionallySizedBox(
                widthFactor: getValueForScreenType<double>(
                  context: context,
                  mobile: 1,
                  desktop: 0.5,
                  tablet: 0.8,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(
                          image: AssetImage(
                            bigLogoDark,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AuthInput(
                              title: appTrans.username,
                              hintText: appTrans.username,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  // return LocaleKeys.pleaseInputFullInfo.tr(context: context);
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userName = value!.trim();
                              },
                            ),
                            const SizedBox(height: 16),
                            ValueListenableBuilder(
                              valueListenable: obscureText,
                              builder: (context, value, child) {
                                return AuthInput(
                                  title: appTrans.password,
                                  hintText: appTrans.password,
                                  obscureText: value,
                                  // Sử dụng thuộc tính này
                                  icon: IconButton(
                                    onPressed: () {
                                      obscureText.value = !value;
                                    },
                                    icon: Icon(
                                      !value ? Icons.visibility : Icons.visibility_off,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      // return LocaleKeys.pleaseInputFullInfo.tr(context: context);
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _password = value!.trim();
                                  },
                                  onFieldSubmitted: (value) => _onLogin(),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            Consumer(
                              builder: (context, ref, child) {
                                final state = ref.watch(userControllerProvider);
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                  ),
                                  onPressed: state.isLoading ? null : _onLogin,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Builder(
                                      builder: (_) {
                                        if (state.isLoading) {
                                          return const CircularProgressIndicator.adaptive();
                                        }
                                        return Text(
                                          appTrans.login,
                                          // style: textTheme.titleLarge,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    await ref.read(userControllerProvider.notifier).login(_userName, _password);


    if (mounted && getUserFromStore() != null) {
      context.goNamed("home", extra: true);
      context.showSuccessToast(
        title: 'appLang!.msg_title_login_success',
        description: 'appLang!.msg_description_login_success + ""',
      );
    }

    if (ref.read(userControllerProvider).hasError || getUserFromStore() == null) {
      if (mounted) {
        context.showFailureToast(
          title: "Login Fail",
          description: "Try again",
        );
      }
    }
  }
}
