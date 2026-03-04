import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  Widget shimmerBox({double height = 100, double width = double.infinity}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: shimmerBox(height: 60),
          ), // Location bar
          shimmerBox(height: 120), // Offer banner
          const SizedBox(height: 10),

          shimmerBox(height: 20, width: 150), // Bestseller title

          const SizedBox(height: 10),

          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 12),
                  child: shimmerBox(height: 220),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          shimmerBox(height: 20, width: 180), // Category title
          shimmerBox(height: 100), 
           shimmerBox(height: 100),// Category grid
        ],
      ),
    );
  }
}
