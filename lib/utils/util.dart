
import 'package:flutter/material.dart';

Color convertColorFromString(String data) {
  try{
    int value = int.parse(data, radix: 16);
    return Color(value);
  }
  catch(e)
  {
    return Colors.black;
  }

}

String convertColorToString(Color color) {
  // return color.toString();
  int tmp = (color.alpha << 24) | (color.red << 16) | (color.green << 8) | color.blue;
  return tmp.toRadixString(16).padLeft(8, '0');
}