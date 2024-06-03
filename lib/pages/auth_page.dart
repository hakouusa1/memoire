import 'package:app5/pages/BottomNavigationBarExampleApp.dart';
import 'package:app5/pages/homePageMethod.dart';
import 'package:app5/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class authPage extends StatelessWidget {
  const authPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          
          if (snapshot.hasData) {
            print("///////////////////////////////////${snapshot}");
            return Bottom();
            
          } else {
            print("/////////////////////////@########//${snapshot}");
            return Login();
            
          }
        },
      ),
    );
  }
}
