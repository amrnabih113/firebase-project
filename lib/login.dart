import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/components/custombutton2.dart';
import 'package:firebaseproject/components/customebutton.dart';
import 'package:firebaseproject/components/customeicon.dart';
import 'package:firebaseproject/components/custometextfield.dart'; // Ensure this import is correct
import 'package:firebaseproject/signup.dart';
import 'package:flutter/material.dart';

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
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return; // Validate form

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.of(context).pushReplacementNamed("homepage");
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          _errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          _errorMessage = 'Wrong password provided for that user.';
        } else if (e.code == 'too-many-requests') {
          _errorMessage =
              'Too many attempts. Please try again later or reset your password.';
        } else {
          _errorMessage = 'An error occurred. Please try again.';
        }
        _isLoading = false;
      });
    }
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
                          return 'Please enter a vaild email';
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
                          onPressed: () {
                            // Add functionality for forgotten password
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Color(0xff7d1416)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    if (_errorMessage != null) ...[
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                    ],
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
                        Customeicon(imageurl: "images/google_logo.png"),
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
