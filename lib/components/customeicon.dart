import 'package:flutter/material.dart';

class Customeicon extends StatelessWidget {
  Customeicon({super.key, required this.imageurl, this.onTap});
  String imageurl;
  void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        color: const Color(0xff222b31),
        child: Image.asset(
          imageurl,
          height: 40,
          width: 0,
        ),
      ),
    );
  }
}
