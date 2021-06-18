import 'package:flutter/material.dart';
import 'package:milyar/Utils/color.dart';

Widget buttons(BuildContext context, String text, EdgeInsets padding) {
  return Padding(
    padding: padding,
    child: Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blue,
          border: Border.all(color: Colors.blue)),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
