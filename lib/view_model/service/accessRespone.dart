import 'dart:convert';

AccessRespone accessResponeFromJson(String str) => AccessRespone.fromJson(json.decode(str));

class AccessRespone {
  AccessRespone({
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

  factory AccessRespone.fromJson(Map<String, dynamic> json) => AccessRespone(
        data        : Data.fromJson(json["data"]),
        errorMessage: json["error_message"],
        errorNumber : json["error_number"],
        logId       : json["log_id"],
        status      : json["status"],
        timestamp   : DateTime.parse(json["timestamp"]),
      );
}

class Data {
  Data({
    this.expiredDatetime ,
    this.authToken,
    this.notfication,
    this.token
  });

  DateTime? expiredDatetime;
  String? authToken;
  String? notfication;
  String? token;

  factory Data.fromJson(Map<String, dynamic> json) {
    if (json["expired_datetime"] != null) {
      return Data(
        expiredDatetime: DateTime.parse((json["expired_datetime"])),
        authToken: json["login_token"]
      );
    } else if (json["notfication"] != null) {
      return Data(
        notfication: json["notfication"]
      );
    } else if(json["token"] != null){
      return Data(
        token: json["token"]
        );
    }   
     else {
      return Data();
    }
  }
}
