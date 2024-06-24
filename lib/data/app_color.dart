
import 'package:flutter/material.dart';

import '../utils/util.dart';

class AppColors {
  Color mainColor = const Color(0xffA3ADB2);
  Color backgroundColor = Colors.white;
  Color selectedColor = const Color(0xff96CCCC);
  Color selectedColor2 = const Color(0xff96CCCC);
  Color tableBorder = Colors.black;
  Color alternateCellBg = Colors.grey.shade300;
  Color textColor = const Color(0xFF0B2C43);
  Color buttonColor = const Color(0xFFEDF2F4);
  Color searchColor = Colors.white;
  Color activeTextColor =  Colors.white;
  Color btnTextColor = const Color(0xFF0B2C43);
  Color chartBgColor = Colors.white;
  Color lineChart = Colors.black;
  Color iconBgColor = Colors.teal;
  Color accountTextColor = Colors.black;
  Color accountColor = Colors.black;
  Color notificationExpandBgColor = Colors.lightBlue.shade50;
  Color notificationWarning = Colors.amber;

  AppColors({
    required this.mainColor,
    required this.backgroundColor,
    required this.selectedColor,
    required this.selectedColor2,
    required this.tableBorder,
    required this.alternateCellBg,
    required this.textColor,
    required this.buttonColor,
    required this.searchColor,
    required this.activeTextColor,
    required this.btnTextColor,
    required this.chartBgColor,
    required this.lineChart,
    required this.iconBgColor,
    required this.accountTextColor,
    required this.accountColor,
    required this.notificationExpandBgColor,
    required this.notificationWarning,
  });

  AppColors.fromJson(Map<String, dynamic> json) {
    mainColor = convertColorFromString(json['mainColor']);
    backgroundColor = convertColorFromString(json['backgroundColor']);
    selectedColor = convertColorFromString(json['selectedColor']);
    selectedColor2 = convertColorFromString(json['selectedColor2']);
    tableBorder = convertColorFromString(json['tableBorder']);
    alternateCellBg = convertColorFromString(json['alternateCellBg']);
    textColor = convertColorFromString(json['textColor']);
    buttonColor = convertColorFromString(json['buttonColor']);
    searchColor = convertColorFromString(json['searchColor']);
    activeTextColor = convertColorFromString(json['activeTextColor']);
    btnTextColor = convertColorFromString(json['btnTextColor']);
    chartBgColor = convertColorFromString(json['chartBgColor']);
    lineChart = convertColorFromString(json['lineChart']);
    iconBgColor = convertColorFromString(json['iconBgColor']);
    accountTextColor = convertColorFromString(json['accountTextColor']);
    accountColor = convertColorFromString(json['accountColor']);
    notificationExpandBgColor = convertColorFromString(json['notificationExpandBgColor']);
    notificationWarning = convertColorFromString(json['notificationWarning']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mainColor'] = convertColorToString(mainColor);
    data['backgroundColor'] = convertColorToString(backgroundColor);
    data['selectedColor'] = convertColorToString(selectedColor);
    data['selectedColor2'] = convertColorToString(selectedColor2);
    data['tableBorder'] = convertColorToString(tableBorder);
    data['alternateCellBg'] = convertColorToString(alternateCellBg);
    data['textColor'] = convertColorToString(textColor);
    data['buttonColor'] = convertColorToString(buttonColor);
    data['searchColor'] = convertColorToString(searchColor);
    data['activeTextColor'] = convertColorToString(activeTextColor);
    data['btnTextColor'] = convertColorToString(btnTextColor);
    data['chartBgColor'] = convertColorToString(chartBgColor);
    data['lineChart'] = convertColorToString(lineChart);
    data['iconBgColor'] = convertColorToString(iconBgColor);
    data['accountTextColor'] = convertColorToString(accountTextColor);
    data['accountColor'] = convertColorToString(accountColor);
    data['notificationExpandBgColor'] = convertColorToString(notificationExpandBgColor);
    data['notificationWarning'] = convertColorToString(notificationWarning);
    return data;
  }
}

final AppColors default_app_colors = AppColors (
  mainColor: const Color(0xffA3ADB2),
  backgroundColor: Colors.white,
  selectedColor: const Color(0xff96CCCC),
  selectedColor2: const Color(0xff96CCCC),
  tableBorder: Colors.black,
  alternateCellBg: Colors.grey.shade300,
  textColor: const Color(0xFF0B2C43),
  buttonColor: const Color(0xFFEDF2F4),
  searchColor: Colors.white,
  activeTextColor:  Colors.white,
  btnTextColor: const Color(0xFF505860),
  chartBgColor: Colors.white,
  lineChart: Colors.black,
  iconBgColor: Colors.teal,
  accountTextColor: Colors.black,
  accountColor: Colors.black,
  notificationExpandBgColor: Colors.lightBlue.shade50,
  notificationWarning: Colors.amber.withOpacity(0.25),
);

class ItemColors {
  String code = "default";
  AppColors colors = default_app_colors;

  ItemColors({required this.code, required this.colors});

  ItemColors.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    colors = json['colors'] != null
      ? AppColors.fromJson(json['colors']!)
      : default_app_colors;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['colors'] = colors.toJson();
    return data;
  }
}

final List<ItemColors> localColors = [];

List<String> getListCodeAppColors() {
  List<String> tmps = [];
  for (ItemColors tmp in localColors) {
    tmps.add(tmp.code);
  }
  return tmps;
}

AppColors? getAppColors(String code) {
  ItemColors? item = localColors.where((s) => s.code.compareTo(code) == 0).firstOrNull;
  if(item == null) {
    return null;
  }
  return item.colors;
}