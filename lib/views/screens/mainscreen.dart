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
          // IconButton(
          //     onPressed: _loginButton, icon: const Icon(Icons.account_circle))
          verifyLogin(),
        ],
      ),
      body: const Center(child: Text("No search and book functions yet")),
    );
  }

  Widget verifyLogin() {
    if (widget.user.id.toString() == "0" &&
        widget.user.email.toString() == "unregistered") {
      return IconButton(
          onPressed: _loginButton, icon: const Icon(Icons.account_circle));
    } else {
      return PopupMenuButton<int>(
        icon: const Icon(Icons.account_circle),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 1,
            child: Text('Profile'),
          ),
          const PopupMenuItem(
            value: 2,
            child: Text('My Homestay'),
          ),
          const PopupMenuItem(
            value: 3,
            child: Text('Logout'),
          ),
        ],
        onSelected: (value) {
          if (value == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => ProfileScreen(user: widget.user)));
          } else if (value == 2) {
            
          } else if (value == 3) {
            _logoutUser();
          }
        },
      );
    }
  }

  // login method to let user go to login screen
  void _loginButton() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }

  // Method that let user to log out
  void _logoutUser() {
    User user = User(
        id: "0",
        email: "unregistered",
        name: "unregistered",
        address: "na",
        phone: "0123456789",
        regdate: "0");
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (content) => MainScreen(user: user)));
  }
}
