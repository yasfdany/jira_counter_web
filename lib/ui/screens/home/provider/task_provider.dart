import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jira_counter/data/network/entity/sprint_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../../config/constant.dart';
import '../../../../data/model/story_point_data.dart';
import '../../../../data/network/entity/status_response.dart';
import '../../../../data/network/services/remote_task_service.dart';
import 'project_provider.dart';

final taskProvider = ChangeNotifierProvider<TaskProvider>(
  (ref) {
    final provider = ref.read(projectProvider);
    return TaskProvider(provider);
  },
);

class TaskProvider extends ChangeNotifier {
  final priority = {
    "Highest": 5,
    "High": 4,
    "Medium": 3,
    "Low": 2,
    "Lowest": 1,
  };
  final RemoteTaskService remoteTaskService = RemoteTaskService();
  final List<Map<String, dynamic>> filteredIssue = [];
  final List<Map<String, dynamic>> issues = [];
  final List<String> statuses = [];
  final List<String> selectedStatus = [];
  final List<StroyPointData> totalStoryPoint = [];
  final List<Sprint> sprints = [];

  SharedPreferences? _prefs;

  bool onlySubtask = true;
  bool loading = true;
  int startAt = 0;
  int total = 0;
  String? selectedAccountId;
  Sprint? selectedSprint;

  late ProjectProvider projectProvider;

  TaskProvider(this.projectProvider);

  void toggleOnlySubtask() async {
    _prefs ??= await SharedPreferences.getInstance();
    _prefs?.setBool(Constant.onlySubtask, !onlySubtask);
    onlySubtask = !onlySubtask;
    notifyListeners();
  }

  Future loadOnlySubtask() async {
    _prefs ??= await SharedPreferences.getInstance();
    onlySubtask = _prefs?.getBool(Constant.onlySubtask) ?? true;
    notifyListeners();
  }

  void reset() {
    filteredIssue.clear();
    selectedStatus.clear();
    totalStoryPoint.clear();
    selectedAccountId = null;
    notifyListeners();
  }

  void clearSelectedTask() {
    selectedAccountId = null;
    filteredIssue.clear();
    notifyListeners();
  }

  void doFilterIssueByAssignee(String selectedAccountId) {
    this.selectedAccountId = selectedAccountId;
    filteredIssue.clear();
    for (Map<String, dynamic> issue in issues) {
      final bool isSubTask = issue["fields"]?["issuetype"]?["subtask"] ?? false;
      final String accountId =
          (issue["fields"]?["assignee"]?["accountId"] ?? "");

      if (onlySubtask ? isSubTask : true) {
        if (selectedAccountId == accountId) {
          filteredIssue.add(issue);
        }
      }
    }
    filteredIssue.sort(
      (a, b) => priority[b["fields"]?["priority"]?["name"]]!.compareTo(
        priority[a["fields"]?["priority"]?["name"]]!,
      ),
    );
    notifyListeners();
  }

  void addStatusFilter(String title) async {
    _prefs ??= await SharedPreferences.getInstance();

    if (selectedStatus.contains(title)) {
      selectedStatus.removeWhere((element) => element == title);
    } else {
      selectedStatus.add(title);
    }
    notifyListeners();

    _prefs?.setStringList(Constant.filterStatus, selectedStatus);
  }

  void removeStatusFilter(String title) async {
    _prefs ??= await SharedPreferences.getInstance();

    if (selectedStatus.contains(title)) {
      selectedStatus.remove(title);
      _prefs?.setStringList(Constant.filterStatus, selectedStatus);
      countStoryPoint();
      notifyListeners();
    }
  }

  void clearSprint() async {
    _prefs ??= await SharedPreferences.getInstance();
    _prefs?.remove(Constant.jiraSprint);
    _prefs?.remove(Constant.selectedSprint);
    sprints.clear();
    selectedSprint = null;
    notifyListeners();
  }

  Future loadSprint() async {
    _prefs ??= await SharedPreferences.getInstance();
    final List<String> jsonSprint =
        _prefs?.getStringList(Constant.jiraSprint) ?? [];
    final List<Sprint> allSprint = [];
    for (String json in jsonSprint) {
      allSprint.add(Sprint.fromJson(jsonDecode(json)));
    }

    sprints.clear();
    for (Sprint sprint in allSprint) {
      sprints.add(sprint);
    }

    final jsonString = _prefs?.getString(Constant.selectedSprint);
    if (jsonString != null) {
      selectedSprint = Sprint.fromJson(jsonDecode(jsonString));
    }
    notifyListeners();
  }

  void saveSprint() async {
    _prefs ??= await SharedPreferences.getInstance();
    final List<String> jsonSprint = [];

    for (Sprint sprint in sprints) {
      jsonSprint.add(jsonEncode(sprint.toJson()));
    }
    _prefs?.setStringList(Constant.jiraSprint, jsonSprint);
  }

  Future getSprints() async {
    loadSprint();
    _prefs ??= await SharedPreferences.getInstance();

    final boardData = await remoteTaskService.getBoards(
      projectProvider.selectedProject!.key!,
    );
    if (boardData?.isNotEmpty ?? false) {
      final sprintData =
          await remoteTaskService.getSprints("${boardData?.first.id}");
      sprints.clear();
      sprints.addAll(sprintData?.reversed.toList() ?? []);
      saveSprint();
      notifyListeners();
    }
  }

  void selectSprint(Sprint sprint) {
    selectedSprint = sprint;
    _prefs?.setString(
      Constant.selectedSprint,
      jsonEncode(selectedSprint?.toJson()),
    );
    notifyListeners();

    getSprints();
    clearSelectedTask();
    getIssues(reset: true);
  }

  Future getStatuses({
    bool reset = false,
  }) async {
    loadStatuses();
    _prefs ??= await SharedPreferences.getInstance();
    statuses.clear();

    if (reset) {
      selectedStatus.clear();
      _prefs?.remove(Constant.filterStatus);
    } else {
      selectedStatus.addAll(_prefs?.getStringList(Constant.filterStatus) ?? []);
    }

    final data = await remoteTaskService.getStatuses();
    saveStatuses(data ?? []);

    for (StatusData status in data ?? []) {
      if (status.name.isNotNull &&
          !statuses.contains(status.name!.toUpperCase()) &&
          status.scope?.project?.id == projectProvider.selectedProject?.id) {
        statuses.add(status.name!.toUpperCase());
      }
    }
    notifyListeners();
  }

  Future loadStatuses() async {
    _prefs ??= await SharedPreferences.getInstance();
    final List<String> jsonStatuses =
        _prefs?.getStringList(Constant.jiraIssueStatuses) ?? [];
    final List<StatusData> allStatuses = [];
    for (String json in jsonStatuses) {
      allStatuses.add(StatusData.fromJson(jsonDecode(json)));
    }

    statuses.clear();
    for (StatusData status in allStatuses) {
      if (status.name.isNotNull &&
          !statuses.contains(status.name!.toUpperCase()) &&
          status.scope?.project?.id == projectProvider.selectedProject?.id) {
        statuses.add(status.name!.toUpperCase());
      }
    }
    selectedStatus.clear();
    selectedStatus.addAll(_prefs?.getStringList(Constant.filterStatus) ?? []);
    notifyListeners();
  }

  void saveStatuses(List<StatusData> statuses) async {
    _prefs ??= await SharedPreferences.getInstance();
    final List<String> jsonStatuses = [];

    for (StatusData status in statuses) {
      jsonStatuses.add(jsonEncode(status.toJson()));
    }
    _prefs?.setStringList(Constant.jiraIssueStatuses, jsonStatuses);
  }

  Future getIssues({bool reset = false}) async {
    if (!projectProvider.selectedProject.isNotNull) {
      return;
    }

    if (reset) {
      totalStoryPoint.clear();
      issues.clear();
      startAt = 0;
      loading = true;
      notifyListeners();
    }

    if (selectedStatus.isEmpty) {
      loading = false;
      notifyListeners();
      return;
    }

    final json = await remoteTaskService.getTasks(
      projectCode: projectProvider.selectedProject!.key!,
      startAt: startAt,
      statuses: selectedStatus,
    );

    if (json.isNotNull) {
      total = json?["total"];
      for (dynamic issue in json?["issues"]) {
        final sprintNames = [];
        for (dynamic data in issue["fields"]?["customfield_10020"] ?? []) {
          sprintNames.add(data["name"]);
        }

        if (selectedSprint != null
            ? sprintNames.contains(selectedSprint?.name)
            : true) {
          issues.add(Map<String, dynamic>.from(issue));
        }
      }

      if (startAt < total) {
        startAt += 100;
        getIssues();
      } else {
        loading = false;
      }

      countStoryPoint();
      if (selectedAccountId.isNotNull) {
        doFilterIssueByAssignee(selectedAccountId!);
      }
    } else {
      loading = false;
      notifyListeners();
    }
  }

  void countStoryPoint() {
    final Map<String, StroyPointData> dataContainer = {};

    totalStoryPoint.clear();
    for (Map<String, dynamic> issue in issues) {
      final bool isSubTask = issue["fields"]?["issuetype"]?["subtask"] ?? false;
      final String assigneeName =
          (issue["fields"]?["assignee"]?["displayName"] ?? "");
      final String accountId =
          (issue["fields"]?["assignee"]?["accountId"] ?? "");
      final double storyPoint = (issue["fields"]?["customfield_10016"] ?? 0);

      if (onlySubtask ? isSubTask : true) {
        if (assigneeName.isNotEmpty) {
          if (dataContainer.containsKey(accountId)) {
            dataContainer[accountId]?.point += storyPoint;
          } else {
            dataContainer[accountId] = StroyPointData(
              accountId: accountId,
              name: assigneeName,
              point: storyPoint,
            );
          }
        }
      }
    }
    totalStoryPoint.addAll(dataContainer.values);
    notifyListeners();
  }
}
