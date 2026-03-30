import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:liciouss/card/product_card.dart';
import 'package:liciouss/internet/internet_check.dart';
import 'package:liciouss/screens/cart_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../banners/offer_banner.dart';
import '../datas/product_data.dart';
import '../widget/category.dart';

class HomeContent extends StatefulWidget {
  final String? searchQuery;
  const HomeContent({super.key, this.searchQuery});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int cartCount = 0;

  @override
  void initState() {
    super.initState();
    checkInternet();
    calculateCartCount(); // Only this is enough
  }

  String selectedLocation = "Coimbatore";
  String deliveryTime = "⚡ Delivery in 90 mins";

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();

    for (String key in prefs.getKeys()) {
      if (key.startsWith('count_')) {
        await prefs.remove(key);
      }
    }

    await prefs.remove('cart'); // 🔥 Important

    if (mounted) {
      setState(() {
        cartCount = 0;
      });
    }
  }

  Future<void> checkInternet() async {
    final result = await Connectivity().checkConnectivity();

    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi)) {
      print("Internet Available");
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => NoInternetScreen()),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No Internet Connection")));
    }
  }

  /// 🔹 Calculate total cart count from SharedPreferences
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

  /// 🔹 Update delivery time
  void updateDeliveryInfo(String location) {
    setState(() {
      selectedLocation = location;

      if (location == "Chennai") {
        deliveryTime = "⚡ Delivery in 120 mins";
      } else if (location == "Bangalore") {
        deliveryTime = "⚡ Delivery in 100 mins";
      } else {
        deliveryTime = "⚡ Delivery in 90 mins";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.searchQuery?.trim().toLowerCase() ?? "";

    final filteredProductList = query.isEmpty
        ? productList
        : productList
              .where((p) => p.name.toLowerCase().contains(query))
              .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Location Bar
              Container(
                padding: const EdgeInsets.all(12),
                color: const Color(0xFFF2F0F0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        String? location = await showDialog<String>(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: const Text("Select Location"),
                            children: [
                              SimpleDialogOption(
                                onPressed: () =>
                                    Navigator.pop(context, "Coimbatore"),
                                child: const Text("Coimbatore"),
                              ),
                              SimpleDialogOption(
                                onPressed: () =>
                                    Navigator.pop(context, "Chennai"),
                                child: const Text("Chennai"),
                              ),
                              SimpleDialogOption(
                                onPressed: () =>
                                    Navigator.pop(context, "Bangalore"),
                                child: const Text("Bangalore"),
                              ),
                            ],
                          ),
                        );

                        if (location != null) {
                          updateDeliveryInfo(location);
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                selectedLocation,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                          Text(
                            "$selectedLocation International",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Text(deliveryTime, style: const TextStyle(fontSize: 12)),
                    // ElevatedButton(
                    //   onPressed: didChangeDependencies,
                    //   child: Text('data'),
                    // ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              const OfferBanner(),

              const SizedBox(height: 12),

              /// 🔹 Bestsellers Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Bestsellers',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Most Popular products near you!',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),

              // / 🔹 Bestsellers List
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
                          onCountChange: (count) {
                            calculateCartCount();
                          },
                          // count: 0, // basic
                          onAdd: () {
                            // addToCart(
                            //   CartItem(
                            //     id: product.id,
                            //     name: product.name,
                            //     price: product.price,
                            //     quantity: 1,
                            //   ),
                            // );
                            calculateCartCount();
                          },
                          onRemove: () {
                            calculateCartCount();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              /// 🔹 Categories
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Shop by category',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Freshest meats and much more!',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              CategoryWidget(onCartUpdated: calculateCartCount),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      /// 🔹 Bottom Cart Bar
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
                      "$cartCount ${cartCount > 1 ? "item" : "items"} added",

                      style: const TextStyle(color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CartPage()),
                        ).then((_) {
                          calculateCartCount();
                          setState(() {}); // 🔥 Force rebuild all ProductCards
                        });
                        print("Cart item:$calculateCartCount()");
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        "View Cart",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
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
