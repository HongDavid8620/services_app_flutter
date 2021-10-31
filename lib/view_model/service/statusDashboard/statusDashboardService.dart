import 'dart:convert';
import 'package:services_flutter/view_model/service/statusDashboard/statusRespone.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  static Future requestDashboardStatus(status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

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

    Map<String, dynamic> requestBody = {"login_token": "d38f685f01cae6200ae3b24b9b1798d6", "status": "live"};
    var url = Uri.parse('http://192.168.10.14:7071/dashboard');
    var dashboardRespone = DashboardRespone();

    try {
      var respone = await http.post(url, body: jsonEncode(requestBody), headers: requestHeader)
          .timeout(Duration(seconds: 10), onTimeout: () => http.Response('error', 500)); 
      // print('http request : ${respone.statusCode}');
      // print('${respone.body}');
      if (respone.statusCode == 200) {
        print('Dashboard Got Status');
        dashboardRespone = dashboardResponeFromJson(respone.body);
        return dashboardRespone.data!.list;
      }else {
        print('get dashboard unsuccesful');
        return 'error';
        }
    } catch (e) {
      print('error service : $e');
      return '';
    }
  }

  static getDashboardStatus(status) async {
    var statuses = await requestDashboardStatus(status);
    if (statuses != '' && statuses != null) {
      return statuses;
    } else
      return 'error';
  }
}
