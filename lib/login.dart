import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/components/customebutton.dart';
import 'package:firebaseproject/components/customeicon.dart';
import 'package:firebaseproject/components/custometextfield.dart';
import 'package:firebaseproject/signup.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final _emailController =
      TextEditingController(); // Changed from _usernameController
  final _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> Scaffoldkey = GlobalKey();
  FocusNode focusNode = FocusNode();
  bool rememberMe = false; // Manage the checkbox state

  // _checkuser(String email, String password) async {
  //   var response = await MyDb.getdata('''
  //             SELECT "ID"
  //             FROM "USERS"
  //             WHERE "EMAIL" = "$email"
  //             AND "PASSWORD" = "$password"
  //   ''');
  //   return response;
  // }

  // _showerrordialog() {
  //   showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //             title: const Text('Error'),
  //             content:
  //                 const Text('Incorrect email or password. Please try again.'),
  //             actions: <Widget>[
  //               TextButton(
  //                 child: const Text('OK'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop(); // Close the dialog
  //                 },
  //               ),
  //             ],
  //           ));
  // }

  // Future<void> saveuserid(int userid) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     bool result = await prefs.setInt("userid", userid);
  //     print("user id = ${prefs.getInt("userid")}, == $userid");
  //     if (!result) {
  //       print("Failed to save userid");
  //     }
  //   } catch (e) {
  //     print("Error saving userid: $e");
  //   }
  // }

  @override
  void dispose() {
    focusNode.dispose();
    _emailController.dispose(); // Changed from _usernameController
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Scaffoldkey,
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
              ),
              const SizedBox(height: 16),
              CustomeTextField(
                controller: _passwordController,
                ispassword: true,
                hint: "Password",
                icon: const Icon(Icons.lock, color: Color(0xff7d1416)),
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
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xff7d1416)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Customebutton(
                  onpressed: () async {
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }
                  },
                  text: "Log in"),
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
                            builder: (context) => const Signup()));
                  },
                  child: const Text(
                    'Create account',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
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
