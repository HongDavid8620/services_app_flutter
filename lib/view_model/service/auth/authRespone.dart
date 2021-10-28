import 'dart:convert';

AuthRespone authResponeFromJson(String str) => AuthRespone.fromJson(json.decode(str));

String authResponeToJson(AuthRespone data) => json.encode(data.toJson());

class AuthRespone {
  AuthRespone({
    this.data,
    this.errorMessage,
    this.errorNumber,
    this.logId,
    this.status,
    this.timestamp,
  });

  Data? data;
  String? errorMessage;
  int? errorNumber;
  String? logId;
  String? status;
  DateTime? timestamp;

  factory AuthRespone.fromJson(Map<String, dynamic> json) => AuthRespone(
        data: Data.fromJson(json["data"]),
        errorMessage: json["error_message"],
        errorNumber: json["error_number"],
        logId: json["log_id"],
        status: json["status"],
        timestamp: DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
        "error_message": errorMessage,
        "error_number": errorNumber,
        "log_id": logId,
        "status": status,
        "timestamp": timestamp!.toIso8601String(),
      };
}

class Data {
  Data({
    this.expiredDatetime,
    this.authToken,
  });

  DateTime? expiredDatetime;
  String? authToken;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        expiredDatetime: DateTime.parse(json["expired_datetime"]),
        authToken: json["login_token"],
      );

  Map<String, dynamic> toJson() => {
        "expired_datetime": expiredDatetime!.toIso8601String(),
        "login_token": authToken,
      };
}
