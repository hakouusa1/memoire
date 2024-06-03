// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';

class MyBut extends StatelessWidget {
  final  String textt;
  final Function()? onTap;
  const MyBut({super.key, required this.onTap , required this.textt}  );

  

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return GestureDetector(
      onTap: onTap ,
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(color: Colors.black,
        borderRadius: BorderRadius.circular(10)),
    
        // ignore: prefer_const_constructors
        child: Center(
          child: Text(textt,
          style : TextStyle(color: Colors.white, fontSize: 16 , fontWeight: FontWeight.bold),
          
      ))),
    );
  }
}
