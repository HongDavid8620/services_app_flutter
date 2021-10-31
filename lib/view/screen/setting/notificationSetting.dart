import 'package:services_flutter/view/widget/loadingPage.dart';
import 'package:services_flutter/view_model/service/setting/notification/settNotificationServicer.dart';
import 'package:services_flutter/view_model/service/setting/notification/switchNotificationServicer.dart';
import 'package:flutter/material.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({Key? key}) : super(key: key);

  @override
  _NotificationSettingState createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 35, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: NotificationToggle(),
          ),
        ],
      ),
    );
  }
}

class NotificationToggle extends StatefulWidget {
  const NotificationToggle({
    Key? key,
  }) : super(key: key);

  @override
  _NotificationToggleState createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<NotificationToggle> {
  bool _toggle = false;
  bool switchChange = false;
  Future? _notificationSwitch;

  @override
  void initState() {
    _notificationSwitch = SettingNotificationService.getNotificationSet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(      
        future: _notificationSwitch,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != '') {
            
            if(!switchChange)
              (snapshot.data == '1') ? _toggle = true : _toggle = false;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notification',
                  style: TextStyle(fontSize: 19, letterSpacing: 0.6),
                ),
                Switch(
                    activeColor : Colors.indigo,
                    value       : _toggle,
                    onChanged   : (value) {
                      SwitchNotificationService.changeNotificationSwitch(value);
                      setState(() {
                        switchChange  = true;
                        _toggle       = value;
                      });
                    })
              ],
            );
          } else {
            return Container();
          }
        });
  }
}
