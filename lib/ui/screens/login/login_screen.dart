// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jira_counter/main.dart';
import 'package:jira_counter/r.dart';
import 'package:jira_counter/ui/screens/home/provider/task_provider.dart';
import 'package:jira_counter/utils/extensions.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../config/constant.dart';
import '../../../config/themes.dart';
import '../../../router/router.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/commons/safe_statusbar.dart';
import '../home/home_screen.dart';
import 'provider/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => '/login';

  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final router = ref.read(routerProvider);

      await ref.read(authProvider).checkSession();
      final token = ref.read(authProvider).token;
      if (token.isNotNull) {
        router.replace(HomeScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;

    final loading = ref.watch(authProvider).loading;

    return SafeStatusBar(
      statusBarColor: Colors.white,
      child: Scaffold(
        backgroundColor: Themes.whiteBg,
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  width: context.isWideScreen ? 500 : widthScreen,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AssetImages.ilLogin,
                          width: context.isWideScreen ? 300 : widthScreen,
                          height: 40.hp,
                        ),
                        Text(
                          "What is my story point?",
                          style: Themes().blackBold22,
                        ).addMarginBottom(6),
                        Text(
                          "Uhh, about that...",
                          style: Themes().black14,
                        ).addMarginBottom(24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PrimaryButton(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                              onTap: () async {
                                ref.read(taskProvider).reset();
                                final url = window.location.origin;
                                final encodedUrl = Uri.encodeComponent(url);

                                window.open(
                                  "https://auth.atlassian.com/authorize?audience=api.atlassian.com&client_id=${Constant.jiraClientId}&scope=read%3Ajira-work%20read%3Asprint%3Ajira-software&redirect_uri=$encodedUrl%2Fauthenticate&state=login&response_type=code&prompt=consent",
                                  "_self",
                                );
                              },
                              text: loading ? null : "Login to Jira",
                              child: loading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(
                                          Themes.primary,
                                        ),
                                      ),
                                    )
                                  : null,
                            ).addMarginTop(12),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "Created by StudioCloud",
              style: Themes().primaryBold14,
            ).addMarginBottom(12).onTap(() {
              launchUrlString(
                "https://studiocloud.dev",
                mode: LaunchMode.externalApplication,
              );
            }),
          ],
        ),
      ),
    );
  }
}
