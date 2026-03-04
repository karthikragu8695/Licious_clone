import 'package:flutter/material.dart';
import 'package:liciouss/screens/home_content.dart';
import 'package:liciouss/screens/shimmer_list.dart';

class ShimmerLoadingScreen extends StatelessWidget {
  const ShimmerLoadingScreen({super.key});

  Future<Widget> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return const HomeScreen(name: 'Guest');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Widget>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ShimmerList();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            return snapshot.data!;
          }
        },
      ),
    );
  }
}