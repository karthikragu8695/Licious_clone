import 'package:flutter/material.dart';
import 'package:liciouss/screens/account_screen.dart';
import 'package:liciouss/screens/categories_screen.dart';
import 'package:liciouss/screens/home_Screen.dart';
import '../screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  final String name;

  const HomeScreen({super.key, required this.name});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [HomeContent(), CategoriesScreen(),SearchScreen(),AccountScreen()],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Licious'),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
