// Importing necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app5/pages/MinePage.dart';
import 'package:app5/pages/accountPage.dart';
import 'package:app5/pages/addPage.dart';
import 'package:app5/pages/homePageMethod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

// Global variables
int bottomSelectedIndex = 0;
final user = FirebaseAuth.instance.currentUser;
List<QueryDocumentSnapshot> data = [];

// Function to build bottom navigation bar items
List<BottomNavigationBarItem> buildBottomNavBarItems() {
  return [
    BottomNavigationBarItem(
      icon: Icon(Iconsax.home_copy),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(Iconsax.additem_copy),
      label: "Add",
    ),
    BottomNavigationBarItem(
      icon: Icon(Iconsax.heart_copy),
      label: "Mine",
    ),
    BottomNavigationBarItem(
      icon: CircleAvatar(
        radius: 15,
        backgroundImage: user != null && data.isNotEmpty
            ? NetworkImage(
                data[0]['imageLink']) // Display user profile image if available
            : null, // Or a placeholder image
      ),
      label: "Account",
    )
  ];
}

// Bottom navigation bar widget
class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  // Function to fetch user data from Firestore
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  // Page controller for handling page navigation
  PageController pageController = PageController(
    initialPage: bottomSelectedIndex,
    keepPage: true,
  );

  // Function to handle bottom navigation item tap
  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  // Function to handle page change event
  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  // Widget to build the page view for different tabs
  Widget buildPageView() {
    return PageView.builder(
      
      physics: NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      itemCount: 4, // Total number of pages
    itemBuilder: (context, index) {
      switch (index) {
        case 0:
          return homePage();
        case 1:
          return addPage();
        case 2:
          return NotificationPage();
        case 3:
          return AccountPage();
        default:
          return Container(); // Return an empty container if index is out of range
      }
    },
    );
  }

  @override
  void initState() {
    super.initState();
    getData(); // Fetch user data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 127, 127, 211),
      body: buildPageView(), // Display the page view
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          bottomTapped(index); // Handle bottom navigation item tap
        },
        selectedItemColor: Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: const Color.fromARGB(255, 45, 44, 44),
        currentIndex: bottomSelectedIndex,
        items: buildBottomNavBarItems(), // Build bottom navigation bar items
      ),
    );
  }
}
