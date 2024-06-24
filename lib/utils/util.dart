import 'dart:ui';

Color convertColorFromString(String data) {
  String valueString = data.split('(0x')[1].split(')')[0];
  int value = int.parse(valueString, radix: 16);
  return Color(value);
}

String convertColorToString(Color color) {
  return color.toString();
}