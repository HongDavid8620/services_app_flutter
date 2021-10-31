import 'dart:convert';
import 'package:services_flutter/view_model/service/accessRespone.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class ChangePasswordService {
  static Future _requestChangePassword(oldpassword,newpassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var _oldpassword = sha256.convert(utf8.encode(oldpassword)).toString();
    var _newpassword = sha256.convert(utf8.encode(newpassword)).toString();
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

    Map<String, dynamic> requestBody = {
      "login_token" : "$loginToken",
      "old_password": "$_oldpassword",
      "new_password": "$_newpassword"
    };
    var url = Uri.parse('http://192.168.10.14:7071/setting/password/change');
    var changeRespone = AccessRespone();

    try {
      var respone = await http.post(url, body: jsonEncode(requestBody), headers: requestHeader);
      // print('http request : ${respone.statusCode}');
      // print('${respone.body}');
      if (respone.statusCode == 200) {
        print('changed password');
        changeRespone = accessResponeFromJson(respone.body);
        return changeRespone.errorMessage;
      }
    } catch (e) {
      print('error service : $e');
      return '';
    }
  }

  static changePassword({oldpassword, newpassword}) async {
    var data = await _requestChangePassword(oldpassword, newpassword);
    if (data != '' && data != null) {
      return data;
    } else
      return 'error';
  }
}
