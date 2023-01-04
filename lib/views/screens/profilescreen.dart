import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';

// Profile screen for the Homestay Raya application
class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _addressEditingController =
      TextEditingController();
  final TextEditingController _dateregEditingController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  // Save and Load the preference when open this screen
  @override
  void initState() {
    super.initState();
    savepref();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 150,
                  child: CircleAvatar(
                    radius: 90.0,
                    backgroundImage: AssetImage("assets/images/profile.png"),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Id: ${widget.user.id}",
                  style: const TextStyle(fontSize: 25),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  height: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(
                        controller: _nameEditingController,
                        enabled: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.person),
                          labelText: 'Name',
                        ),
                      ),
                      TextFormField(
                        controller: _emailEditingController,
                        enabled: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.email),
                          labelText: 'Email',
                        ),
                      ),
                      TextFormField(
                        controller: _phoneEditingController,
                        enabled: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.phone),
                          labelText: 'Phone',
                        ),
                      ),
                      TextFormField(
                        controller: _addressEditingController,
                        enabled: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.location_on),
                          labelText: 'Address',
                        ),
                      ),
                      TextFormField(
                        controller: _dateregEditingController,
                        enabled: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.date_range),
                          labelText: 'Date register',
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method that save user preference
  void savepref() async {
    String name = '${widget.user.name}';
    String email = '${widget.user.email}';
    String phone = '${widget.user.phone}';
    String address = '${widget.user.address}';
    String datereg = '${widget.user.regdate}';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('address', address);
    await prefs.setString('datereg', datereg);
  }

  // Method that load user preference
  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = (prefs.getString('name')) ?? '';
    String email = (prefs.getString('email')) ?? '';
    String phone = (prefs.getString('phone')) ?? '';
    String address = (prefs.getString('address')) ?? '';
    String datereg = (prefs.getString('datereg')) ?? '';
    if (name.isNotEmpty) {
      setState(() {
        _nameEditingController.text = name;
        _emailEditingController.text = email;
        _phoneEditingController.text = phone;
        _addressEditingController.text = address;
        _dateregEditingController.text = datereg;
      });
    }
  }
}
