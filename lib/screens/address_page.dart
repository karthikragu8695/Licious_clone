import 'package:flutter/material.dart';
import 'package:liciouss/DetailScreen/address_edit.dart';
import 'package:liciouss/card/address_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List<String> address = [];

  Future<void> loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getStringList('address_list') ?? [];
    });
  }

  Future<void> saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('address_list', address);
  }

  @override
  void initState() {
    super.initState();
    loadSavedAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Addresses")),
      body: Column(
        children: [
          /// Address List
          Expanded(
            child: ListView.builder(
              itemCount: address.length,
              itemBuilder: (context, index) {
                return AddressCard(
                  address: address[index],
                  onEdit: () async {
                    final updatedAddress = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddressFormScreen(existingAddress: address[index]),
                      ),
                    );

                    if (updatedAddress != null) {
                      setState(() {
                        address[index] = updatedAddress;
                      });
                      saveAddresses();
                    }
                  }, // address pass pannunga
                  onDelete: () {
                    setState(() {
                      address.removeAt(index);
                      saveAddresses();
                    });
                  },
                );
              },
            ),
          ),
          // if (address.isEmpty)
          // ElevatedButton(
          //   onPressed: () async {
          //     final newAddress = await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const AddressFormScreen(),
          //       ),
          //     );
          //     if (newAddress != null) {
          //       setState(() {
          //         address.add(newAddress);
          //       });
          //       saveAddresses();
          //     }
          //   },
          //   child: const Text("Add Address"),
          // ),
          /// Add Address Button
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF8E0038),
              ),

              onPressed: () async {
                final newAddress = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressFormScreen(),
                  ),
                );

                if (newAddress != null) {
                  setState(() {
                    address.add(newAddress);
                  });
                  saveAddresses();
                }
              },

              child: const Text(
                "Add New Address",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
