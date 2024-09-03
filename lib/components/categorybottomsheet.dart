import 'package:flutter/material.dart';

class Categorybottomsheet extends StatelessWidget {
  const Categorybottomsheet(
      {super.key, required this.onpressed, required this.onChanged, required this.controller});
  final void Function()? onpressed;
  final void Function(String)? onChanged;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff222b31),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: controller,
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
              onChanged: onChanged),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(const Color(0xff7d1416)),
            ),
            onPressed: onpressed,
            child: const Text(
              'Add Category',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
