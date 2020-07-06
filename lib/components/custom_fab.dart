import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final Function onTap;
  final Icon icon;
  final Alignment alignment;
  final Object heroTag;

  CustomFAB({this.onTap, this.icon, @required this.alignment, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: EdgeInsets.all(32),
      child: FloatingActionButton(
        heroTag: heroTag,
        onPressed: onTap,
        child: icon,
        // backgroundColor: Colors, //Colors.greenAccent
      ),
    );
  }
}
