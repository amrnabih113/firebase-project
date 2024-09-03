// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/components/customebutton.dart';
import 'package:firebaseproject/components/customeicon.dart';
import 'package:firebaseproject/components/custometextfield.dart';
import 'package:firebaseproject/screens/login.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  FocusNode focusNode = FocusNode();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    focusNode.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    if (_passwordController.text != _confirmpasswordController.text) {
      _showErrorDialog("Passwords do not match.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      Navigator.of(context).pushReplacementNamed("login");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showErrorDialog('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showErrorDialog('The account already exists for that email.');
      } else {
        _showErrorDialog('An unexpected error occurred. Please try again.');
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _showErrorDialog(e.toString());
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
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xff7d1416)),
              ),
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
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                focusNode.unfocus();
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Form(
                key: _formKey, // Form key for validation
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign up to get started',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomeTextField(
                      controller: _usernameController,
                      hint: "Username",
                      icon: const Icon(Icons.person, color: Color(0xff7d1416)),
                      ispassword: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomeTextField(
                      controller: _emailController,
                      hint: "Email",
                      icon: const Icon(Icons.email, color: Color(0xff7d1416)),
                      ispassword: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+') // Simple email validation
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomeTextField(
                      controller: _passwordController,
                      hint: "Password",
                      icon: const Icon(Icons.lock, color: Color(0xff7d1416)),
                      ispassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomeTextField(
                      controller: _confirmpasswordController,
                      hint: "Confirm Password",
                      icon: const Icon(Icons.lock, color: Color(0xff7d1416)),
                      ispassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Customebutton(
                            onpressed: _signup,
                            text: "Sign up",
                          ),
                    const SizedBox(height: 16),
                    Center(
                      child: MaterialButton(
                        height: 40,
                        minWidth: double.infinity,
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              width: 2,
                              color: Color(0xff440101),
                            )),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                          );
                        },
                        child: const Text(
                          'Back to Login',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
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
