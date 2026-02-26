import 'package:flutter/material.dart';
import 'package:liciouss/screens/home_Screen.dart';

class SearchScreen extends StatefulWidget {
  final Function(String)? onProductSelected;
  const SearchScreen({super.key, this.onProductSelected});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  final List<String> allProducts = [
    "All",
    "Chicken",
    "Chicken Breast",
    "Mutton",
    "Fish",
    "Prawns",
    "Cold Cuts",
  ];

  List<String> filtered = [];

  @override
  void initState() {
    super.initState();
    filtered = allProducts;
    Future.delayed(const Duration(milliseconds: 300), () {
      _focusNode.requestFocus();
    });
  }

  void onSearch(String value) {
    setState(() {
      if (value.isEmpty) {
        filtered = allProducts;
      } else {
        filtered = allProducts
            .where((e) => e.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ MUST
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onChanged: onSearch,
                        onTap: () {
                          setState(() {
                            filtered = allProducts; // 👈 tap = show all
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search products',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: filtered.map((item) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomeContent()
                          ),
                        );
                      },
                      child: Chip(
                        label: Text(item),
                        avatar: const Icon(Icons.search, size: 16),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
