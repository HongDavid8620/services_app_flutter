import 'package:cotafer_server_status/view/screen/dashboard/dashboard.dart';
import 'package:cotafer_server_status/view/screen/profile/profilePage.dart';
import 'package:cotafer_server_status/view/screen/setting/settingPage.dart';
import 'package:cotafer_server_status/view/screen/signIn/signIn.dart';
import 'package:cotafer_server_status/view/screen/signIn/signWrapper.dart';
import 'package:cotafer_server_status/view/widget/DrawerList.dart';
import 'package:cotafer_server_status/view_model/service/auth/logoutService.dart';
import 'package:flutter/material.dart';

class CustomeDrawer extends StatelessWidget {
  const CustomeDrawer({
    Key? key,
    required int selectedMenu,
  })  : _selectedMenu = selectedMenu,
        super(key: key);

  final int _selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo[800],
      width: 250,
      child: ListView(
        padding : EdgeInsets.zero,
        children: [
          //drawer header (active user)
          Container(
            height: 180,
            child : DrawerHeader(
              child: Stack(
                children: [
                  Positioned(
                      top   : -10,
                      right : -10,
                      child : IconButton(
                        icon  : Icon(
                          Icons.west,
                          size  : 30,
                          color : Colors.white,
                        ),
                        onPressed: () {                          
                          Navigator.pop(context);
                        },
                      )),
                  Positioned(
                    bottom: 0,
                    child : Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          width : 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sasuke uchiha',
                                style: TextStyle(
                                    color     : Colors.white,
                                    fontWeight: FontWeight.normal)),
                            Text('example@cotafer.com',
                                style: TextStyle(
                                    color     : Colors.white,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          //Body of drawer
          ListDrawer(
            icon      : Icons.home_outlined,
            text      : 'Home',
            indexMenu : 0,
            
            selectedMenu: _selectedMenu,

            onTap: () async {
              await Future.delayed(Duration(milliseconds: 100));
              Navigator.pop(context);
              print(_selectedMenu);
              if (_selectedMenu != 0) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => DashBoardPage()));
              }
            },
          ),
          ListDrawer(
            icon      : Icons.library_books_outlined,
            text      : 'Profile',
            indexMenu : 1,
            
            selectedMenu: _selectedMenu,
            
            onTap: () async {
              await Future.delayed(Duration(milliseconds: 100));
              Navigator.pop(context);
              if(_selectedMenu !=1){
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
              }
            },
          ),
          ListDrawer(
            icon      : Icons.feed_outlined,
            text      : 'Settings',
            indexMenu : 2,

            selectedMenu: _selectedMenu,
            
            onTap: () async {
              await Future.delayed(Duration(milliseconds: 100));
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingPage()));
            },
          ),

          //Divider
          Padding(
            padding : const EdgeInsets.symmetric(horizontal: 10.0),
            child   : Divider(
              color: Colors.white,
            ),
          ),
          Padding(
            padding : const EdgeInsets.only(left: 5),
            child   : ListDrawer(
                icon  : Icons.logout_outlined,
                text  : 'Log Out',
                onTap : () async {
                await Future.delayed(Duration(milliseconds: 100));
                Navigator.pop(context);
                if (await LogoutService.getAuthorizeToken() != null) {
                  await Future.delayed(Duration(milliseconds: 100));
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInWrapper()));
                } else {
                  final snackBar = SnackBar(content: Text('Oh! Error!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

//Container of each drawer item
