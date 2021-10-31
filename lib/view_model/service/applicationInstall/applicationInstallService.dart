import 'dart:convert';
import 'package:services_flutter/view_model/service/accessRespone.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InstallService {
  static Future installApp() async {
    Map<String, String> requestHeader = {
      "Authorizations": "Bearer 56442dcdc04141245d44b224fde5a2b49922d419cc9e1828f53fcfc9b2a4ae44",
      "Client-Id": "ie98djowue1af8624e3769c2d51bf3s4ewt",
      "Device-Id": "HUAWEI G620-L72 (G620-L72)",
      "Os": "android",
      "Installed-Id": "",
      "Country-Info": '{}',
      "Language-Code": "en",
      "Content-Type": "application/json",
      "Region-Name": "Asia/Phnom_Penh"
    };

    var url = Uri.parse('http://192.168.10.14:7071/app/installation');
    var installRespone = AccessRespone();
    try {
      var respone = await http.post(url, body: jsonEncode({}), headers: requestHeader)
      .timeout(Duration(seconds: 10),onTimeout: ()=> http.Response('error',500)); // for time out
      // print('http request : ${respone.statusCode}');
      // print('${respone.body}');
      if (respone.statusCode == 200) {
        installRespone = accessResponeFromJson(respone.body);
        print('app installed');
        return installRespone.data!.token;
      } else {
        print('app install unsuccesful');
        return 'error';
      }
    } catch (e) {
      print('error service : $e');
      return '';
    }
  }

  static getAuthorizeToken() async {
    String token = await installApp();
    if (token != '') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      return token;
      // print('token : Bearer ${prefs.getString('token')}');
    } else
      return 'error';
  }
}
