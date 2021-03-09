import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget leading;
  final List<Widget> actions;
  final Widget title;
  final BuildContext? context;
  CustomAppBar({
    this.context,
    required this.actions,
    required this.title,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Colors.blueAccent,
          ),
        ),
      ),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: leading,
        ),
        title: title,
        actions: actions,
      ),
    );
  }

  final Size preferredSize = Size.fromHeight(kToolbarHeight + 5.0);
}
