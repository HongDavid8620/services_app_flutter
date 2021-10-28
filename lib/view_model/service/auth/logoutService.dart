import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LogoutService {
  static Future requestLogout() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var loginToken = prefs.getString('login_token');

    Map<String, String> requestHeader = {
      "Token": "Bearer $token",
      "Client-Id": "ie98djowue1af8624e3769c2d51bf3s4ewt",
      "Device-Id": "HUAWEI G620-L72 (G620-L72)",
      "Os": "android",
      "Installed-Id": "",
      "Country-Info": "{}",
      "Language-Code": "en",
      "Content-Type": "application/json",
      "Region-Name": "Asia/Phnom_Penh"
    };

    Map<String, dynamic> requestBody = {
      "login_token": "$loginToken"
    };

    var url = Uri.parse('http://192.168.10.14:7071/logout');
    try {
      var respone = await http.post(url, body: jsonEncode(requestBody), headers: requestHeader);
      // print('http request : ${respone.statusCode}');
      // print('${respone.body}');
      if (respone.statusCode == 200) 
      {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('login_token', '');
        print('User Logout');   
        return loginToken;     
        
      }
    } catch (e) {
      print('error service : $e');
      return '';
    }
  }
  static getAuthorizeToken() async {
    var token = await requestLogout();
    if (token != '' && token != null) {
      return token;
      // print('token : Bearer ${prefs.getString('token')}');
    } else
      return null;
  }
}
