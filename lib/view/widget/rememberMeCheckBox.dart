import 'package:flutter/material.dart';

class RemeberMeCheckBox extends StatelessWidget {
  const RemeberMeCheckBox({
    Key? key,
    required bool checkBox,
    this.onTap,
  })  : _checkBox = checkBox,
        super(key: key);

  final bool _checkBox;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(
            child: InkWell(
          onTap: onTap,
          child: Container(
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _checkBox
                    ? Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.indigo[800]),
                        child: Icon(Icons.check, size: 20, color: Colors.white),
                      )
                    : Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.indigo, width: 2)),
                      )),
          ),
        )),
        Text(
          'Remember me',
          style: TextStyle(color: Colors.indigo[400]),
        )
      ],
    );
  }
}
