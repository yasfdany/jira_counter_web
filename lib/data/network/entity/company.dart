// To parse this JSON data, do
//
//     final companyResponse = companyResponseFromJson(jsonString);

import 'dart:convert';

List<Company> companyResponseFromJson(String str) =>
    List<Company>.from(json.decode(str).map((x) => Company.fromJson(x)));

String companyResponseToJson(List<Company> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Company {
  Company({
    this.id,
    this.url,
    this.name,
    this.scopes,
    this.avatarUrl,
  });

  String? id;
  String? url;
  String? name;
  List<String>? scopes;
  String? avatarUrl;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        url: json["url"],
        name: json["name"],
        scopes: List<String>.from(json["scopes"].map((x) => x)),
        avatarUrl: json["avatarUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "name": name,
        "scopes": List<dynamic>.from(scopes?.map((x) => x) ?? []),
        "avatarUrl": avatarUrl,
      };
}
