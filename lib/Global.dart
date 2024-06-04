import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';

List<Map<String, String>> categoriesData = [
  {
    'name': 'barber',
    'image': 'assets/images/barber.jpg',
    'descreption':
        'Here you will find things about barber.'
  },
  {
    'name': 'plombie',
    'image': 'assets/images/plombier.jpg',
    'descreption':
        'Here you will find things about plombier.'
  },
  {
    'name': 'app design',
    'image': 'assets/images/appdevvv.jpg',
    'descreption':
        'Here you will find things about app designe.'
  },
  {
    'name': 'Ai',
    'image': 'assets/images/ia2.jpeg',
    'descreption':
        'Here you will find things about Intelegence artificiale .'
  },
  {
    'name': 'logo design',
    'image': 'assets/images/logo1.jpeg',
    'descreption':
        'Here you will find things about logo designe.'
  },
  {
    'name': 'web dev',
    'image': 'assets/images/siteWeb.png',
    'descreption':
        'Here you will find things about web developement.'
  },
  {
    'name': 'doctor',
    'image': 'assets/images/doctor.jpg',
    'descreption':
        'Here you will find things about doctors .'
  },
  {
    'name': 'driver',
    'image': 'assets/images/taxi.jpg',
    'descreption':
        'Here you will find things about drivers.'
  },
  {
    'name': 'chef',
    'image': 'assets/images/tabakh.jpg',
    'descreption':
        'Here you will find things about chefs .'
  },
  {
    'name': 'security',
    'image': 'assets/images/sec.jpg',
    'descreption':
        'Here you will find things about security.'
  },
  {
    'name': 'lawyer',
    'image': 'assets/images/lawyer.jpg',
    'descreption':
        'Here you will find things about lawyers.'
  },
  {
    'name': 'travel',
    'image': 'assets/images/travel.jpg',
    'descreption':
        'Here you will find things about Travel .'
  },
];

List<String> categories = [
  "logo design",
  "Ai",
  "plombie",
  "barber",
  'app design',
  "doctor",
      "driver",
      "chef",
      "security",
      "lawyer",
      "travel",
];
Future<void> _showNotification(String title, String body) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      importance: Importance.max, priority: Priority.high, ticker: 'ticker');
  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x');
}
