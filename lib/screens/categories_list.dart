import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../datas/product_data.dart';
import '../card/product_card.dart';

class CategoriesList extends StatefulWidget {
  final String categoryKey;
  final String title;

  const CategoriesList({
    super.key,
    required this.categoryKey,
    required this.title,
  });

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  int cartCount = 0;
  @override
  void initState() {
    super.initState();
    calculateCartCount(); // Only this is enough
  }
  Future<void> calculateCartCount() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartList = prefs.getStringList('cart') ?? [];

    int total = 0;

    for (var item in cartList) {
      final decoded = jsonDecode(item);
      total += decoded['quantity'] as int;
    }

    if (mounted) {
      setState(() {
        cartCount = total;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    
    final filteredProducts = productList
    .where((p) =>
        p.category.toString().toLowerCase().trim() ==
        widget.categoryKey.toLowerCase().trim())
    .toList();

    print("📦 Products found: ${filteredProducts.length}");
    print("Category Key received: ${widget.categoryKey}");

    for (var p in productList) {
      print("Product: ${p.name} | Category: ${p.category}");
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: filteredProducts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage('assets/images/noordersYet.webp')),
                  SizedBox(height: 20,),
                  Text("No products found", style: TextStyle(fontSize: 16)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: filteredProducts[index],
                  onAdd: () {
                    calculateCartCount();
                  },
                  onRemove: () {
                    calculateCartCount();
                  },
                );
              },
            ),
    );
  }
}
