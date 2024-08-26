import 'package:flutter/material.dart';

class Customebutton extends StatefulWidget {
  Customebutton({super.key, required this.onpressed ,required this.text});
  void Function()? onpressed;
  String text;

  @override
  State<Customebutton> createState() => _CustomebuttonState();
}

class _CustomebuttonState extends State<Customebutton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onpressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: const Color(0xff440101),
      ),
      child: Center(
        child: Text(
         widget.text,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
