import 'package:flutter/material.dart';

class Mylisttile extends StatelessWidget {
  const Mylisttile(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});
  final String title;
  final Icon icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        leading: icon,
        iconColor: const Color(0xff7d1416),
      ),
    );
  }
}
