import 'package:cotafer_server_status/view/widget/backgroundSingIn.dart';
import 'package:flutter/material.dart';

class TopBackground extends StatelessWidget {
  const TopBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundSignIn(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 80, horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back',
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
              Text('Please sign in to continue',
                  style: TextStyle(fontSize: 20, color: Colors.white60)),
            ],
          ),
        ),
      ],
    );
  }
}
