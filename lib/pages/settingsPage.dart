import 'package:app5/pages/AboutUs.dart';
import 'package:app5/pages/BottomNavigationBarExampleApp.dart';
import 'package:app5/pages/FeedBack.dart';
import 'package:app5/pages/accountCenter.dart';
import 'package:app5/pages/login.dart';
import 'package:app5/shared/setingSquar.dart'; // Ensure these paths are correct
import 'package:app5/shared/textfield.dart'; // Ensure these paths are correct
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Text(
            "Settings & Privacy",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Bottom()),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("Your Account"),
                settingsItem(
                  context,
                  "Account Center",
                  "Personal data, account status",
                  "https://th.bing.com/th/id/R.fc1ab0014c7ea3b51072f344b832a651?rik=f5byOqnY%2bh24Ug&riu=http%3a%2f%2fcdn.onlinewebfonts.com%2fsvg%2fimg_222195.png&ehk=syitBHm6erLCEhea3DlKr4NG6jpA4D1XjUWGmei%2fmMo%3d&risl=&pid=ImgRaw&r=0",
                  AccountCenterPage(),
                ),
                divider(),
                sectionTitle("Secure Your Account"),
                settingsItem(
                  context,
                  "Reset Password",
                  "Personal details",
                  "https://th.bing.com/th/id/OIP.d1mA8cQaonu2li1wmMP9nAAAAA?rs=1&pid=ImgDetMain",
                  null, // Add your password reset page here
                ),
                divider(),
                sectionTitle("More Info and Support"),
                settingsItem(
                  context,
                  "Help",
                  "If you need help or have an issue, let us know",
                  "https://th.bing.com/th/id/OIP.jTpzg1umxsNX-CrX6vBc5wHaHa?rs=1&pid=ImgDetMain",
                  FeedbackPage(),
                ),
                settingsItem(
                  context,
                  "About Us",
                  "Information about us and the app",
                  "https://icon-library.com/images/help-icon-transparent-background/help-icon-transparent-background-28.jpg",
                  AboutUsPage(),
                ),
                divider(),
                sectionTitle("Login"),
                logoutButton(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget settingsItem(BuildContext context, String title, String subtitle,
      String imagePath, Widget? targetPage) {
    return GestureDetector(
      onTap: targetPage != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => targetPage),
              );
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(imagePath),
              radius: 25,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 20),
          ],
        ),
      ),
    );
  }

  Widget divider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: Colors.grey[300],
      margin: const EdgeInsets.symmetric(vertical: 10.0),
    );
  }

  Widget logoutButton() {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        try {
          
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        } catch (e) {
          print('Error signing out: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error signing out. Please try again.'),
            ),
          );
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
