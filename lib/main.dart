import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebaseproject/screens/homepage.dart';
import 'package:firebaseproject/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAcFYlgq4MvP2L75pR7TnvW1KIyONNrjus',
      appId: '1:502623627678:android:0ad8a993f8ab38854b0e8f',
      messagingSenderId: '502623627678',
      projectId: 'firbase-flutter112',
      storageBucket: 'firbase-flutter112.appspot.com',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void gettoken() async {
    String? mytoken = await FirebaseMessaging.instance.getToken();
    print(mytoken);
  }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    gettoken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null
          ? const Login()
          : const Homepage(),
      routes: {
        "homepage": (context) => const Homepage(),
        "login": (context) => const Login()
      },
    );
  }
}
