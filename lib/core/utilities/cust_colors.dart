import 'package:flutter/material.dart';

class CustColors{
  CustColors._();
  static const Color background1 = Color(0xff0D0D1B);
  static const Color white = Colors.white;
  static const Color blue = Color(0xff1D61E7);
  static const Color grey = Colors.grey;
  static const Color blue_shade100 = Color(0xFF2B6CB0);
  static const Color majorelleBlue = Color(0xFF7B52EA);
  static const Color saffron = Color(0xFFFBBB37);
  static const Color orchid = Color(0xFFE072FF);
  static const LinearGradient futuristicDarkGradient = LinearGradient(
    colors: [
      Color(0xff0D0D1B),
      Color(0xff1A1F3B),
      Color(0xff283E51),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [
      Color(0xff0D0D1B),
      Color(0xff15203A),
      Color(0xff1B2A50),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient treeBackground = LinearGradient(
    colors: [Color(0xffe0f7fa), Color(0xfff1f8e9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient tabBarGradient = LinearGradient(
    colors: [Color(0xffb6d9e8), Color(0xffd9f0e9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );



}