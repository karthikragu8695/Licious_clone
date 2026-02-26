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
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}
