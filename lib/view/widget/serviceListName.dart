import 'package:flutter/material.dart';

class SerivceListName extends StatelessWidget {
  const SerivceListName({
    Key? key,
    this.serviceName,
    this.serverName,
    this.serverStatus,
    this.statusColor: Colors.black26,
  }) : super(key: key);

  final serviceName;
  final serverName;
  final serverStatus;
  final statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin    : EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            blurRadius  : 4,
            spreadRadius: 4,
            color       : Colors.grey.withOpacity(0.15),
            offset      : Offset(0, 2))
      ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color : statusColor,
            width : 8,
            height: 110,
          ),
          Container(
            padding : const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child   : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    serviceName == null
                        ? LoadingStatusContainer()
                        : Text(
                            '$serviceName',
                            style: TextStyle(fontSize: 20),
                          ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      width : 0.8,
                      height: 25,
                      color : Colors.black,
                    ),
                    serverName == null
                        ? LoadingStatusContainer()
                        : Text(
                            '$serverName',
                            style: TextStyle(fontSize: 20),
                          ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                serverStatus == null
                    ? LoadingStatusContainer()
                    : Text(
                        '$serverStatus',
                        style: TextStyle(fontSize: 14),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LoadingStatusContainer extends StatelessWidget {
  const LoadingStatusContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width : 120,
        height: 22,
        decoration: BoxDecoration(
            color: Color.fromRGBO(222, 222, 222, 0.5),
            borderRadius: BorderRadius.circular(10)));
  }
}
