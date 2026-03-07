import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:liciouss/datas/cart_items.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),actions: [
          IconButton(onPressed: ()async{
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('orders');
            setState(() {
              orders.clear();
              
            });
            Navigator.pop(context, true);
          }, icon: Icon(Icons.clear_all))
        ],),

      body: orders.isEmpty
          ? const Center(
              child: Text("No Orders Yet", style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final items = order['items'];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(12),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delivered on ${order['date']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 10),

                        ...items.map<Widget>((item) {
                          return ListTile(
                            leading: Image.asset(
                              item['image'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),

                            title: Text(item['name']),

                            subtitle: Text("Qty: ${item['quantity']}"),

                            trailing: Text("₹${item['price']}"),
                          );
                        }).toList(),

                        const Divider(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            Text(
                              "₹${order['total']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
