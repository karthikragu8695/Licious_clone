import '../models/product_structure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
final supabase = Supabase.instance.client;

Future<List<Product>> fetchProducts() async {
  final response = await supabase
      .from('products')
      .select();

  return (response as List)
      .map((item) => Product.fromJson(item))
      .toList();
}

List<Product> productList = [
  Product(
    id: 1,
    name: 'chicken',
    image: 'assets/images/CHICKEN1.jpg',
    weight: '500 g',
    pieces: '12 - 18 pieces',
    price: 165,
    oldprice: 199,
    discount: 17,
    category: 1,
    deliveryMinutes: 90,
    isBestSeller: true,
  ),
  Product(
    id: 2,
    name: 'Mutton',
    image: 'assets/images/MUTTON.jpg',
    weight: '250 g',
    pieces: '20 - 25 pieces',
    price: 194,
    oldprice: 216,
    discount: 15,
    category: 2,
    deliveryMinutes: 90,
    isBestSeller: true,
  ),
  Product(
    id: 3,
    name: 'Fish',
    image: 'assets/images/FISH.jpg',
    weight: '450 g',
    pieces: '2 - 4 pieces',
    price: 260,
    oldprice: 326,
    discount: 13,
    category: 3,
    deliveryMinutes: 90,
    isBestSeller: true,
  ),
  
];
