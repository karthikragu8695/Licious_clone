import 'package:flutter/material.dart';
import 'package:liciouss/login/Login_Screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:licious/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://xhzwuqmfwikwirxrhkcq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhoend1cW1md2lrd2lyeHJoa2NxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQwNTIwMDcsImV4cCI6MjA4OTYyODAwN30.AGdw9S_G83Ad3YGuisafCkUhyIokcMsih3H_B1RhKkk',
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
