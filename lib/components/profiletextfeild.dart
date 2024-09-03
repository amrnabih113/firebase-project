import 'package:flutter/material.dart';

class Profiletextfeild extends StatelessWidget {
  const Profiletextfeild(
      {super.key,
      required this.controller,
      required this.isEditing,
      required this.labelText});
  final TextEditingController controller;
  final bool isEditing;
  final String labelText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: isEditing,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person, color: Color(0xff7d1416)),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
