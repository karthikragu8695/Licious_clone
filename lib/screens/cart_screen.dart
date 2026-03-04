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
  }

  /// 🔹 Save updated cart
  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> updatedList = cartItems
        .map((item) => jsonEncode(item.toJson()))
        .toList();

    await prefs.setStringList('cart', updatedList);
    setState(() {});
  }

  /// 🔹 Increase Quantity
  void increaseQty(int index) {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ?
                  /// 🔹 Empty Cart UI
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/card_image.gif',
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Your Cart is Empty ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                :
                  /// 🔹 Cart Items UI
                  ListView(
                    children: [
                      /// 🔹 Offer Banner (Only Once)
                      Container(
                        width: double.infinity,
                        color: Colors.greenAccent,
                        padding: const EdgeInsets.all(10),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("😍", style: TextStyle(fontSize: 24)),
                                SizedBox(width: 8),
                                Text("You have saved ₹36!"),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text("Shop for ₹25 more to save ₹50 | 20% FLAT"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// 🔹 Cart Items List
                      ...cartItems.asMap().entries.map((entry) {
                        int index = entry.key;
                        CartItem item = entry.value;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                /// 🔹 Item Row
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Image.asset(
                                        item.image ??
                                            'assets/images/defalut_image.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "₹${item.price * item.quantity}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                /// 🔹 Quantity + Remove
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
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          cartItems.removeAt(index);
                                        });
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

                      /// 🔹 Bill Summary
                      const Padding(
                        padding: EdgeInsets.all(10),
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
                        padding: const EdgeInsets.all(15),
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
                                fontSize: 16,
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
