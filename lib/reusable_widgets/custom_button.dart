import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final Color colour;
  CustomButton(
      {required this.onTap, required this.colour, required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onTap as void Function()?,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
