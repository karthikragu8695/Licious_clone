import 'package:flutter/material.dart';
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

  Future<void> loadCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      count = prefs.getInt('count_${widget.product.id}') ?? 0;
    });
  }

  void increment() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => count++);
    await prefs.setInt('count_${widget.product.id}', count);
    widget.onCountChange?.call(count);
  }

  void decrement() async {
    if (count > 0) {
      final prefs = await SharedPreferences.getInstance();
      setState(() => count--);
      await prefs.setInt('count_${widget.product.id}', count);
      widget.onCountChange?.call(count);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name,
            style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Column(
        children: [
          Image.asset(widget.product.image,
              height: 260, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.product.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("${widget.product.weight} | ${widget.product.pieces}",
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text("₹${widget.product.price}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF800626))),
                    const SizedBox(width: 12),
                    Text("₹${widget.product.oldprice}",
                        style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey)),
                    const SizedBox(width: 8),
                    Text("${widget.product.discount}% OFF",
                        style: const TextStyle(color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, -2))
        ]),
        child: count == 0
            ? ElevatedButton(
                onPressed: increment,
                child: const Text("ADD"),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: decrement, icon: const Icon(Icons.remove)),
                      Text('$count'),
                      IconButton(
                          onPressed: increment, icon: const Icon(Icons.add)),
                    ],
                  ),
                  Text("₹${widget.product.price * count}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF800626))),
                ],
              ),
      ),
    );
  }
}
