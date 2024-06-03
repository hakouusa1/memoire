import 'package:app5/pages/MinePage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification()async{
    await _firebaseMessaging.requestPermission();

    final fCMToker = await _firebaseMessaging.getToken();

    print('Token $fCMToker');

    initNotifications();
  }

  void handleMessage (RemoteMessage? message){
    if(message == null) return;
    Navigator.push(
      context as BuildContext,
      MaterialPageRoute(
          builder: (context) =>
              NotificationPage() //here pass the actual values of these variables, for example false if the payment isn't successfull..etc
      ),
    );
  }

  Future initNotifications()async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}