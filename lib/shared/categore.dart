import 'package:flutter/material.dart';

class Categore extends StatelessWidget {
  final double scale;
  final String name;
  final String hash;

  const Categore({
    Key? key,
    required this.name,
    required this.hash,
    required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 32.5, // Adjust the radius as needed to fit your design
          backgroundColor: Colors.white, // Set the background color of the circle
          child: ClipOval(
            child: Image.asset(
              hash,
              fit: BoxFit.cover,
              width: 65, // Adjust the width as needed
              height: 65, // Adjust the height as needed
            ),
          ),
        ),

        SizedBox(
          height: 5,
        ),
        Text(
          name,
          style: TextStyle(
            color: Color.fromARGB(255, 89, 88, 88),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
