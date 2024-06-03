// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:app5/pages/BottomNavigationBarExampleApp.dart';
import 'package:app5/pages/MinePage.dart';
import 'package:app5/pages/accountPage.dart';
import 'package:app5/pages/addPage.dart';
import 'package:app5/pages/homePageMethod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MyWidget extends StatefulWidget {
  const MyWidget({super.key, required controller, required Null Function(dynamic index) onPageChanged});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  PageController pageController = PageController(
  initialPage: 0,
  keepPage: true,
);
void pageChanged(int index) {
  setState(() {
    bottomSelectedIndex = index;
  });
}
@override
void initState() {
  super.initState();
}

@override


  
  Widget build(BuildContext context) {
    // TODO: implement build
    
  return PageView(
    controller: pageController,
    onPageChanged: (index) {
      pageChanged(index);
    },
    children: <Widget>[
      homePage(),
      addPage(),
      NotificationPage(),
      AccountPage()
    ],
  );
}

}









