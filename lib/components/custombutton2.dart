import 'package:flutter/material.dart';

class Custombutton2 extends StatelessWidget {
  const Custombutton2({super.key, required this.text, this.onpressed});
  final String text;
  final Function()? onpressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        height: 40,
        minWidth: double.infinity,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              width: 2,
              color: Color(0xff440101),
            )),
        onPressed: onpressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
