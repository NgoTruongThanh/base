
class Role {
  String? code;
  String? name;
  String? des;

  Role({
    this.code,
    this.name,
    this.des,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    code: json["code"],
    name: json["name"],
    des: json["des"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "des": des,
  };
}
