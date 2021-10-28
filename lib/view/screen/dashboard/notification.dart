import 'package:cotafer_server_status/view/widget/NotificationList.dart';
import 'package:cotafer_server_status/view_model/service/notification/notificatinRespone.dart';
import 'package:cotafer_server_status/view_model/service/notification/notificationService.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Future? _notificationList;
  @override
  void initState() {
    _notificationList = NotificationService.getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 35, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('Notifiation'),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future  : _notificationList,
              builder : (context, snapshot) {
                var listNotification;
                if (snapshot.hasData) {
                  listNotification = snapshot.data as List<ListNotification>;
                }
                if (snapshot.hasData) {
                  return Container(
                    child: Expanded(
                      child: ListView.builder(
                          itemCount   : listNotification.length,
                          itemBuilder : (context, index) {
                            ListNotification notification = listNotification[index];
                            var statusColor;
                            if (notification.status == 'down') {
                              statusColor = Colors.red[500];
                            } else if (notification.status == 'live') {
                              statusColor = Colors.greenAccent[400];
                            } else if (notification.status == 'disable') {
                              statusColor = Colors.black54;
                            } else {
                              statusColor = Colors.yellow[500];
                            }
                            return NotificationWidgetList(
                              notificateColor : statusColor,
                              statusText      : '${notification.status}',
                              time            : '${notification.datetime}',
                              serviceName     : '${notification.serviceName}',
                              serverName      : '${notification.serverName}',
                            );
                          }),
                    ),
                  );
                } else {
                  return NotificationWidgetList(
                    notificateColor : Colors.black54,
                    statusText      : 'is went wrong',
                    time            : '02:34:21 - 02 04 2021',
                  );
                }                
              }),
        ],
      ),
    );
  }
}
