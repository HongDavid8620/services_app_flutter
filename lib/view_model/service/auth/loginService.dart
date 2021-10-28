import 'dart:convert';
import 'package:cotafer_server_status/view_model/service/accessRespone.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class LoginService {
  static Future requestLogin(emailaddress, passwd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var _username = sha256.convert(utf8.encode(emailaddress)).toString();
    var _password = sha256.convert(utf8.encode(passwd)).toString();
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

    Map<String, dynamic> requestBody = {"country_code": 855, "username": "ctf0001", "password": "$_password"};
    var url = Uri.parse('http://192.168.10.14:7071/login');
    var loginRespone = AccessRespone();

    try {
      var respone = await http.post(url, body: jsonEncode(requestBody), headers: requestHeader);
      // print('http request : ${respone.statusCode}');
      // print('${respone.body}');
      if (respone.statusCode == 200) {
        print('User Logined');
        loginRespone = accessResponeFromJson(respone.body);
        prefs.setString('login_token', loginRespone.data!.authToken.toString());
        // final expirationDate = loginRespone.data!.expiredDatetime;
        // final bool isExpired = expirationDate!.isBefore(now);
        print('date: ${loginRespone.data!.expiredDatetime}');
        prefs.setInt('expired_date', loginRespone.data!.expiredDatetime!.millisecondsSinceEpoch);

        return loginRespone.data!.authToken;
      }
    } catch (e) {
      print('error service : $e');
      return '';
    }
  }

  static getAuthorizeToken(emailaddress, passwd) async {
    var token = await requestLogin(emailaddress, passwd);
    if (token != '' && token != null) {
      return token;
      // print('token : Bearer ${prefs.getString('token')}');
    } else
      return null;
  }
}
