import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  // ColdCuts items
  final List<Map<String, String>> items = const [
    {
      'name': 'Sausages',
      'image': 'assets/images/sausages.png',
    },
    {
      'name': 'frankfurter',
      'image': 'assets/images/frankfurter.png',
    },
  ];
  // Chicken items
  final List<Map<String, String>> Chicken_items = const [
    {
      'name': 'Curry Cuts',
      'image': 'assets/images/ChickenCurryCut.png',
    },
    {
      'name': 'Boneless & \n Mince',
      'image': 'assets/images/boneless.png',
    },
    {
      'name': 'Speciality \n Cuts',
      'image': 'assets/images/speialityCuts.png',
    },
    {
      'name': 'Combos',
      'image': 'assets/images/livercombos.png',
    },
  ];
  // Mutton items
  final List<Map<String, String>> Mutton_items = const [
    {
      'name': 'Curry Cuts',
      'image': 'assets/images/MuttonCurryCut.png',
    },
    {
      'name': 'Boneless & \n Mince',
      'image': 'assets/images/MuttonBoneless.png',
    },
    {
      'name': 'Speciality \n Cuts',
      'image': 'assets/images/Muttonspeciality.png',
    },
    {
      'name': 'Combos',
      'image': 'assets/images/MuttonLiver.webp',
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    appBar: AppBar(
      title: const Text(
        'All Categories',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

      body: ListView(
        
        children: [
          ExpansionTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/coldCuts.png'),
            ),
            title: const Text(
              'Cold Cuts',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Crafted by master chefs'),
            children: [
              GridView.builder(
                padding: const EdgeInsets.all(12),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(item['image']!),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['name']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          // chicken items
          ExpansionTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/CHICKEN1.jpg'),
            ),
            title: const Text(
              'Chicken',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Chicken'),
            children: [
              GridView.builder(
                padding: const EdgeInsets.all(12),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: Chicken_items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final chickenItem = Chicken_items[index];
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(chickenItem['image']!),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        chickenItem['name']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          // Mutton items
          ExpansionTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/MUTTON.jpg'),
            ),
            title: const Text(
              'Mutton',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Mutton'),
            children: [
              GridView.builder(
                padding: const EdgeInsets.all(12),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: Mutton_items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final muttonItem = Mutton_items[index];
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(muttonItem['image']!),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        muttonItem['name']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
