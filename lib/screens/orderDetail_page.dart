import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map order;

  OrderDetailsPage({super.key, required this.order});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    List items = widget.order['items'] ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order ID : ${widget.order["id"] ?? 1}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text("Date : $formattedDate"),

            const SizedBox(height: 10),

            Text("Total Amount : ${widget.order["total"]}"),

            const SizedBox(height: 10),

            Text(
              "Status : ${"Delivered"}",
              style: const TextStyle(color: Colors.green),
            ),

            const Divider(height: 30),

            const Text(
              "Items  ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  return ListTile(
                    leading: Image.asset(
                      item['image'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),

                    title: Text(item['name']),

                    subtitle: Text("Qty: ${item['quantity']}"),

                    trailing: Text(
                      "₹${item['price']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
