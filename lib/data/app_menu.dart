class MenuItem {
  String? code;
  String? name;
  String? type;
  List<MenuChildItem>? children;

  MenuItem({this.code, this.name, this.type, this.children});

  MenuItem.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    type = json['type'];
    if (json['children'] != null) {
      children = <MenuChildItem>[];
      json['children'].forEach((v) {
        children!.add(MenuChildItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['type'] = type;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuChildItem {
  String? code;
  String? name;

  MenuChildItem({this.code, this.name});

  MenuChildItem.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}

final List<MenuItem> defaultAppMenu= [
  MenuItem(code: "home", name: "Home", type: "base", children: []),
  MenuItem(code: "tab1", name: "Tab1", type: "base", children: [
    MenuChildItem(code: "item_1_1", name: "Item1In1"),
    MenuChildItem(code: "item_1_2", name: "Item1In2"),
    MenuChildItem(code: "item_1_3", name: "Item1In3"),
  ]),
  MenuItem(code: "tab2", name: "Tab2", type: "base", children: [
    MenuChildItem(code: "item_2_1", name: "Item2In1"),
    MenuChildItem(code: "item_2_2", name: "Item2In2"),
  ]),
];
