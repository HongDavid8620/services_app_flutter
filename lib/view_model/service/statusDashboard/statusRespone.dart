import 'dart:convert';

DashboardRespone dashboardResponeFromJson(String str) => DashboardRespone.fromJson(json.decode(str));

class DashboardRespone {
  DashboardRespone({
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

  factory DashboardRespone.fromJson(Map<String, dynamic> json) => DashboardRespone(
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
    this.totalStatus,
  });

  List<ListElement>? list;
  TotalStatus? totalStatus;

  factory Data.fromJson(Map<String, dynamic> json) { 
    
    if(json["total_status"]!= null){    
    return Data(
        list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
        totalStatus: TotalStatus.fromJson(json["total_status"]),
      );
    }else{
      return Data(
        list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x)))
      );
    }
  }
}

class ListElement {
  ListElement({
    this.serverName,
    this.serviceName,
    this.status,
  });

  String? serverName;
  String? serviceName;
  String? status;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        serverName  : json["server_name"],
        serviceName : json["service_name"],
        status      : json["status"],
      );
}

class TotalStatus {
  TotalStatus({
    this.disable,
    this.down,
    this.live,
    this.wentWrong,
  });

  int? disable;
  int? down;
  int? live;
  int? wentWrong;

  factory TotalStatus.fromJson(Map<String, dynamic> json) => TotalStatus(
        disable   : json["disable"],
        down      : json["down"],
        live      : json["live"],
        wentWrong : json["went_wrong"],
      );      
}

