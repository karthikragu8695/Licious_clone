import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liciouss/screens/orderDetail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
    print(orders);
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> orderList = prefs.getStringList('orders') ?? [];

    setState(() {
      orders = orderList
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList()
          .reversed
          .toList();
    });
    print("Decoded Orders: $orders");
  }

  Future<void> clearOrders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('orders');

    setState(() {
      orders.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      //Colors.grey.shade100
      appBar: AppBar(
        title: const Text("My Orders"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: clearOrders,
          ),
        ],
      ),

      body: orders.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Image(
                    image: AssetImage('assets/images/noordersYet.webp'),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'No orders',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.all(14),

              itemCount: orders.length,

              itemBuilder: (context, index) {
                final order = orders[index];
                final items = (order['items'] as List)
                    .map((item) => Map<String, dynamic>.from(item))
                    .toList();
                print(order['items']);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        /// HEADER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order #${index + 1}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: Colors.grey.shade600,
                                    ),

                                    const SizedBox(width: 6),

                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "${items.length} items",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 249, 14, 14),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "processed",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        /// ITEMS
                        ...items.map<Widget>((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),

                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    item['image'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        "Qty: ${item['quantity']}",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Text(
                                  "₹${item['price']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const Divider(height: 20),

                        /// TOTAL
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Total Amount",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "₹${order['total']}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OrderDetailsPage(order: order),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
