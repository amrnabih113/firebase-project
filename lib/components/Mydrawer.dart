import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/components/mylisttile.dart';

import 'package:firebaseproject/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Mydrawer extends StatelessWidget {
  Mydrawer({super.key});
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff222b31),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  backgroundImage: currentUser!.photoURL != null
                      ? NetworkImage(currentUser!.photoURL!)
                      : const AssetImage("images/avatar.webp") as ImageProvider,
                  minRadius: 25,
                ),
                Column(
                  children: [
                    Text(currentUser!.displayName ?? "",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${currentUser!.email}",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Mylisttile(
              title: "Profile",
              icon: const Icon(
                Icons.person,
                size: 30,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Profile()));
              },
            ),
            Mylisttile(
              title: "Log out",
              icon: const Icon(Icons.exit_to_app),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                GoogleSignIn googlesign = GoogleSignIn();
                googlesign.disconnect();
                Navigator.of(context).pushReplacementNamed("login");
              },
            )
          ],
        ),
      ),
    );
  }
}
