import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/components/customebutton.dart';
import 'package:firebaseproject/components/profiletextfeild.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  File? file;
  bool _isEditing = false;
  String? _imageUrl;

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
      _imageUrl = currentUser.photoURL; // Load the image URL if available
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

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.currentUser?.updatePhoneNumber(credential);
        _showSnackbar("Phone number updated successfully.");
      },
      verificationFailed: (FirebaseAuthException e) {
        _showSnackbar("Verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        _showSnackbar("Verification code sent to $phoneNumber");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _showSnackbar("Verification code timeout.");
      },
    );
  }

  Future<void> _updateData() async {
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
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        file = File(image.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (file == null) return;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${_auth.currentUser!.uid}.jpg');
      final uploadTask = storageRef.putFile(file!);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        _imageUrl = downloadUrl;
        _auth.currentUser!.updatePhotoURL(_imageUrl);
      });
      _showSnackbar("Image updated successfully.");
    } catch (e) {
      _showSnackbar("Error uploading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
                      child: file != null
                          ? Image.file(file!,
                              height: 150, width: 150, fit: BoxFit.cover)
                          : _imageUrl != null
                              ? Image.network(_imageUrl!,
                                  height: 150, width: 150, fit: BoxFit.cover)
                              : Image.asset("images/avatar.webp", height: 150),
                    ),
                    MaterialButton(
                      onPressed: () {
                        scaffoldKey.currentState!.showBottomSheet(
                          shape: const ContinuousRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          (context) {
                            return Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xff222b31)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              height: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        child: Icon(
                                          Icons.camera,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Camera",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: _getImage,
                                        child: const Icon(
                                          Icons.photo,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        "Gallery",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
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
                Profiletextfeild(
                  controller: _usernameController,
                  isEditing: _isEditing,
                  labelText: "Username",
                ),
                const SizedBox(height: 10),
                Profiletextfeild(
                  controller: _emailController,
                  isEditing: _isEditing,
                  labelText: "Email",
                ),
                const SizedBox(height: 10),
                Profiletextfeild(
                  controller: _phoneController,
                  isEditing: _isEditing,
                  labelText: "Phone Number",
                ),
                const SizedBox(height: 30),
                Customebutton(
                  onpressed: _updateData,
                  text: _isEditing ? 'Save' : 'Edit',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
