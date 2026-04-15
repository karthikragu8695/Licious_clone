import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

/// Save username
Future<void> saveUserName(String phone) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('phone_number', phone);
  await prefs.setBool('is_logged_in', true);
}

/// Save product count
Future<void> saveCount(String productId, int count) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('count_$productId', count);
}

class CartItem {
  final int id;
  final String name;
  final int price;
  final double oldprice;
  int quantity;
  final String? image;
  final String ?weight;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.oldprice,
    required this.weight,
    this.quantity = 1,
    required this.image
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      weight: json['weight']??'',
      oldprice: (json['oldprice'] ?? 0).toDouble(),
      quantity: json['quantity'],
      image: json['image'] ?? "assets/images/defalut_image.png",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'weight': weight,
      'quantity': quantity,
      'image':image,
    };
  }
}
