import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PasswordStatusIcon extends StatelessWidget {
  final Function onTap;
  final bool isHidden;
  PasswordStatusIcon({required this.onTap, required this.isHidden});
  @override
  Widget build(BuildContext context) {
    return isHidden
        ? IconButton(
            icon: Icon(
              FontAwesomeIcons.solidEyeSlash,
              color: Colors.grey,
              size: 22.0,
            ),
            onPressed: onTap as void Function()?)
        : IconButton(
            icon: Icon(
              FontAwesomeIcons.solidEye,
              color: Colors.grey,
              size: 24.0,
            ),
            onPressed: onTap as void Function()?);
  }
}
