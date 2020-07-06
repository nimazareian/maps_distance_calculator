import 'package:flutter/material.dart';

class TotalDistanceContainer extends StatelessWidget {
  final String text;

  TotalDistanceContainer({this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 60,
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
            bottom: 32,
          ),
          decoration: BoxDecoration(
            color: Color(0xAAf0f0f0),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
