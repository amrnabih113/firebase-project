// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/components/custombutton2.dart';
import 'package:firebaseproject/components/customebutton.dart';
import 'package:firebaseproject/components/customeicon.dart';
import 'package:firebaseproject/components/custometextfield.dart'; // Ensure this import is correct
import 'package:firebaseproject/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // If the user cancels the sign-in process, return null
    if (googleUser == null) {
      return null; // Changed from returning an empty return
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Navigate to the homepage after successful sign-in
    Navigator.of(context).pushReplacementNamed("homepage");

    // Return the UserCredential
    return userCredential;
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified) {
        Navigator.of(context).pushReplacementNamed("homepage");
      } else {
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
        _showErrorDialog("Check your mail to verify");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErrorDialog('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _showErrorDialog('Wrong password provided for that user.');
      } else if (e.code == 'too-many-requests') {
        _showErrorDialog(
            'Too many attempts. Please try again later or reset your password.');
      } else {
        _showErrorDialog('An error occurred. Please try again.');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff222b31),
          title: const Text(
            'Error',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xff7d1416)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff222b31),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Hide keyboard
        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Welcome back,',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to continue',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomeTextField(
                      controller: _emailController,
                      ispassword: false,
                      hint: "Email",
                      icon: const Icon(Icons.mail, color: Color(0xff7d1416)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomeTextField(
                      controller: _passwordController,
                      ispassword: true,
                      hint: "Password",
                      icon: const Icon(Icons.lock, color: Color(0xff7d1416)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        // Add additional password validation if needed
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  rememberMe = newValue!;
                                });
                              },
                              activeColor: const Color(0xff440101),
                            ),
                            const Text(
                              'Remember me',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () async {
                            if (_emailController.text.isNotEmpty) {
                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                  email: _emailController.text,
                                );
                                _showErrorDialog(
                                    "Check your mail to reset password");
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  _showErrorDialog(
                                      'No user found for that email.');
                                } else if (e.code == 'invalid-email') {
                                  _showErrorDialog(
                                      'The email address is not valid.');
                                } else {
                                  _showErrorDialog(
                                      'An error occurred. Please try again.');
                                }
                              } catch (e) {
                                _showErrorDialog(
                                    'An unexpected error occurred. Please try again.');
                              }
                            } else {
                              _showErrorDialog("The Email is Empty!");
                            }
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Color(0xff7d1416)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Customebutton(
                            onpressed: _login,
                            text: "Log in",
                          ),
                    const SizedBox(height: 16),
                    Custombutton2(
                      text: 'Create account',
                      onpressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Signup(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      ' - Or sign in with - ',
                      style: TextStyle(color: Color(0xff7d1416), fontSize: 15),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Customeicon(
                          imageurl: "images/google_logo.png",
                          onTap: signInWithGoogle,
                        ),
                        const SizedBox(width: 30),
                        Customeicon(imageurl: "images/facebook-logo.png"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
