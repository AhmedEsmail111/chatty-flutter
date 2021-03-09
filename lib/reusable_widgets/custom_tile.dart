import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final Widget title;
  final Widget? icon;
  final Widget leading;
  final Widget? trailing;
  final Widget subTitle;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  CustomTile({
    required this.leading,
    required this.title,
    required this.subTitle,
    this.onTap,
    this.icon,
    this.margin = const EdgeInsets.all(0.0),
    this.mini = true,
    this.onLongPress,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: mini ? 10 : 0),
          margin: margin,
          child: Row(
            children: [
              leading,
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: mini ? 10 : 15),
                  padding: EdgeInsets.symmetric(vertical: mini ? 3 : 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.0,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          title,
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              icon ?? Container(),
                              subTitle,
                            ],
                          )
                        ],
                      ),
                      trailing ?? Container()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
