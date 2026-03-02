import 'dart:convert';
import 'package:flutter/material.dart';
import '../datas/cart_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];

  int deliveryFee = 39;
  int handlingFee = 5;
  int savings = 36;

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  /// 🔹 Load cart
  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartList = prefs.getStringList('cart') ?? [];

    setState(() {
      cartItems = cartList
          .map((e) => CartItem.fromJson(jsonDecode(e)))
          .toList();
    });
    print("CartItems Loaded: ${cartItems.length}");
  }

  /// 🔹 Save updated cart
  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> updatedList = cartItems
        .map((item) => jsonEncode(item.toJson()))
        .toList();
    await prefs.setStringList('cart', updatedList);

    setState(() {});
    print(updatedList);
  }

  /// 🔹 Increase Quantity
  void increaseQty(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cartItems[index].quantity++;
    });
    saveCart();
  }

  /// 🔹 Decrease Quantity
  void decreaseQty(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      } else {
        cartItems.removeAt(index);
      }
    });

    saveCart();
  }

  /// 🔹 Item total
  int getItemTotal() {
    int total = 0;
    for (var item in cartItems) {
      total += item.price.toInt() * item.quantity;
    }
    return total;
  }

  int getFinalAmount() {
    return getItemTotal() + deliveryFee + handlingFee - savings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: Column(
        children: [
          /// 🔹 Offer Banner
          Container(
            width: double.infinity,
            color: Colors.greenAccent,
            padding: const EdgeInsets.all(8),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("😍", style: TextStyle(fontSize: 28)),
                    SizedBox(width: 6),
                    Text("You have saved ₹36!"),
                  ],
                ),
                Text("Shop for ₹25 more to save ₹50 | 20% FLAT"),
              ],
            ),
          ),

          Expanded(
            child: cartItems.isEmpty
                ? const Center(child: Text("Your cart is empty"))
                : ListView(
                    children: [
                      /// 🔹 Cart Items
                      ...cartItems.asMap().entries.map((entry) {
                        int index = entry.key;
                        CartItem item = entry.value;

                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Image.asset(
                                        item.image ??
                                            "assets/images/masala.webp",
                                      ),
                                    ),
                                    const Icon(
                                      Icons.shopping_cart,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(item.name)),
                                    Text("₹${item.price * item.quantity}"),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                /// 🔹 Quantity Controls
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => decreaseQty(index),
                                          icon: const Icon(Icons.remove),
                                        ),
                                        Text(
                                          item.quantity.toString(),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        IconButton(
                                          onPressed: () => increaseQty(index),
                                          icon: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),

                                    /// 🔹 Remove Button
                                    TextButton(
                                      onPressed: () {
                                        cartItems.removeAt(index);
                                        saveCart();
                                      },
                                      child: const Text(
                                        "Remove",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Bill Summary",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Divider(),

                      ListTile(
                        title: const Text("Item total"),
                        trailing: Text("₹${getItemTotal()}"),
                      ),
                      ListTile(
                        title: const Text("Delivery Fee"),
                        trailing: Text("₹$deliveryFee"),
                      ),
                      ListTile(
                        title: const Text("Handling Fee"),
                        trailing: Text("₹$handlingFee"),
                      ),
                      ListTile(
                        title: const Text("Savings"),
                        trailing: Text(
                          "- ₹$savings",
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),

                      const Divider(),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            const Text(
                              "Amount to be paid",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹${getFinalAmount()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
