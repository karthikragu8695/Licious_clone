import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Terms & Conditions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 15),

              Text(
                "1. Orders",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "All orders placed through the app are subject to availability. "
                "We reserve the right to cancel or refuse any order if required.",
              ),

              SizedBox(height: 15),

              Text(
                "2. Payments",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "Payments can be made using available payment methods such as "
                "UPI, debit/credit cards, net banking, or cash on delivery.",
              ),

              SizedBox(height: 15),

              Text(
                "3. Delivery",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "Delivery times are estimates and may vary depending on location "
                "and other factors such as weather or traffic conditions.",
              ),

              SizedBox(height: 15),

              Text(
                "4. Cancellation",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "Orders can be cancelled before they are packed. Once the order "
                "is packed or shipped, cancellation may not be possible.",
              ),

              SizedBox(height: 15),

              Text(
                "5. Privacy",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "Your personal information such as name, phone number, and "
                "delivery address will only be used for order processing and delivery.",
              ),

              SizedBox(height: 20),

              Text(
                "By using this application, you agree to the terms and conditions listed above.",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}