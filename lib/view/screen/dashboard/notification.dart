import 'package:services_flutter/view/widget/NotificationList.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

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
      body: Container(
        child: Column(
          children: [
            NotificationWidgetList(
              notificateColor : Colors.yellow[400],
              statusText      : 'is went wrong',
              time            : '02:34:21 - 02 04 2021',
            ),
            NotificationWidgetList(
              notificateColor : Colors.yellow[400],
              statusText      : 'is went wrong',
              time            : '02:34:21 - 02 04 2021',
            ),
            NotificationWidgetList(
              notificateColor : Colors.red[600],
              statusText      : 'is down',
              time            : '02:34:21 - 02 04 2021',
            ),
            NotificationWidgetList(
              notificateColor : Colors.black54,
              statusText      : 'is disable',
              time            : '02:34:21 - 02 04 2021',
            ),
          ],
        ),
      ),
    );
  }
}
