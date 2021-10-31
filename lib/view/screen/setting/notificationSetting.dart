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
            padding : const EdgeInsets.all(10.0),
            child   : NotificationToggle(),
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
  @override
  Widget build(BuildContext context) {
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
              setState(() {
                _toggle = value;
              });
            })
      ],
    );
  }
}
