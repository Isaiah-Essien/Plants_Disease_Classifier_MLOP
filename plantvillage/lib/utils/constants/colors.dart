// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class ColorResources {
  static const Color LABEL_TEXT = Color(0xff17112A);
  static  Color CAPTION_TEXT = const Color(0x0017112A).withOpacity(0.7);
  static const Color Secondary = Color(0xFF18917C);
  static const Color PRIMARY = Color(0xFF1BB09D);
  static const Color PRIMARY_LIGHT = Color.fromARGB(255, 234, 234, 243);
  static const Color BACKGROUND = Color(0xfff3f1f5);
  static const Color LAVENDER = Color(0xffE6E5F3);
  static const Color RED = Color(0xffFF0404);

  static MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(color.value, shades);
  }
}