import 'package:flutter/material.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Text('Something when wrong!'),            
          ),
        ),
      ),
    );
  }
}