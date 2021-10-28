import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    Key? key,
    this.btText,
    this.btTextSize,
    this.btHieght,
    this.btWidth,
    this.onPressed,
      this.btColor: Colors.indigo, this.btTextColor: Colors.white
  }) : super(key: key);

  final btText;
  final double? btTextSize;
  final double? btHieght;
  final double? btWidth;
  final Color btColor;
  final Color btTextColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width : btWidth ?? double.infinity,
      height: btHieght ?? null,
      child : TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(btColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ))),
          child: Text(
            btText ?? 'Button',
            style: TextStyle(
                color     : btTextColor,
                fontSize  : btTextSize ?? 20,
                fontWeight: FontWeight.w400),
          ),
          onPressed: onPressed),
    );
  }
}
