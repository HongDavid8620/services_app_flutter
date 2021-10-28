import 'package:flutter/material.dart';

class ShowLoadingDialog {
  final BuildContext context;
  ShowLoadingDialog(this.context);
   void showLoaderDialog() {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black26,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: SizedBox(
                  height: 60.0,
                  width: 60.0,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ))),
        );
      },
    );
  }
}