import 'package:flutter/material.dart';

class CustomAlertDialogue extends StatelessWidget {
  final errorMessage;
  final Function onTap;
  CustomAlertDialogue({required this.errorMessage, required this.onTap});
  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Container(
        width: double.infinity,
        color: Color(0xffF7BC14),
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(Icons.error_outline)),
            Expanded(
              child: Text(
                errorMessage,
                maxLines: 3,
              ),
            ),
            IconButton(icon: Icon(Icons.close), onPressed: onTap as void Function()?)
          ],
        ),
      );
    }
    return SizedBox(
      height: 0.0,
    );
  }
}
