import 'dart:convert';
import 'package:liciouss/datas/cart_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> addToCart(CartItem item) async {
  void saveCount(String productId, int count) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('count_$productId', count);
}
  final SharedPreferences prefs = await SharedPreferences.getInstance();
List<String>? stringList = prefs.getStringList('cart_counts');

List<int> counts = stringList != null
    ? stringList.map((e) => int.parse(e)).toList()
    : [];
  List<String> cartList = prefs.getStringList('cart') ?? [];

  bool isExist = false;

  for (int i = 0; i < cartList.length; i++) {
    Map<String, dynamic> data = jsonDecode(cartList[i]);

    if (data['id'] == item.id) {
      data['quantity'] = (data['quantity'] ?? 0) + 1;
      cartList[i] = jsonEncode(data);
      isExist = true;
      break;
    }
  }

  if (!isExist) {
    cartList.add(jsonEncode(item.toJson()));
  }

  await prefs.setStringList('cart', cartList);
}
