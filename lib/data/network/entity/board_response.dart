// To parse this JSON data, do
//
//     final boardResponse = boardResponseFromJson(jsonString);

import 'dart:convert';

BoardResponse boardResponseFromJson(String str) =>
    BoardResponse.fromJson(json.decode(str));

String boardResponseToJson(BoardResponse data) => json.encode(data.toJson());

class BoardResponse {
  BoardResponse({
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
  List<Board>? values;

  factory BoardResponse.fromJson(Map<String, dynamic> json) => BoardResponse(
        maxResults: json["maxResults"],
        startAt: json["startAt"],
        total: json["total"],
        isLast: json["isLast"],
        values: json["values"] == null
            ? []
            : List<Board>.from(json["values"]!.map((x) => Board.fromJson(x))),
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

class Board {
  Board({
    this.id,
    this.self,
    this.name,
    this.type,
  });

  int? id;
  String? self;
  String? name;
  String? type;

  factory Board.fromJson(Map<String, dynamic> json) => Board(
        id: json["id"],
        self: json["self"],
        name: json["name"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "self": self,
        "name": name,
        "type": type,
      };
}
