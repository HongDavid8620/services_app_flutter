import 'dart:convert';
import 'package:services_flutter/view_model/service/accessRespone.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangeProfileService {
  static Future requestChangeProfile(firstName, lastName, email, phoneNumber, photo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var loginToken = prefs.getString('login_token');

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
      "login_token": "$loginToken",
      "first_name": "aa",
      "last_name": "ee",
      "email": "ffas@mail.com",
      "phone_number": "12333333",
      "photo": "sf"
    };

    var url = Uri.parse('http://192.168.10.14:7071/profile/update');
    var changeProfileRespone = AccessRespone();

    try {
      var respone = await http.post(url, body: jsonEncode(requestBody), headers: requestHeader);
      // print('http request : ${respone.statusCode}');
      // print('${respone.body}');
      if (respone.statusCode == 200) {
        print('Profile Updated Infomation');
        changeProfileRespone = accessResponeFromJson(respone.body);
        return changeProfileRespone.status;
      }
    } catch (e) {
      print('error service : $e');
      return '';
    }
  }

  static changeProfileInfo({firstName, lastName, email, phoneNumber, photo}) async {
    var profileInfo = await requestChangeProfile(firstName, lastName, email, phoneNumber, photo);
    if (profileInfo != '' && profileInfo != null) {
      return profileInfo;
    } else
      return 'error';
  }
}
