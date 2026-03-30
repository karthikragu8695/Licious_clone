import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  String selectedMethod = "UPI";

  Widget paymentTile(String title, IconData icon) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF8E0038)),
        title: Text(title),
        trailing: Radio(
          value: title,
          groupValue: selectedMethod,
          onChanged: (value) {
            setState(() {
              selectedMethod = value!;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Method"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Choose Payment Method",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            paymentTile("UPI", Icons.account_balance_wallet),
            paymentTile("Credit / Debit Card", Icons.credit_card),
            paymentTile("Net Banking", Icons.account_balance),
            paymentTile("Cash on Delivery", Icons.money),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E0038),
                ),
                onPressed: () {
                  print("Selected Payment: $selectedMethod");
                },
                child: TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text(
                  "Continue",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),) 
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}