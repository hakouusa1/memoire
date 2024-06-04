import 'package:app5/pages/accountPage.dart';
import 'package:app5/pages/settingsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AccountCenterPage extends StatefulWidget {
  @override
  State<AccountCenterPage> createState() => _AccountCenterPageState();
}

class _AccountCenterPageState extends State<AccountCenterPage> {
  List<QueryDocumentSnapshot> data = [];
  final FirebaseAuth auth = FirebaseAuth.instance; // Ensure auth is initialized

  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('id', isEqualTo: auth.currentUser!.uid)
          .get();
      data.addAll(querySnapshot.docs);
      setState(() {});
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 30),
          icon: Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SettingPage()),
            );
          },
        ),
        title: Text('Account Center'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'Email:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                auth.currentUser!.email!,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Check if data is not empty before accessing its elements
            if (data.isNotEmpty)
              ListTile(
                title: Text(
                  'Name:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  data[0].get('name') ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              )
            else
              CircularProgressIndicator(), // Show loading indicator if data is still being fetched
          ],
        ),
      ),
    );
  }

  void _changeEmail(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Email'),
          content: Text(
              'You can add text fields and submit button here to change the email.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
