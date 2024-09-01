import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/components/Mydrawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  User? user = FirebaseAuth.instance.currentUser;
  GlobalKey<ScaffoldState> skaffoldkey = GlobalKey();

  String newCategoryName = '';

  Future<void> addCategory(String categoryName) {
    return categories
        .add({'id': user!.uid, 'name': categoryName})
        .then((value) => print("Category Added"))
        .catchError((error) => print("Failed to add category: $error"));
  }

  List<DocumentSnapshot> categoriesData = [];

  Future<void> getData() async {
    QuerySnapshot snapshot = await categories.get();
    categoriesData = snapshot.docs;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Color pickcolor() {
    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.pink,
      Colors.orange,
      Colors.yellow,
      Colors.white,
      Colors.black,
      Colors.purple,
      Colors.cyan,
      Colors.lime,
      Colors.indigo,
      Colors.teal,
      Colors.brown,
      Colors.grey,
      Colors.amber,
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.blueGrey,
      Colors.cyanAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.pinkAccent,
      Colors.purpleAccent,
      Colors.redAccent,
      Colors.yellowAccent,
      Colors.indigoAccent,
      Colors.deepOrangeAccent,
      Colors.deepPurpleAccent,
      Colors.lightBlueAccent,
      Colors.lightGreenAccent,
      Colors.tealAccent,
      Colors.amberAccent,
      Colors.blueAccent,
      Colors.limeAccent,
      Colors.white70,
      Colors.black87,
      Colors.grey.shade50,
      Colors.grey.shade100,
      Colors.grey.shade200,
      Colors.grey.shade300,
      Colors.grey.shade400,
      Colors.grey.shade500,
      Colors.grey.shade600,
      Colors.grey.shade700,
      Colors.grey.shade800,
      Colors.grey.shade900,
    ];

    // Create a Random instance
    final random = Random();

    // Select a random index from the list
    int randomIndex = random.nextInt(colors.length);

    // Get the random color from the list
    Color randomColor = colors[randomIndex];
    return randomColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: skaffoldkey,
      backgroundColor: const Color(0xff222b31),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          skaffoldkey.currentState!.showBottomSheet(
            backgroundColor: const Color(0xff222b31),
            (context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff7d1416),
                            width: 2,
                          ),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        labelText: 'Category Name',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        newCategoryName = value; // Capture the input value
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Color(0xff7d1416)),
                      ),
                      onPressed: () {
                        if (newCategoryName.isNotEmpty) {
                          addCategory(newCategoryName);
                          Navigator.pop(context); // Close the bottom sheet
                          getData();
                        }
                      },
                      child: const Text(
                        'Add Category',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: const Color(0xff7d1416),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      drawer: Mydrawer(),
      appBar: AppBar(
        title: const Text("Library"),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: InkWell(
              onTap: () {},
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          )
        ],
        backgroundColor: const Color(0xff7d1416),
      ),
      body: GridView.builder(
        itemCount: categoriesData.length, // Use the length of the data list
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, i) {
          Color color = pickcolor();
          return Card(
            color: color,
            child: Center(
              child: Text(
                categoriesData[i]['name'],
                textAlign: TextAlign.center, // Display the category name
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color.computeLuminance() < 0.5
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }
}
