import 'package:cotafer_server_status/view/screen/dashboard/notification.dart';
import 'package:cotafer_server_status/view/widget/customDrawer.dart';
import 'package:cotafer_server_status/view/widget/loadingPage.dart';
import 'package:cotafer_server_status/view/widget/serverApiStatus.dart';
import 'package:cotafer_server_status/view/widget/serviceListName.dart';
import 'package:cotafer_server_status/view_model/bloc/expired/tokenExpired_bloc.dart';
import 'package:cotafer_server_status/view_model/bloc/expired/tokenExpired_event.dart';
import 'package:cotafer_server_status/view_model/bloc/expired/tokenExpired_state.dart';
import 'package:cotafer_server_status/view_model/service/statusDashboard/statusDashboardService.dart';
import 'package:cotafer_server_status/view_model/service/statusDashboard/statusRespone.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//mainpage for wrapping (all post, Suspicous post, report post)

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  var _selectedpage = 0;
  int _selectedMenu = 0;
  List<ListElement> serverStatus = [];
  Future? _dashboardStatus;

  void _onItemTapped(int index) {
    setState(() {
      _selectedpage = index;
      print(_selectedpage);
    });
  }

  @override
  void initState() {
    ExpiredTokenBloc().add(ListenExpiredEvent());
    _dashboardStatus = DashboardService.getDashboardStatus('live');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpiredTokenBloc, TokenState>(builder: (context, state) {
      // return (state.tokenState == TokenStatus.TokenExpired)
      //     ? LoadingPage()
          // :
           return
           Scaffold(
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()));
                    },
                  ),
                ],
              ),

              body: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    //Status info
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                ApiStatus(
                                  text: 'Live',
                                  quantity: 1,
                                  color: Colors.green[500],
                                ),
                                ApiStatus(
                                  text: 'Disable',
                                  quantity: 3,
                                  color: Colors.black54,
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                          Column(
                            children: [
                              ApiStatus(
                                text: 'Went wrong',
                                quantity: 0,
                                color: Colors.yellow[500],
                              ),
                              ApiStatus(
                                text: 'Down',
                                quantity: 2,
                                color: Colors.red[500],
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          )
                        ],
                      ),
                    ),

                    //Refresh and Sort Icon
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.sync,
                              size: 30,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              child: PopupMenuButton(
                                onSelected: (item){                         
                                  print('sorted: $item');         
                                    _dashboardStatus = DashboardService.getDashboardStatus('$item');    
                                },
                                  icon: Icon(
                                    Icons.sort,
                                    size: 30,
                                  ),
                                  offset: Offset(0, 50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(                                                                                                                              
                                          height: 30,
                                          value: 'live',
                                          child: Container(
                                            child: Text(
                                              "Live",
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          height: 30,
                                          value: 'disable',
                                          child: Container(
                                            child: Text(
                                              "Disable",
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          height: 30,
                                          value: 'went_wrong',
                                          child: Container(
                                            child: Text(
                                              "Went wrong",
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          height: 30,
                                          value: 'down',
                                          child: Container(
                                            child: Text(
                                              "Down",
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ),
                                      ]))
                        ],
                      ),
                    ),

                    //List of Service

                    FutureBuilder(
                        future: _dashboardStatus,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != 'error') {
                            serverStatus = snapshot.data as List<ListElement>;
                          }
                          if(snapshot.hasData && snapshot.data != 'error'){
                          return Container(
                            child: Expanded(
                              child: ListView.builder(
                                  itemCount: serverStatus.length,
                                  itemBuilder: (context, index) {
                                    ListElement serviceStatus = serverStatus[index];
                                    var statusColor;
                                      
                                      if (serviceStatus.status == 'down') {
                                        statusColor = Colors.red[500];
                                      } else if (serviceStatus.status == 'live') {
                                        statusColor = Colors.greenAccent[400];
                                      } else if (serviceStatus.status == 'disable') {
                                        statusColor = Colors.black54;
                                      } else {
                                        statusColor = Colors.yellow[500];
                                      }

                                      return SerivceListName(
                                      serviceName : "${serviceStatus.serviceName}",
                                      serverName  : "${serviceStatus.serverName}",
                                      serverStatus: "${serviceStatus.status}",
                                      statusColor : statusColor,
                                    );
                                  }),
                            ),
                          );
                        }else{
                          return Container(
                            child: Expanded(
                              child: ListView.builder(
                                  itemCount: 3,
                                  itemBuilder: (context, index) {                                  
                                    return SerivceListName(
                                      statusColor: Colors.black54,
                                    );
                                  }),
                            ),
                          );
                        
                        }
                        }),
                  ],
                ),
              ),
              // IndexedStack(
              //   index: _selectedpage,
              //   children: [],
              // ),
              bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Colors.indigo,

                type        : BottomNavigationBarType.fixed,
                currentIndex: _selectedpage,
                onTap       : _onItemTapped,
                items       : <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.article,
                      size: 33,
                    ),
                    label: 'API',
                  ),
                  BottomNavigationBarItem(
                    icon  : Icon(Icons.wysiwyg, size: 33),
                    label : 'Website',
                  ),
                  BottomNavigationBarItem(
                    icon  : Icon(Icons.cloud, size: 33),
                    label : 'Application',
                  ),
                ],
              ),
            );
    });
  }
}
