import 'package:flutter/material.dart';
import 'package:liciouss/login/Login_Screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:licious/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://zautgeaimuierzlgfxnf.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InphdXRnZWFpbXVpZXJ6bGdmeG5mIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE1MjQ0OTYsImV4cCI6MjA4NzEwMDQ5Nn0.iQbTzOEyLDhg6RTGfpvl77nK1_n9IxddaqN0MbVsIPw',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
