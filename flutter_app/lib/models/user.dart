import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String buyerId;
  String? sellerId;
  String token;

  User({
    required this.buyerId,
    this.sellerId,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        buyerId: json["buyer_id"],
        sellerId: json["seller_id"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "buyer_id": buyerId,
        "seller_id": sellerId,
        "token": token,
      };
}
