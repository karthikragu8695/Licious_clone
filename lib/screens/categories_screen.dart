import 'package:flutter/material.dart';
import 'package:liciouss/models/category_structure.dart';
import 'package:liciouss/screens/categories_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  final supabase = Supabase.instance.client;

  Future<List<Category>> fetchCategories() async {

    final response = await supabase
        .from('Category')
        .select();

    return (response as List)
        .map((e) => Category.fromJson(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'All Categories',
        ),
      ),

      body: FutureBuilder<List<Category>>(

        future: fetchCategories(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final Category = snapshot.data ?? [];

          return ListView.builder(

            itemCount: Category.length,

            itemBuilder: (context, index) {

              final category = Category[index];

              return Card(
                child: ListTile(

                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(category.image),
                  ),

                  title: Text(category.title),

                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),

                  onTap: () {

                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) => CategoriesList(
                          categoryKey: category.id.toString(),
                          title: category.title,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}