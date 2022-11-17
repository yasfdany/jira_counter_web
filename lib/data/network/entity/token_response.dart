// To parse this JSON data, do
//
//     final tokenResponse = tokenResponseFromJson(jsonString);

import 'dart:convert';

TokenResponse tokenResponseFromJson(String str) =>
    TokenResponse.fromJson(json.decode(str));

String tokenResponseToJson(TokenResponse data) => json.encode(data.toJson());

class TokenResponse {
  TokenResponse({
    this.accessToken,
    this.expiresIn,
    this.scope,
  });

  String? accessToken;
  int? expiresIn;
  String? scope;

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
        accessToken: json["access_token"],
        expiresIn: json["expires_in"],
        scope: json["scope"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "expires_in": expiresIn,
        "scope": scope,
      };
}
