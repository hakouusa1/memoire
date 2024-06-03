import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';

List<Map<String, String>> categoriesData = [
  {
    'name': 'barber',
    'image': 'assets/images/barber.jpg',
    'descreption':
        'Here you will find Logo designers to help you increase your project.'
  },
  {
    'name': 'plombie',
    'image': 'assets/images/plombier.jpg',
    'descreption':
        'Here you will find Logo designers to help you increase your project.'
  },
  {
    'name': 'app design',
    'image': 'assets/images/appdevvv.jpg',
    'descreption':
        'Here you will find Logo designers to help you increase your project.'
  },
  {
    'name': 'logo design',
    'image': 'assets/images/logo1.jpeg',
    'descreption':
        'Here you will find Logo designers to help you increase your project.'
  },
  {
    'name': 'web dev',
    'image': 'assets/images/siteWeb.png',
    'descreption':
        'Here you will find Logo designers to help you increase your project.'
  },
  
  
  {
    'name': 'doctor',
    'image': 'assets/images/doctor.jpg',
    'descreption':
        'Here you will find Logo designers to help you increase your project.'
  },
  
];

List<String> categories = [
  "logo design",
  "Ai",
  "plombie",
  "barber",
  "doctor",
];
Future<void> _showNotification(String title, String body) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      importance: Importance.max, priority: Priority.high, ticker: 'ticker');
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x');
}

