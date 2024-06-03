import 'package:flutter/material.dart';
import 'package:app5/pages/login.dart';

class EmailVerification extends StatelessWidget {
  const EmailVerification({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 237, 237),
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 30),
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color.fromARGB(255, 255, 254, 254),
                  ),
                  child: Image.asset(
                    "assets/images/logo4.png",
                    height: 100,
                  ),
                ),

                SizedBox(height: 50),

                // Verification message
                Text(
                  "Go and verify your email.",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 57, 111, 132), // Your app's primary color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
