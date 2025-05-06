import 'package:flutter/material.dart';

class InwardCurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const curveHeight = 30.0;
    final path = Path();

    path.moveTo(0, 0);

    path.quadraticBezierTo(
      size.width / 2,
      curveHeight,
      size.width,
      0,
    );

    path.lineTo(
      size.width,
      size.height,
    );

    path.quadraticBezierTo(
      size.width / 2,
      size.height - curveHeight,
      0,
      size.height,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
