import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/constant.dart';
import '../../../../data/network/services/remote_task_service.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>(
  (ref) => AuthProvider(),
);

class AuthProvider extends ChangeNotifier {
  final RemoteTaskService remoteTaskService = RemoteTaskService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  SharedPreferences? _prefs;
  String? token;
  bool loading = false;

  AuthProvider() {
    checkSession();
  }

  Future getToken({
    required String code,
    required String redirectUrl,
  }) async {
    _prefs ??= await SharedPreferences.getInstance();

    final tokenResponse = await remoteTaskService.getToken(
      code: code,
      redirectUrl: redirectUrl,
    );
    if (tokenResponse != null) {
      token = tokenResponse.accessToken!;
      _prefs?.setString(Constant.jiraToken, tokenResponse.accessToken!);
    }
  }

  Future checkSession() async {
    _prefs ??= await SharedPreferences.getInstance();
    token = _prefs?.getString(Constant.jiraToken);
    notifyListeners();
  }

  Future logout() async {
    _prefs ??= await SharedPreferences.getInstance();
    _prefs?.clear();
    notifyListeners();
  }
}
