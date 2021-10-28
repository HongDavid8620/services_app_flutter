import 'package:flutter/material.dart';


class ApiStatus extends StatelessWidget {
  const ApiStatus({
    Key? key,
    this.color    : Colors.green,
    this.text     : 'Status',
    this.quantity : 0,
  }) : super(key: key);

  final color;
  final text;
  final quantity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding : const EdgeInsets.all(8.0),
      child   : Row(
        children: [
          Container(
            height: 20,
            width : 20,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          Padding(
            padding : const EdgeInsets.only(left: 6),
            child   : Text(
              '$text: $quantity',
              style : TextStyle(fontSize: 19),
            ),
          ),
        ],
      ),
    );
  }
}
