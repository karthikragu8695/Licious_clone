import 'package:flutter/material.dart';
import '../datas/product_data.dart';
import '../card/product_card.dart';

class CategoriesList extends StatelessWidget {
  final String categoryKey;
  final String title;

  const CategoriesList({
    super.key,
    required this.categoryKey,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final filteredProducts = productList
        .where((p) => p.category == categoryKey)
        .toList();

    print("📦 Products found: ${filteredProducts.length}");
    print("Category Key received: $categoryKey");

    for (var p in productList) {
      print("Product: ${p.name} | Category: ${p.category}");
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: filteredProducts.isEmpty
          ? const Center(
              child: Text("No products found", style: TextStyle(fontSize: 16)),
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
                  onAdd: () {},
                  onRemove: () {},
                );
              },
            ),
    );
  }
}
