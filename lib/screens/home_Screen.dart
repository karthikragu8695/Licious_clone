import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_structure.dart';
import '../models/product_structure.dart';
import '../card/product_card.dart';
import '../banners/offer_banner.dart';
import '../widget/category.dart';
import '../screens/cart_screen.dart';
import '../internet/internet_check.dart';


class HomeContent extends StatefulWidget {
  final String? searchQuery;

  const HomeContent({super.key, this.searchQuery});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Product> productList = [];
  int cartCount = 0;

  @override
  void initState() {
    super.initState();
    checkInternet();
    loadProducts();
    calculateCartCount();
  }

  /// 🔥 LOAD FROM SUPABASE
  Future<void> loadProducts() async {
    final data = await fetchProducts();

    if (mounted) {
      setState(() {
        productList = data;
      });
    }
  }

  /// 🌐 INTERNET CHECK
  Future<void> checkInternet() async {
    final result = await Connectivity().checkConnectivity();

    if (!result.contains(ConnectivityResult.mobile) &&
        !result.contains(ConnectivityResult.wifi)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => NoInternetScreen()),
      );
    }
  }

  /// 🛒 CART COUNT
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
    final query = widget.searchQuery?.trim().toLowerCase() ?? "";

    final filteredProductList = productList.where((p) {
      return p.name.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      body: productList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    /// 📍 HEADER
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: const Color(0xFFF2F0F0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Trichy",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("⚡ Delivery in 30 mins",
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    const OfferBanner(),

                    const SizedBox(height: 12),

                    /// ⭐ BESTSELLERS
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Bestsellers',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      height: 230,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: filteredProductList.length,
                        itemBuilder: (context, index) {
                          final product = filteredProductList[index];

                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SizedBox(
                              width: 180,
                              child: ProductCard(
                                product: product,
                                onAdd: () => calculateCartCount(),
                                onRemove: () => calculateCartCount(),
                                onCountChange: (c) => calculateCartCount(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// 🏷 CATEGORY
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Shop by category',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),

                    CategoryWidget(onCartUpdated: calculateCartCount),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

      /// 🛒 CART BAR
      bottomNavigationBar: cartCount > 0
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$cartCount items added",
                      style: const TextStyle(color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CartPage()),
                        ).then((_) => calculateCartCount());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        "View Cart",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}


final supabase = Supabase.instance.client;

Future<List<Product>> fetchProducts() async {
  final response = await supabase
      .from('products')
      .select();

  return (response as List)
      .map((item) => Product.fromJson(item))
      .toList();
}