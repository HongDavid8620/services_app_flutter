import 'package:services_flutter/view/screen/dashboard/notification.dart';
import 'package:services_flutter/view/widget/customDrawer.dart';
import 'package:services_flutter/view/widget/serverApiStatus.dart';
import 'package:services_flutter/view/widget/serviceListName.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//mainpage for wrapping (all post, Suspicous post, report post)

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  var _selectedpage = 0;
  int _selectedMenu = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedpage = index;
      print(_selectedpage);
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.transparent
    //         //color set to transperent or set your own color
    //         ));
    return Scaffold(
      drawer: CustomeDrawer(selectedMenu: _selectedMenu),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.black,
            iconSize: 33,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NotificationPage()));
            },
          ),
        ],
      ),

      body:  SingleChildScrollView(
        physics : BouncingScrollPhysics(),
        child   : Container(
          padding : EdgeInsets.all(10),
          child   : Column(
            children: [
              //Status info
              Container(
                decoration: BoxDecoration(
                  color     : Colors.white,
                  boxShadow : [
                    BoxShadow(
                      color       : Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius  : 7,
                      offset      : Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding : const EdgeInsets.all(10),
                      child   : Column(                        
                        children: [
                          ApiStatus(
                            text    : 'Live',
                            quantity: 1,
                            color   : Colors.green[500],
                          ),
                          ApiStatus(
                            text    : 'Disable',
                            quantity: 3,
                            color   : Colors.black54,
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                    Column(
                      children: [
                        ApiStatus(
                          text    : 'Went wrong',
                          quantity: 0,
                          color   : Colors.yellow[500],
                        ),
                        ApiStatus(
                          text    : 'Down',
                          quantity: 2,
                          color   : Colors.red[500],
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,                      
                    )
                  ],
                ),
              ),

              //Refresh and Sort Icon
              Padding(
                padding : const EdgeInsets.symmetric(vertical: 8),
                child   : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding : const EdgeInsets.symmetric(horizontal: 10),
                      child   : Icon(
                        Icons.sync,
                        size: 30,
                      ),
                    ),
                    Padding(
                        padding : const EdgeInsets.symmetric(horizontal: 0),
                        child   : PopupMenuButton(
                            icon  : Icon(
                              Icons.sort,
                              size: 30,
                            ),
                            offset      : Offset(0, 50),
                            shape       : RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15.0))),
                            itemBuilder : (context) => [
                                  PopupMenuItem(
                                    height: 30,
                                    value : 1,
                                    child : Container(
                                      child: Text(
                                        "Live",
                                        style: TextStyle(
                                            color     : Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    height: 30,
                                    value : 2,
                                    child : Container(
                                      child: Text(
                                        "Disable",
                                        style: TextStyle(
                                            color     : Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    height: 30,
                                    value : 2,
                                    child : Container(
                                      child: Text(
                                        "Went wrong",
                                        style: TextStyle(
                                            color     : Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    height: 30,
                                    value : 2,
                                    child : Container(
                                      child: Text(
                                        "Down",
                                        style: TextStyle(
                                            color     : Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                ]))
                  ],
                ),
              ),

              //List of Service
              SerivceListName(
                serviceName : 'Service Name',
                serverName  : 'Server Name',
                serverStatus: 'Server Status',
                statusColor : Colors.greenAccent[400],
              ),
              SerivceListName(
                serviceName : 'Service Name',
                serverName  : 'Server Name',
                serverStatus: 'Server Status',
                statusColor : Colors.yellow[500],
              ),
              SerivceListName(
                serviceName : 'Service Name',
                serverName  : 'Server Name',
                serverStatus: 'Server Status',
                statusColor : Colors.red[500],
              ),
              SerivceListName(
                statusColor : Colors.black54,
              ),
            ],
          ),
        ),
      ),
      // IndexedStack(
      //   index: _selectedpage,
      //   children: [],
      // ),
      bottomNavigationBar: BottomNavigationBar(
        type         : BottomNavigationBarType.fixed,
        currentIndex : _selectedpage,
        onTap        : _onItemTapped,

        selectedItemColor : Colors.indigo,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.article,
              size: 33,
            ),
            label: 'API',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wysiwyg, size: 33),
            label: 'Website',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud, size: 33),
            label: 'Application',
          ),
        ],
      ),
    );
  }
}
