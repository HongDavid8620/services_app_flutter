import 'package:flutter/material.dart';

class BackgroundSignIn extends StatefulWidget {
  const BackgroundSignIn({Key? key}) : super(key: key);


  @override
  _BackgroundSignInState createState() => _BackgroundSignInState();
}

class _BackgroundSignInState extends State<BackgroundSignIn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: BoxShadowPainter(),
        child: ClipPath(
          clipper: BackgroundShape(),
          child: Container(
            color: Colors.indigo[700],
            height: MediaQuery.of(context).size.height * 0.43,
          ),
        ),
      ),
    );
  }
}

class BackgroundShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var c1 = Offset(size.width * 0.38, size.height);
    var p2 = Offset(size.width * 0.55, size.height -  140);

    var c3 = Offset(size.width * 0.62, size.height - 190);
    var p4 = Offset(size.width * 0.75, size.height - 160);

    var c5 = Offset(size.width * 0.90, size.height - 120);
    var p6 = Offset(size.width, size.height - 160);

    var path = new Path()
      ..lineTo(0, size.height * 0.80)
      ..quadraticBezierTo(c1.dx, c1.dy, p2.dx, p2.dy)
      ..quadraticBezierTo(
        c3.dx,
        c3.dy,
        p4.dx,
        p4.dy,
      )
      ..quadraticBezierTo(
        c5.dx,
        c5.dy,
        p6.dx,
        p6.dy,
      )
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}



class BoxShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var c1 = Offset(size.width * 0.38, size.height);
    var p2 = Offset(size.width * 0.55, (size.height - 5)  - 140);

    var c3 = Offset(size.width * 0.62, size.height - 190);
    var p4 = Offset(size.width * 0.75, (size.height - 5) - 160);

    var c5 = Offset(size.width * 0.90, size.height - 120);
    var p6 = Offset(size.width, (size.height - 5)  - 160);

    var path = new Path()
      ..lineTo(0, (size.height - 2.5) * 0.80)
      ..quadraticBezierTo(c1.dx, c1.dy, p2.dx, p2.dy)
      ..quadraticBezierTo(
        c3.dx,
        c3.dy,
        p4.dx,
        p4.dy,
      )
      ..quadraticBezierTo(
        c5.dx,
        c5.dy,
        p6.dx,
        p6.dy,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawShadow(path, Colors.black, 6.0, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
