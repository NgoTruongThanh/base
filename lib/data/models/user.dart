class User {
  String code = "";
  String name = "";
  String des = "";
  String token = "";
  String role = "";
  String phone = "";
  int expirationTime = 0;

  User({
    required this.code,
    required this.name,
    required this.des,
    required this.token,
    required this.role,
    required this.phone,
    required this.expirationTime,
  });

  User.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    des = json['des'];
    token = json['token'];
    role = json['role'];
    phone = json['phone'];
    expirationTime = json['expirationTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['des'] = des;
    data['token'] = token;
    data['role'] = role;
    data['phone'] = phone;
    data['expirationTime'] = expirationTime;
    return data;
  }
}