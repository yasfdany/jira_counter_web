// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jira_counter/data/network/entity/company.dart';
import 'package:jira_counter/data/network/entity/token_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/constant.dart';
import '../api_client.dart';
import '../api_interface.dart';
import '../entity/jira_project_response.dart';
import '../entity/status_response.dart';

class RemoteTaskService extends ApiInterface {
  SharedPreferences? prefs;
  String? basicAuth;
  String? baseUrl;
  String? token;
  String? cloudId;

  RemoteTaskService() {
    loadAllCredential();
  }

  void resetCredential() async {
    prefs ??= await SharedPreferences.getInstance();
    prefs?.clear();
    window.open(window.location.origin, "_self");
  }

  void loadAllCredential() async {
    prefs ??= await SharedPreferences.getInstance();
    token ??= prefs?.getString(Constant.jiraToken);
    cloudId ??= prefs?.getString(Constant.cloudId);
  }

  @override
  Future<Map<String, dynamic>?> getTasks({
    required String projectCode,
    required int startAt,
    int maxResult = 100,
    List<String> statuses = const [],
  }) async {
    loadAllCredential();

    String statusQuery = "";
    bool isFirst = true;

    for (String status in statuses) {
      statusQuery += "${!isFirst ? " or " : ""}status=\"$status\"";
      isFirst = false;
    }

    statusQuery = Uri.encodeComponent(statusQuery);

    Uri url = Uri.parse(
      "https://api.atlassian.com/ex/jira/$cloudId/rest/api/3/search?maxResults=$maxResult&startAt=$startAt&jql=project=\"$projectCode\"${statusQuery.isNotEmpty ? " and ($statusQuery)" : ""}",
    );

    try {
      http.Response response = await ApiClient.client.get(
        url,
        headers: {'Authorization': "Bearer $token"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        resetCredential();
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    return null;
  }

  @override
  Future<List<StatusData>?> getStatuses() async {
    loadAllCredential();

    try {
      http.Response response = await ApiClient.client.get(
        Uri.parse(
          "https://api.atlassian.com/ex/jira/$cloudId/rest/api/3/status",
        ),
        headers: {'Authorization': "Bearer $token"},
      );

      if (response.statusCode == 200) {
        return statusResponseFromJson(response.body);
      } else if (response.statusCode == 401) {
        resetCredential();
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    return null;
  }

  @override
  Future<JiraProjectResponse?> getJiraProjects({
    required int startAt,
    int maxResult = 50,
  }) async {
    loadAllCredential();

    try {
      http.Response response = await ApiClient.client.get(
        Uri.parse(
          "https://api.atlassian.com/ex/jira/$cloudId/rest/api/3/project/search?maxResults=$maxResult&startAt=$startAt",
        ),
        headers: {'Authorization': "Bearer $token"},
      );

      if (response.statusCode == 200) {
        return JiraProjectResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        resetCredential();
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    return null;
  }

  @override
  Future<TokenResponse?> getToken({
    required String code,
    required String redirectUrl,
  }) async {
    try {
      http.Response response = await ApiClient.client.post(
        Uri.parse(
          "https://auth.atlassian.com/oauth/token",
        ),
        body: {
          "grant_type": "authorization_code",
          "client_id": Constant.jiraClientId,
          "client_secret": Constant.jiraSecret,
          "code": code,
          "redirect_uri": redirectUrl,
        },
      );

      if (response.statusCode == 200) {
        return tokenResponseFromJson(response.body);
      } else if (response.statusCode == 401) {
        resetCredential();
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    return null;
  }

  @override
  Future<List<Company>?> getCompanies() async {
    loadAllCredential();

    prefs ??= await SharedPreferences.getInstance();
    token = prefs?.getString(Constant.jiraToken);

    try {
      http.Response response = await ApiClient.client.get(
        Uri.parse(
          "https://api.atlassian.com/oauth/token/accessible-resources",
        ),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        return companyResponseFromJson(response.body);
      } else if (response.statusCode == 401) {
        resetCredential();
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    return null;
  }
}
