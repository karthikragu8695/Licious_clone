import 'package:flutter/material.dart';
import 'package:liciouss/screens/categories_list.dart';
import '../models/category_structure.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Categories',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(category.image),
                ),
                title: Text(
                  category.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                //  subtitle: Text(category['subtitle']),
                trailing: Icon(Icons.arrow_forward_ios, size: 17),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoriesList(
                        categoryKey: category.key,
                        title: category.title,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
