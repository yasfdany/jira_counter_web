class Constant {
  static const jiraEmail = "JIRA_EMAIL";
  static const jiraUrl = "JIRA_URL";
  static const jiraToken = "JIRA_TOKEN";
  static const filterStatus = "FILTER_STATUS";
  static const selectedProject = "SELECTED_PROJECT";
  static const selectedSprint = "SELECTED_SPRINT";
  static const jiraProjects = "JIRA_PROJECTS";
  static const jiraIssueStatuses = "JIRA_ISSUE_STATUSES";
  static const jiraSprint = "JIRA_SPRINT";
  static const jiraClientId = String.fromEnvironment(
    "JIRA_CLIENT_ID",
    defaultValue: "",
  );
  static const jiraSecret = String.fromEnvironment(
    "JIRA_SECRET",
    defaultValue: "",
  );
  static const selectedCompany = "SELECTED_COMPANY";
  static const cloudId = "CLOUD_ID";
  static const onlySubtask = "ONLY_SUBTASK";
}
