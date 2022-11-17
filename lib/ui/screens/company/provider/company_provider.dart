import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jira_counter/config/constant.dart';
import 'package:jira_counter/data/network/entity/company.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../../data/network/services/remote_task_service.dart';

final companyProvider = ChangeNotifierProvider<CompanyProvider>(
  (ref) => CompanyProvider(),
);

class CompanyProvider extends ChangeNotifier {
  final RemoteTaskService remoteTaskService = RemoteTaskService();
  final List<Company> companies = [];
  SharedPreferences? prefs;
  Company? selectedCompany;

  CompanyProvider() {
    loadSelectedCompany();
    getCompanies();
  }

  Future loadSelectedCompany() async {
    prefs ??= await SharedPreferences.getInstance();
    String? jsonCompany = prefs?.getString(Constant.selectedCompany);
    if (jsonCompany.isNotNull) {
      selectedCompany = Company.fromJson(jsonDecode(jsonCompany!));
      notifyListeners();
    }
  }

  Future selectCompany(Company company) async {
    prefs ??= await SharedPreferences.getInstance();
    selectedCompany = company;
    notifyListeners();

    prefs?.setString(Constant.selectedCompany, jsonEncode(company.toJson()));
    prefs?.setString(Constant.cloudId, company.id!);
  }

  Future getCompanies() async {
    final fetchCompanies = await remoteTaskService.getCompanies() ?? [];
    companies.addAll(fetchCompanies);
    notifyListeners();
  }
}
