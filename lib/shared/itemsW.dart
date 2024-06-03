// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class ItemsW extends StatelessWidget {
  const ItemsW({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 0.68,
      crossAxisCount: 2,
      shrinkWrap: true,
      children: [
        for (int i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
                color: Color.fromARGB(255, 210, 207, 207),
              ),
              child: Column(),
            ),
          )
      ],
    );
  }
}
