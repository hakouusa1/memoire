import 'package:app5/pages/BottomNavigationBarExampleApp.dart';
import 'package:flutter/material.dart';

class allWrokers extends StatelessWidget {
  const allWrokers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            padding: EdgeInsets.symmetric(horizontal: 30),
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Bottom()));
            }),
        centerTitle: true,
        title: Text(
          "All workers ",
          style: TextStyle(
              color: Colors.black, fontSize: 33, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
