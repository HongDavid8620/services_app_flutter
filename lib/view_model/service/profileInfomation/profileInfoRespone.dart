import 'dart:convert';

ProfileInfoRespone profileResponeFromJson(String str) => ProfileInfoRespone.fromJson(json.decode(str));

class ProfileInfoRespone {
  ProfileInfoRespone({
    this.data,
    this.errorMessage,
    this.errorNumber,
    this.logId,
    this.status,
    this.timestamp,
  });

  ProfileData? data;
  String? errorMessage;
  int? errorNumber;
  String? logId;
  String? status;
  DateTime? timestamp;

  factory ProfileInfoRespone.fromJson(Map<String, dynamic> json) => ProfileInfoRespone(
        data        : ProfileData.fromJson(json["data"]),
        errorMessage: json["error_message"],
        errorNumber : json["error_number"],
        logId       : json["log_id"],
        status      : json["status"],
        timestamp   : DateTime.parse(json["timestamp"]),
      );
}

class ProfileData {
  ProfileData({
    this.email,
    this.firstName,
    this.lastName,
    this.phoneCode,
    this.phoneNumber,
    this.photo,
  });

  String? email;
  String? firstName;
  String? lastName;
  String? phoneCode;
  String? phoneNumber;
  String? photo;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        email       : json["email"],
        firstName   : json["first_name"],
        lastName    : json["last_name"],
        phoneCode   : json["phone_code"],
        phoneNumber : json["phone_number"],
        photo       : json["photo"],
      );
}
