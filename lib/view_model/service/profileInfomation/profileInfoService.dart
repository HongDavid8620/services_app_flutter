import 'dart:convert';
import 'package:cotafer_server_status/view_model/service/profileInfomation/profileInfoRespone.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static Future requestProfileInfo() async {
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

    Map<String, dynamic> requestBody = {"login_token": "$loginToken"};
    
    var url = Uri.parse('http://192.168.10.14:7071/profile');
    var profileInfoRespone = ProfileInfoRespone();

    try {
      var respone = await http.post(url, body: jsonEncode(requestBody), headers: requestHeader);
      // print('http request : ${respone.statusCode}');
      // print('${respone.body}');
      if (respone.statusCode == 200) {
        print('Profile Got Infomation');
        profileInfoRespone = profileResponeFromJson(respone.body);
        return profileInfoRespone.data;
      }
    } catch (e) {
      print('error service : $e');
      return '';
    }
  }

  static getProfileInfo() async {
    var profileInfo = await requestProfileInfo();
    if (profileInfo != '' && profileInfo != null) {
      return profileInfo;
    } else
      return 'error';
  }
}
