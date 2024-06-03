// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBarr extends StatelessWidget {
  final Widget leading;
  final ShapeBorder shape;
  final String hintText;

  const SearchBarr({
    required this.leading,
    required this.shape,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: hintText,
        prefixIcon: leading,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
        contentPadding: EdgeInsets.zero,
      ),
      child: TextField(
        decoration: InputDecoration(
          
              
              hintStyle: TextStyle(color: Colors.grey[600]),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 117, 117, 117)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                ),
              ),
              filled: true,
              fillColor: Color.fromARGB(255, 218, 217, 217),
      ),
    ));
  }
}