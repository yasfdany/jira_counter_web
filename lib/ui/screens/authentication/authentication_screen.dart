// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jira_counter/router/router.dart';
import 'package:jira_counter/ui/screens/company/company_screen.dart';
import 'package:jira_counter/ui/screens/login/provider/auth_provider.dart';
import 'package:widget_helper/widget_helper.dart';

class AuthenticationScreen extends ConsumerStatefulWidget {
  static String get routeName => '/authenticate';
  final String? code;

  const AuthenticationScreen({
    super.key,
    this.code,
  });

  @override
  AuthenticationScreenState createState() => AuthenticationScreenState();
}

class AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    var url = window.location.href;
    if (widget.code.isNotNull) {
      await ref
          .read(authProvider)
          .getToken(code: widget.code!, redirectUrl: url);
      if (ref.read(authProvider).token.isNotNull) {
        ref.read(routerProvider).replace(CompanyScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
