import 'package:flutter/material.dart';
import 'package:liciouss/login/otp_Screen.dart';
import 'package:liciouss/screens/shimmer_Loding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  
  

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
void initState() {
  super.initState();
  checkLogin();
}

void checkLogin() async {
  final prefs = await SharedPreferences.getInstance();
  String? phone = prefs.getString('phone_number');

  if (phone != null && mounted) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ShimmerLoadingScreen(),
      ),
    );
  }
}
  final TextEditingController phoneController = TextEditingController();
  bool isLogin = true;
  bool isLoading = false;

  Future<void> continueWithPhone() async {
    final phone = phoneController.text.trim();

    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid phone number")),
      );
      return;
    }

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // simulate API

    setState(() => isLoading = false);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>  Otp_Screen(phonenumer: phone,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 30),

              const Text(
                "Welcome to Licious 👋",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Text(
                isLogin
                    ? "Login with your phone number"
                    : "Create account with phone number",
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 40),

              /// Toggle
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => isLogin = true),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isLogin ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => setState(() => isLogin = false),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: !isLogin ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Phone Field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Text(
                      "+91",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter phone number",
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : continueWithPhone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBC1944),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isLogin ? "LOGIN" : "SIGN UP",
                          style: const TextStyle(fontSize: 16,color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "By continuing, you agree to our Terms & Privacy Policy",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}