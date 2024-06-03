// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'package:app5/pages/NeedServe.dart';
import 'package:app5/pages/addServe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'MinePage.dart';
import 'accountPage.dart';
import 'BottomNavigationBarExampleApp.dart';

class addPage extends StatefulWidget {
  const addPage({super.key});

  @override
  State<addPage> createState() => _addPageState();
}

class _addPageState extends State<addPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 1000,
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(),
                      child: Text(
                        "Ajouter un service ? ",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 127, 127, 211),
                            fontSize: 29,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(),
                      child: Text(
                        "Le premier choix est d'ajouter un service dans lequel vous êtes maître 😌, et le deuxième choix est un pub dans lequel les gens peuvent vous servir ! ",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 0.9,
                crossAxisCount: 2,
                shrinkWrap: true,
                children: [
                  // add a serve
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => AddServe()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 141, 140, 140)),
                          borderRadius: BorderRadius.circular(16),
                          color: Color.fromARGB(255, 238, 236, 236),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Container(
                                  child: Text(
                                    "Add Serve ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 127, 127, 211),
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Need a Serve
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => NeedServe()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 141, 140, 140)),
                          borderRadius: BorderRadius.circular(16),
                          color: Color.fromARGB(255, 238, 236, 236),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  " Need Serve ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 127, 127, 211),
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
