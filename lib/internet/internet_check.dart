import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(
              'assets/images/original-8b1e03333efb9d4698ab615041fe19ec.gif',
              height: 200,
            ),

            const SizedBox(height: 20),

            const Text(
              "No Internet Connection",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Please check your connection",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // retry
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}