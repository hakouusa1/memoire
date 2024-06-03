import 'dart:ui';

import 'package:app5/pages/homePageMethod.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

// Dimensions in physical pixels (px)

class NotificationSquar extends StatelessWidget {
  final String name;
  const NotificationSquar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: Image.network("https://th.bing.com/th/id/OIP.jAEnONxlpsGr8oF6yPHI9QHaHZ?rs=1&pid=ImgDetMain")
              .image,
        ),
        title: Text("$name"),
        subtitle: Text("$name has sent you a message!"),
      ),
    );
  }
}
