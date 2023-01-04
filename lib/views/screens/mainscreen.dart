import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'loginscreen.dart';
import 'profilescreen.dart';

// Main screen for the Homestay Raya application
class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homestay Raya"),
        actions: [
          IconButton(
              onPressed: _loginButton, icon: const Icon(Icons.account_circle))
        ],
      ),
      body: const Center(child: Text("No search and book functions yet")),
    );
  }

  // login method to let user go to login screen
  void _loginButton() {
    if (widget.user.id.toString() == "0" &&
        widget.user.email.toString() == "unregistered") {
      Navigator.push(context,
          MaterialPageRoute(builder: (content) => const LoginScreen()));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => ProfileScreen(user: widget.user)));
    }
  }
}
