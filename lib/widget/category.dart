
import 'package:flutter/material.dart';
import 'package:liciouss/screens/categories_list.dart';
import '../models/category_structure.dart';

class CategoryWidget extends StatefulWidget {
  final VoidCallback onCartUpdated;
  const CategoryWidget({super.key, required this.onCartUpdated});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];

        return InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoriesList(
                  categoryKey: category.key, // ✅ safe
                  title: category.title,
                ),
              ),
            ).then((_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoriesList(
                    categoryKey: category.key,
                    title: category.title,
                  ),
                ),
              ).then((_) {
                widget.onCartUpdated(); // 🔥 refresh Home
              });
            });
          },
          child: Column(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage(category.image),
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                category.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
