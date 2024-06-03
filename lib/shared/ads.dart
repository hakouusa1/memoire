// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';

class Ads extends StatelessWidget {
  final String shit;
  const Ads({super.key, required this.shit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
        color: Color.fromARGB(255, 210, 207, 207),
      ),
      child: Image.asset(
        shit,
        fit: BoxFit.cover,
      ),
      height: 100,
      width: 370,
    );
  }
}
