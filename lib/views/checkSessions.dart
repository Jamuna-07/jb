import 'package:jain_buzz/auth.dart';
import 'package:jain_buzz/saved_data.dart';
import 'package:jain_buzz/views/homepage.dart';
import 'package:jain_buzz/views/login.dart';
import 'package:flutter/material.dart';

class CheckSessions extends StatefulWidget {
  const CheckSessions({super.key});

  @override
  State<CheckSessions> createState() => _CheckSessionsState();
}

class _CheckSessionsState extends State<CheckSessions> {
  @override
  void initState() {
    super.initState();
    checkSessions();
  }

  Future<bool> checkSessions() async {
    // Check if user is logged in
    String userId = SavedData.getUserId();
    if (userId.isNotEmpty) {
      // User is logged in, navigate to homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
      return true;
    } else {
      // User is not logged in, navigate to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
