import 'package:flutter/material.dart';

const kTextFieldInputRegisterDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.grey),
  hintText: 'hint',
  contentPadding: EdgeInsets.symmetric(
    vertical: 10.0,
    horizontal: 20.0,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xff049EF7),
      width: 1.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xff049EF7),
      width: 2.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kTextFieldInputLoginDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.grey),
  hintText: 'hint',
  contentPadding: EdgeInsets.symmetric(
    vertical: 10.0,
    horizontal: 20.0,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xff049EF7),
      width: 1.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xff049EF7),
      width: 2.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
const kTextFieldSendMessages = InputDecoration(
  contentPadding: EdgeInsets.all(10.0),
  hintText: 'Message...',
  fillColor: Colors.white,
  filled: true,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
  border: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
);
const kBottomNavLabelSize = 15.0;
