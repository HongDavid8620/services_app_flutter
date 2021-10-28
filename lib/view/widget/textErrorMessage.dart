import 'package:flutter/material.dart';

class TextErrorMessage extends StatefulWidget {
  const TextErrorMessage({Key? key, this.newMessage:''}) : super(key: key);

  final String newMessage;

  @override
  _TextErrorMessageState createState() => _TextErrorMessageState();
}

class _TextErrorMessageState extends State<TextErrorMessage> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  var showMessage;
  bool errorMessageIsShowed = false;
  
  //user in initail
  animated() {
    controller = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
        });
        } 
        if(status == AnimationStatus.dismissed){
          setState(() {            
          });
        }
      });
  }

  @override
  void initState() {
    super.initState();
    animated();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  //controll animation when '' or change message
  reShowAnimation() async {
    if (widget.newMessage != '') {
      if (widget.newMessage != showMessage) {
        await controller.reverse();
        showMessage = widget.newMessage;
        await controller.forward();
      } else {
        showMessage = widget.newMessage;
        controller.forward();
      }
    } else {
      await controller.reverse();
      showMessage = widget.newMessage;
      print(showMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    // _widget.showMessage='123';
    if (showMessage == null) showMessage = '';

    reShowAnimation();

    return Center(
      child: Padding(
        padding : EdgeInsets.only(top: 3,bottom: 10),
        child   : AnimatedBuilder(
              animation : controller,
              builder   : (context, _) {
                return Opacity(
                    opacity: animation.value,
                    child: Text('$showMessage',
                        style: TextStyle(
                          color: Colors.red,
                        )));
              }),
      ),
    );
  }
}
