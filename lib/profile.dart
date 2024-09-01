import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isEditing = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? file;
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _emailController.text = currentUser.email ?? '';
      _usernameController.text = currentUser.displayName ?? 'Username';
      _phoneController.text = currentUser.phoneNumber ?? 'Phone Number';
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _updatePhoneNumber() async {
    final String phoneNumber = _phoneController.text;

    // Request phone number verification
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification, complete the sign-in
        await _auth.currentUser?.updatePhoneNumber(credential);
        _showSnackbar("Phone number updated successfully.");
      },
      verificationFailed: (FirebaseAuthException e) {
        _showSnackbar("Verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        // Handle code sent (you might show a dialog to input the code)
        _showSnackbar("Verification code sent to $phoneNumber");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle code auto-retrieval timeout
        _showSnackbar("Verification code timeout.");
      },
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  getimage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    file = File(image!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff222b31),
      appBar: AppBar(
        title: const Text("Profile"),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff7d1416),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipOval(
                      child: Image.asset("images/avatar.webp", height: 150),
                    ),
                    MaterialButton(
                      onPressed: () {},
                      color: const Color(0xff7d1416),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  enabled: _isEditing,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Color(0xff7d1416)),
                    labelText: "Username",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  enabled: _isEditing,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Color(0xff7d1416)),
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _phoneController,
                  enabled: _isEditing,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone, color: Color(0xff7d1416)),
                    labelText: "Phone Number",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_isEditing) {
                      try {
                        final User? user = _auth.currentUser;

                        if (user != null) {
                          await user.updateProfile(
                            displayName: _usernameController.text,
                          );
                          await _updatePhoneNumber();

                          _showSnackbar("Profile updated successfully.");
                        }
                        setState(() {
                          _isEditing = false;
                        });
                      } catch (e) {
                        _showSnackbar("Error updating profile: $e");
                      }
                    } else {
                      setState(() {
                        _isEditing = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7d1416),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    _isEditing ? 'Save' : 'Edit',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
