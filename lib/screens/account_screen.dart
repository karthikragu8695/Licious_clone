import 'package:flutter/material.dart';
import 'package:liciouss/DetailScreen/account_edit.dart';
import 'package:liciouss/login/Login_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String name = '';
  String phone = "";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = prefs.getString('phone') ?? "";
      name = prefs.getString('name') ?? "Guest";
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi $name',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    phone.isEmpty ? 'Guest User' : '$phone | $phone@guest.in',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Spacer(),
                  TextButton(
                    
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AccountEditScreen(),
                        ),
                      );

                      loadUser(); // 🔥 Back vandha udane refresh
                    },
                    child: Text(
                      "Edit",
                      style: TextStyle(
                        color: Color(0XFFD32F2F),
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// OFFER BANNER
              Container(
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5A0035), Color(0xFF8E0038)],
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Row(
                  children: [
                    Text(
                      "Flat 10% Cashback &\nFree Delivery on All Orders",
                      style: TextStyle(color: Colors.white),
                    ),
                    Spacer(),
                    Text('Explore', style: TextStyle(color: Color(0xffead942))),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView(
                  children: [
                    const Divider(),
                    const AccountItem(
                      icon: Icons.shopping_bag_outlined,
                      title: "Orders",
                      subtitle: "Order Placed : 0",
                    ),
                    const Divider(),

                    const AccountItem(
                      icon: Icons.credit_card_outlined,
                      title: "Payment Methods",
                      subtitle: "Saved cards & UPI IDs",
                    ),
                    const Divider(),

                    const AccountItem(
                      icon: Icons.location_on_outlined,
                      title: "Address",
                      subtitle: "No Saved Address",
                    ),
                    const Divider(),

                    const SizedBox(height: 10),

                    /// LOGOUT
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: logout,
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const AccountItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
