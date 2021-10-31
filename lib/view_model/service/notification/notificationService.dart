import 'dart:convert';
import 'package:services_flutter/view_model/service/notification/notificatinRespone.dart';
import 'package:services_flutter/view_model/service/statusDashboard/statusRespone.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static Future requestNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var loginToken = prefs.getString('login_token');

    // print('token : Bearer $token');

    Map<String, String> requestHeader = {
      "Token"         : "Bearer $token",
      "Client-Id"     : "ie98djowue1af8624e3769c2d51bf3s4ewt",
      "Device-Id"     : "HUAWEI G620-L72 (G620-L72)",
      "Os"            : "android",
      "Installed-Id"  : "",
      "Country-Info"  : "{}",
      "Language-Code" : "en",
      "Content-Type"  : "application/json",
      "Region-Name"   : "Asia/Phnom_Penh"
    };

    Map<String, dynamic> requestBody = {"login_token": "$loginToken"};
    
    var url = Uri.parse('http://192.168.10.14:7071/notification');
    var notifacationRespone = NotificationRespone();

    try {
      var respone = await http.post(url, body: jsonEncode(requestBody), headers: requestHeader);
      // print('http request : ${respone.statusCode}');
      // print('${respone.body}');
      if (respone.statusCode == 200) {
        print('got Notification list');
        notifacationRespone = notificationResponeFromJson(respone.body);
        return notifacationRespone.data!.list;
      }
    } catch (e) {
      print('error service : $e');
      return '';
    }
  }

  static getNotification() async {
    var listNotification = await requestNotification();
    if (listNotification != '' && listNotification != null) {
      return listNotification;
    } else
      return null;
  }
}
