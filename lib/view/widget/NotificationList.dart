import 'package:flutter/material.dart';

class NotificationWidgetList extends StatelessWidget {
  const NotificationWidgetList({
    Key? key,
    this.time           : '02:34:21 - 02 04 2021',
    this.statusText     : 'is went wrong',
    this.notificateColor: Colors.yellow,
  }) : super(key: key);

  final notificateColor;
  final statusText;
  final time;

  @override
  Widget build(BuildContext context) {
    return Container(
      width : double.infinity,
      height: 42,
      margin: EdgeInsets.only(top: 20, left: 15, right: 15),
      child : Stack(
        children: [
          Container(
            width     : 22,
            height    : 22,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: notificateColor),
          ),
          Positioned(
            left  : 33,
            child : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                      style : TextStyle(
                          fontSize  : 16,
                          color     : Colors.black,
                          fontWeight: FontWeight.w500),
                      text  : 'Service name | Server name ',
                      
                      children: [
                        TextSpan(
                          text: '$statusText',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    )),
                Padding(
                  padding : const EdgeInsets.only(top: 8),
                  child   : Text(
                    '02:34:21 - 02 04 2021',
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
