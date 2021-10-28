import 'dart:convert';

InstallRespone installResponeFromJson(String str) => InstallRespone.fromJson(json.decode(str));

class InstallRespone {
  InstallRespone({
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

  factory InstallRespone.fromJson(Map<String, dynamic> json) => InstallRespone(
        data: Data.fromJson(json["data"]),
        errorMessage: json["error_message"],
        errorNumber: json["error_number"],
        logId: json["log_id"],
        status: json["status"],
        timestamp: DateTime.parse(json["timestamp"]),
      );
}

class Data {
  Data({
    this.token,
  });

  String? token;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
      );
}
