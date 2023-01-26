// To parse this JSON data, do
//
//     final sprintResponse = sprintResponseFromJson(jsonString);

import 'dart:convert';

SprintResponse sprintResponseFromJson(String str) =>
    SprintResponse.fromJson(json.decode(str));

String sprintResponseToJson(SprintResponse data) => json.encode(data.toJson());

class SprintResponse {
  SprintResponse({
    this.maxResults,
    this.startAt,
    this.total,
    this.isLast,
    this.values,
  });

  int? maxResults;
  int? startAt;
  int? total;
  bool? isLast;
  List<Sprint>? values;

  factory SprintResponse.fromJson(Map<String, dynamic> json) => SprintResponse(
        maxResults: json["maxResults"],
        startAt: json["startAt"],
        total: json["total"],
        isLast: json["isLast"],
        values: json["values"] == null
            ? []
            : List<Sprint>.from(json["values"]!.map((x) => Sprint.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "maxResults": maxResults,
        "startAt": startAt,
        "total": total,
        "isLast": isLast,
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class Sprint {
  Sprint({
    this.id,
    this.self,
    this.state,
    this.name,
    this.startDate,
    this.endDate,
    this.completeDate,
    this.originBoardId,
    this.goal,
  });

  int? id;
  String? self;
  String? state;
  String? name;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? completeDate;
  int? originBoardId;
  String? goal;

  factory Sprint.fromJson(Map<String, dynamic> json) => Sprint(
        id: json["id"],
        self: json["self"],
        state: json["state"],
        name: json["name"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        completeDate: json["completeDate"] == null
            ? null
            : DateTime.parse(json["completeDate"]),
        originBoardId: json["originBoardId"],
        goal: json["goal"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "self": self,
        "state": state,
        "name": name,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "completeDate": completeDate?.toIso8601String(),
        "originBoardId": originBoardId,
        "goal": goal,
      };
}
