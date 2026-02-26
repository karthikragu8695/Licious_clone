import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:liciouss/login/Login_Screen.dart';
import 'package:liciouss/screens/product_viewDetail.dart';
import '../models/product_structure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final Function(int)? onCountChange; // callback for Home screen update

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
    required this.onRemove,
    this.onCountChange,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int count = 0;
  // Future<void> loadCartCount() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List<String> cartList = prefs.getStringList('cart') ?? [];

  //   int total = 0;

  //   for (var item in cartList) {
  //     final decoded = jsonDecode(item);
  //     total += decoded['quantity'] as int;
  //   }

  //   setState(() {
  //     count = total;
  //   });

  //   print("🛒 product Cart Count: $count");
  // }

  @override
  void initState() {
    super.initState();
    loadCount();
    //loadCartCount();
  }

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

  //Increament
  void increment() async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.getString('phone_number');

    if (phoneNumber == null || phoneNumber.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

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
        'quantity': 0,
      });
      count = 1;
    }

    await prefs.setStringList('cart', items.map((e) => jsonEncode(e)).toList());

    setState(() {});

    widget.onAdd();
    widget.onCountChange?.call(count);
  }

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
      widget.onRemove();
    }

    await prefs.setStringList('cart', items.map((e) => jsonEncode(e)).toList());

    setState(() {});
    widget.onCountChange?.call(count);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
              product: widget.product,
              onCountChange: (newCount) {
                setState(() {
                  count = newCount;
                });

                if (widget.onCountChange != null) {
                  widget.onCountChange!(newCount);
                }
              },
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image + add/remove buttons
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.asset(
                    widget.product.image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: count == 0
                      ? InkWell(
                          onTap: increment,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFBC1944),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 4),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 16),
                                onPressed: decrement,
                              ),
                              Text(
                                '$count',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 16),
                                onPressed: increment,
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),

            // Product info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₹${widget.product.weight}',
                        style: const TextStyle(
                          color: Color(0xff050505),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '| ${widget.product.pieces}',
                        style: const TextStyle(
                          color: Color(0xff050505),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '₹${widget.product.price}',
                        style: const TextStyle(
                          color: Color(0xFF800626),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        '₹${widget.product.oldprice}',
                        style: const TextStyle(
                          color: Color(0xff050505),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        '${widget.product.discount}%',
                        style: const TextStyle(
                          color: Color(0xff050505),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    "⚡ Today in 90 mins",
                    style: TextStyle(
                      color: Color(0xff050505),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
