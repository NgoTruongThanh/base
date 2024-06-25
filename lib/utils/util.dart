import 'dart:ui';

Color convertColorFromString(String data) {
  // String valueString = data.split('(0x')[1].split(')')[0];
  // int value = int.parse(valueString, radix: 16);
  // return Color(value);
  int value = int.parse(data, radix: 16);
  return Color(value);
}

String convertColorToString(Color color) {
  // return color.toString();
  int tmp = (color.alpha << 24) | (color.red << 16) | (color.green << 8) | color.blue;
  return tmp.toRadixString(16).padLeft(8, '0');
}