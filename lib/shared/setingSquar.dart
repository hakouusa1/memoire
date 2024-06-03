import 'package:flutter/material.dart';

class siting extends StatelessWidget {
  const siting({super.key, required this.name, this.bio, required this.path, this.color});
  final String path;
  final String name;
  final String? bio;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: Image.network(path).image,
        ),
        title: Text(
          "$name",
          style: TextStyle(fontSize: 24, color: color),
        ),
        subtitle: Text("$bio"),
      ),
    );
  }
}
