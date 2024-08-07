import '../app_color.dart';
import '../app_menu.dart';

class AppConfig {
  List<MenuItem> cfgMenu = [];
  String cfgValueKey;
  AppColors cfgColors;

  AppConfig({required this.cfgMenu, required this.cfgValueKey, required this.cfgColors});

  void setConfigMenu(List<MenuItem> items) {
    cfgMenu = items;
  }

  List<MenuItem> getConfigMenu() {
    return cfgMenu;
  }

  void setConfigValueKey(String item) {
    cfgValueKey = item;
  }

  String getConfigValueKey() {
    return cfgValueKey;
  }

  void setConfigColors(AppColors item) {
    cfgColors = item;
  }

  AppColors getConfigColors() {
    return cfgColors;
  }
}
