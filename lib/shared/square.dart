import 'package:flutter/material.dart';

class SquarTile extends StatelessWidget {
  final Function()? ontap;
  final String imagePath;
  const SquarTile({super.key, required this.imagePath, this.ontap});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border:  Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
          ),
        child: Image.asset(
          imagePath,
          height: 40,
        ),
      ),
    );
  }
}
