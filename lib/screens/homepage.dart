// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/components/Mydrawer.dart';
import 'package:firebaseproject/components/categorybottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  final User? user = FirebaseAuth.instance.currentUser;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final TextEditingController categoryController = TextEditingController();

  String newCategoryName = '';
  List<DocumentSnapshot> categoriesData = [];

  Future<void> addCategory(String categoryName) async {
    try {
      await categories.add({'id': user!.uid, 'name': categoryName});
      print("Category Added");
      getData();
    } catch (error) {
      print("Failed to add category: $error");
    }
  }

  Future<void> getData() async {
    QuerySnapshot snapshot = await categories.get();
    setState(() {
      categoriesData = snapshot.docs;
    });
  }

  void _showDialog(String categoryName, String docId) {
    categoryController.text = categoryName;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff222b31),
          title: Text(
            categoryName,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Column(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      Text(
                        'Remove',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('categories')
                        .doc(docId)
                        .delete();
                    Navigator.of(context).pop();
                    getData(); // Refresh the data after deletion
                  },
                ),
                TextButton(
                  child: const Column(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.green,
                      ),
                      Text(
                        'Edit',
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    scaffoldKey.currentState!.showBottomSheet(
                      (context) {
                        return Categorybottomsheet(
                          controller: categoryController,
                          onChanged: (value) {
                            newCategoryName = value; // Capture the input value
                          },
                          onpressed: () async {
                            if (categoryController.text.isNotEmpty) {
                              await FirebaseFirestore.instance
                                  .collection('categories')
                                  .doc(docId)
                                  .update({'name': categoryController.text});
                              Navigator.pop(context); // Close the bottom sheet
                              getData(); // Refresh the data after updating
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  final List<Color> colors = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xff222b31),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scaffoldKey.currentState!.showBottomSheet(
            (context) {
              return Categorybottomsheet(
                controller: TextEditingController(),
                onpressed: () {
                  if (newCategoryName.isNotEmpty) {
                    addCategory(newCategoryName);
                    Navigator.pop(context); // Close the bottom sheet
                  }
                },
                onChanged: (value) {
                  newCategoryName = value; // Capture the input value
                },
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
          Color color = colors[i % colors.length];
          return InkWell(
            onLongPress: () {
              _showDialog(categoriesData[i]['name'], categoriesData[i].id);
            },
            child: Card(
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
            ),
          );
        },
      ),
    );
  }
}
