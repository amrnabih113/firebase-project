import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/components/customebutton.dart';
import 'package:firebaseproject/components/customeicon.dart';
import 'package:firebaseproject/components/custometextfield.dart';
import 'package:firebaseproject/homepage.dart';
import 'package:firebaseproject/login.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  FocusNode focusNode = FocusNode();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    focusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (_passwordController.text != _confirmpasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match.";
        _isLoading = false;
      });
      return;
    }

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.of(context).pushReplacementNamed("homepage");
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'weak-password') {
          _errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          _errorMessage = 'The account already exists for that email.';
        } else {
          _errorMessage = 'An unexpected error occurred. Please try again.';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
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
          setState(() {
            focusNode.unfocus();
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                controller: _emailController,
                hint: "Email",
                icon: const Icon(Icons.email, color: Color(0xff7d1416)),
                ispassword: false,
              ),
              const SizedBox(height: 16),
              CustomeTextField(
                controller: _passwordController,
                hint: "Password",
                icon: const Icon(Icons.lock, color: Color(0xff7d1416)),
                ispassword: true,
              ),
              const SizedBox(height: 16),
              CustomeTextField(
                controller: _confirmpasswordController,
                hint: "Confirm Password",
                icon: const Icon(Icons.lock, color: Color(0xff7d1416)),
                ispassword: true,
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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: const Text(
                    'Back to Login',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                ' - Or sign up with - ',
                style: TextStyle(color: Color(0xff7d1416), fontSize: 15),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Customeicon(imageurl: "images/google_logo.png"),
                  const SizedBox(width: 30),
                  Customeicon(imageurl: "images/facebook-logo.png")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
