import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    List items = widget.order['items'] ?? [];

    String formattedDate = widget.order['date'] != null
        ? DateFormat('dd MMM yyyy')
            .format(DateTime.parse(widget.order['date']))
        : "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        centerTitle: false,
      ),
      body: Column(
        children: [
          /// MAP IMAGE
          // Image.asset(
          //   'assets/images/world-map.jpg',
          //   width: double.infinity,
          //   height: 180,
          //   fit: BoxFit.cover,
          // ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ORDER SUMMARY
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade100,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order ID : #111${widget.order["id"] ?? 1}",
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Date : $formattedDate",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "pending",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ADDRESS
                  const Text(
                    "Delivered to",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    widget.order["address"] ?? "No address found",
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  /// ITEMS TITLE
                  const Text(
                    "Items",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// ITEMS LIST
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                item['image'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              item['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              "Qty : ${item['quantity']}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: Text(
                              "₹${item['price']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(),

                  /// TOTAL
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Amount",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "₹${widget.order["total"]}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}