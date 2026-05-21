import 'package:flutter/material.dart';
import 'package:liciouss/models/category_structure.dart';
import 'package:liciouss/screens/categories_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryWidget extends StatefulWidget {

  final VoidCallback onCartUpdated;

  const CategoryWidget({
    super.key,
    required this.onCartUpdated,
  });

  @override
  State<CategoryWidget> createState() =>
      _CategoryWidgetState();
}

class _CategoryWidgetState
    extends State<CategoryWidget> {

  final supabase = Supabase.instance.client;

  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {

    final response = await supabase
        .from('Category')
        .select();

    final data = (response as List)
        .map((e) => Category.fromJson(e))
        .toList();

    setState(() {
      categories = data;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (categories.isEmpty) {

      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return GridView.builder(

      padding: const EdgeInsets.all(12),

      shrinkWrap: true,

      physics:
          const NeverScrollableScrollPhysics(),

      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(

        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),

      itemCount: categories.length,

      itemBuilder: (context, index) {

        final category = categories[index];

        return InkWell(

          borderRadius:
              BorderRadius.circular(50),

          onTap: () {

            Navigator.push(

              context,

              MaterialPageRoute(

                builder: (_) => CategoriesList(

                  categoryKey:
                      category.id.toString(),

                  title: category.title,
                ),
              ),

            ).then((_) {

              widget.onCartUpdated();
            });
          },

          child: Column(

            children: [

              CircleAvatar(

                radius: 32,

                backgroundImage:
                    NetworkImage(category.image),

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