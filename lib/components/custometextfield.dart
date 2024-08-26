import 'package:flutter/material.dart';

class CustomeTextField extends StatefulWidget {
  CustomeTextField(
      {super.key,
      required this.controller,
      required this.ispassword,
      required this.hint,
      required this.icon});
  TextEditingController controller;
  String hint;
  bool ispassword;
  Icon icon;

  @override
  State<CustomeTextField> createState() => _CustomeTextFieldState();
}

class _CustomeTextFieldState extends State<CustomeTextField> {
  bool showpasssword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.ispassword ? !showpasssword : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF55666e),
        labelText: widget.hint,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: widget.icon,
        suffixIcon: widget.ispassword
            ? !showpasssword
                ? IconButton(
                    icon: const Icon(Icons.visibility),
                    color: const Color(0xff7d1416),
                    onPressed: () {
                      setState(() {
                        showpasssword = !showpasssword;
                      });
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.visibility_off_sharp),
                    color: Colors.white70,
                    onPressed: () {
                      setState(() {
                        showpasssword = !showpasssword;
                      });
                    },
                  )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
