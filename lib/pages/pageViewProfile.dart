import 'package:app5/pages/BottomNavigationBarExampleApp.dart';
import 'package:app5/pages/MinePage.dart';
import 'package:app5/pages/accountPage.dart';
import 'package:app5/pages/addPage.dart';
import 'package:app5/pages/homePageMethod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class accountPags extends StatefulWidget {
  const accountPags({super.key, required PageController controller, required Null Function(dynamic index) onPageChanged});

  @override
  State<accountPags> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<accountPags> {
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
        Container(
          color: const Color.fromARGB(255, 185, 160, 160),
          child: Text("hello"),
        ),
        Container(
          color: Colors.black,
          child: Text("hello"),
        ),
      ],
    );
  }
}
