import 'package:cotafer_server_status/view/screen/setting/changePassword.dart';
import 'package:cotafer_server_status/view/screen/setting/notificationSetting.dart';
import 'package:cotafer_server_status/view_model/bloc/textField_bloc/textField_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TextFieldBloc>(
          create: (BuildContext context) => TextFieldBloc(), 
          child : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 35, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title  : Text('Settings'),
              centerTitle: true,
            ),
            body: Container(
              padding : EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              child   : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => NotificationSetting()));
                    },
                    child: Container(
                      padding : EdgeInsets.only(left: 5),
                      height  : 40,
                      width   : MediaQuery.of(context).size.width - 20,
                      child   : Align(
                        alignment : Alignment.centerLeft,
                        child     : Text(
                          'Notification',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => ChangePassword()));
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 5),
                      height : 40,
                      width  : MediaQuery.of(context).size.width - 20,
                      child  : Align(
                        alignment: Alignment.centerLeft,
                        child    : Text(
                          'Change password',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    ));
  }
}
