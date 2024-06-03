// ignore_for_file: prefer_const_constructors, unnecessary_import, implementation_imports
import 'package:app5/Global.dart';
import 'package:app5/pages/categorySingle.dart';
import 'package:app5/pages/homePageMethod.dart';
import 'package:app5/shared/categore.dart';

import 'BottomNavigationBarExampleApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CategoriPage extends StatefulWidget {
  const CategoriPage({super.key});

  @override
  State<CategoriPage> createState() => _CategoriPageState();
}

class _CategoriPageState extends State<CategoriPage> {
  void goToGategorieSinglePage(int i) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CategorySingle(i: i , a: 0,)));
  }

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
            "categories",
            style: TextStyle(
                color: Colors.black, fontSize: 33, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 238, 237, 237),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
                child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 1,
              crossAxisCount: 4,
              shrinkWrap: true,
              children: [
                for (int i = 0; i < categoriesData.length; i++)
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => goToGategorieSinglePage(i),
                        child: Container(
                          child: Categore(
                            scale: i % 2 == 0 ? 10 : 20,
                            name: categoriesData[i]['name']!,
                            hash: categoriesData[i]['image']!,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
              ],
            )),
          ),
        ));
  }
}
