import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final String imageUrl;
  final double radius;
  CircleImage(this.imageUrl, this.radius);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage:
            NetworkImage(imageUrl ?? 'https://i.imgur.com/PI62N29.png'),
        radius: radius,
      ),
    );
  }
}
