import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class getUserData extends StatelessWidget {
  final String docId;
  getUserData(String uid, {required this.docId});

  CollectionReference users = FirebaseFirestore.instance.collection('UserData');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(docId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['name']}');
        }
        return Text('Loading..');
      }),
    );
  }
}