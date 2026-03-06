import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:liciouss/screens/address_page.dart';
import 'package:liciouss/screens/home_content.dart';
import '../datas/cart_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<String> address = [];
  List<CartItem> cartItems = [];

  Future<void> loadAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getStringList('address_list') ?? [];
    });
  }

  int deliveryFee = 39;
  int handlingFee = 5;
  int savings = 36;

  @override
  void initState() {
    super.initState();
    loadCartItems();
    loadAddress();
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
                          height: 300,
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
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₹${item.oldprice * item.quantity}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "₹${item.price * item.quantity}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                /// 🔹 Item Row
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRect(
                                        child: Image.asset(
                                          item.image ??
                                              'assets/images/defalut_image.png',
                                          fit: BoxFit.cover,
                                          width: 60,
                                          height: 60,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,

                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            item.weight ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 35,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () =>
                                                    decreaseQty(index),
                                                icon: const Icon(
                                                  Icons.remove,
                                                  color: Color(0xFF8E0038),
                                                  size: 15,
                                                ),
                                              ),
                                              Text(
                                                item.quantity.toString(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () =>
                                                    increaseQty(index),
                                                icon: const Icon(
                                                  Icons.add,
                                                  color: Color(0xFF8E0038),
                                                  size: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // TextButton(
                                        //   onPressed: () {
                                        //     setState(() {
                                        //       cartItems.removeAt(index);
                                        //     });
                                        //     saveCart();
                                        //   },
                                        //   child: const Text(
                                        //     "Remove",
                                        //     style: TextStyle(color: Colors.red),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                /// 🔹 Quantity + Remove
                              ],
                            ),
                          ),
                        );
                      }),

                      /// 🔹 Bill Summary
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              "Bill Summary",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "----------------------------------------------------",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),

                      //const Divider(),
                      ListTile(
                        title: const Text("Item total"),
                        trailing: Text("₹${getItemTotal()}"),
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            const Text("Delivery Fee"),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.privacy_tip_rounded,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        trailing: Text("₹$deliveryFee"),
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            const Text("Handling Fee"),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.privacy_tip_rounded,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ],
                        ),
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
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Policies",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "-------------------------------------------------------------",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// Privacy Policy
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.privacy_tip_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Your personal details like name, phone number and address "
                                    "are safe with us and will only be used for order delivery.",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// Delivery Policy
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.local_shipping_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Orders are delivered within the estimated delivery time. "
                                    "Delivery charges may apply depending on location.",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// Cancellation Policy
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.cancel_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Orders can be cancelled before they are packed. "
                                    "Once packed or shipped, cancellation may not be possible.",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          cartItems.isEmpty
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8E0038),
                      ),
                      onPressed: ()async{
                        if(address.isEmpty){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>const 
                            AddressPage()
                          )).then((_){
                            loadAddress();
                          });
                        }else{
                          print('Place order');
                          setState(() {
                          cartItems.clear();
                          saveCart();
                            
                          });
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(name: 'guest')));
                        }
                      },
                      child: Container(
                        width: double.infinity,

                        child: Center(
                          child: Text(
                            address.isEmpty
                                ? 'Add Address'
                                : "Pay ₹${getFinalAmount()}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
