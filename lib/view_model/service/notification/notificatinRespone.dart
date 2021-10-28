import 'dart:convert';

NotificationRespone notificationResponeFromJson(String str) => NotificationRespone.fromJson(json.decode(str));

class NotificationRespone {
  NotificationRespone({
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

  factory NotificationRespone.fromJson(Map<String, dynamic> json) => NotificationRespone(
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
    this.list,
  });

  List<ListNotification>? list;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: List<ListNotification>.from(json["list"].map((x) => ListNotification.fromJson(x))),
      );
}

class ListNotification {
  ListNotification({
    this.datetime,
    this.serverName,
    this.serviceName,
    this.status,
  });

  String? datetime;
  String? serverName;
  String? serviceName;
  String? status;

  factory ListNotification.fromJson(Map<String, dynamic> json) => ListNotification(
        datetime    : json["datetime"],
        serverName  : json["server_name"],
        serviceName : json["service_name"],
        status      : json["status"],
      );

}
