import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:liciouss/screens/cart_screen.dart';
//import 'package:liciouss/screens/categories_screen.dart';
import 'package:liciouss/screens/home_content.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otp_Screen extends StatefulWidget {
  String phonenumer;
  Otp_Screen({super.key, required this.phonenumer});

  @override
  State<Otp_Screen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<Otp_Screen> {
  final int otpLength = 6;

  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  Timer? _timer;
  int _secondsRemaining = 30;
  bool canResend = false;

  @override
  void initState() {
    super.initState();

    controllers = List.generate(otpLength, (index) => TextEditingController());
    focusNodes = List.generate(otpLength, (index) => FocusNode());

    startTimer();

    // Auto focus first box
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNodes[0].requestFocus();
    });
  }

  void startTimer() {
    _timer?.cancel(); // Cancel old timer if exists

    setState(() {
      _secondsRemaining = 30;
      canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  String getOtp() {
    return controllers.map((e) => e.text).join();
  }

  void verifyOtp() async {
    String otp = getOtp();

    if (otp.length != otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter complete OTP")),
      );
      return;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(otp)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid OTP format")));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("OTP Verified Successfully")));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone_number', widget.phonenumer);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(name: 'Guest')),

      (route) => false,
    );
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  Widget buildOtpBox(int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < otpLength - 1) {
              focusNodes[index + 1].requestFocus();
            } else {
              focusNodes[index].unfocus();
              verifyOtp();
            }
          } else {
            if (index > 0) {
              focusNodes[index - 1].requestFocus();
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            const Text(
              "Enter 6 Digit OTP",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(otpLength, (index) => buildOtpBox(index)),
            ),

            const SizedBox(height: 30),

            canResend
                ? TextButton(
                    onPressed: () {
                      startTimer();
                      // Call resend OTP API here
                    },
                    child: const Text("Resend OTP"),
                  )
                : Text(
                    "Resend in $_secondsRemaining seconds",
                    style: const TextStyle(color: Colors.grey),
                  ),
          ],
        ),
      ),
    );
  }
}
