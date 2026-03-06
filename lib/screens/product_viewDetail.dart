import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:liciouss/screens/cart_screen.dart';
import '../models/product_structure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Function(int)? onCountChange;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onCountChange,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    loadCount();
  }

  /// 🔥 Load quantity from cart list
  Future<void> loadCount() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartList = prefs.getStringList('cart') ?? [];

    int qty = 0;

    for (var item in cartList) {
      final decoded = jsonDecode(item);
      if (decoded['id'] == widget.product.id) {
        qty = decoded['quantity'];
        break;
      }
    }

    setState(() {
      count = qty;
    });
  }

  /// 🔥 Increment quantity
  void increment() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartList = prefs.getStringList('cart') ?? [];

    List<Map<String, dynamic>> items = cartList
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();

    int index = items.indexWhere((item) => item['id'] == widget.product.id);

    if (index >= 0) {
      items[index]['quantity']++;
      count = items[index]['quantity'];
    } else {
      items.add({
        'id': widget.product.id,
        'name': widget.product.name,
        'price': widget.product.price,
        'image':widget.product.image,
        'oldprice':widget.product.oldprice,
        'weight':widget.product.weight,
        'quantity': 1,
      });
      count = 1;
    }

    await prefs.setStringList('cart', items.map((e) => jsonEncode(e)).toList());

    setState(() {});
    widget.onCountChange?.call(count);
  }

  /// 🔥 Decrement quantity
  void decrement() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartList = prefs.getStringList('cart') ?? [];

    List<Map<String, dynamic>> items = cartList
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();

    int index = items.indexWhere((item) => item['id'] == widget.product.id);

    if (index == -1) return;

    if (items[index]['quantity'] > 1) {
      items[index]['quantity']--;
      count = items[index]['quantity'];
    } else {
      items.removeAt(index);
      count = 0;
    }

    await prefs.setStringList('cart', items.map((e) => jsonEncode(e)).toList());

    setState(() {});
    widget.onCountChange?.call(count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.name,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartPage()),
              ).then((_) {
                loadCount(); // 🔥 refresh when coming back
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Image.asset(
            widget.product.image,
            height: 260,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${widget.product.weight} | ${widget.product.pieces}",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      "₹${widget.product.price}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF800626),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "₹${widget.product.oldprice}",
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${widget.product.discount}% OFF",
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      /// 🔥 Bottom Add / Quantity Bar
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: count == 0
            ? ElevatedButton(onPressed: increment, child: const Text("ADD"))
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: decrement,
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        '$count',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        onPressed: increment,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  Text(
                    "₹${widget.product.price * count}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF800626),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
