import 'package:app5/pages/DemandPage.dart';
import 'package:app5/pages/acceptDetailsPage.dart';
import 'package:app5/pages/offerDetailPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:app5/Global.dart';
import '../main.dart';

int previousDocCount = 0;

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final String user = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // Wrap with DefaultTabController
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Notifications'),
          centerTitle: true,
          bottom: TabBar(
            // TabBar at the bottom of AppBar
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Demands'),
              Tab(icon: Icon(Icons.check), text: 'Accepted Demands'),
              Tab(icon: Icon(Icons.local_offer), text: 'offers'),
            ],
          ),
        ),
        body: TabBarView(
          // Content based on selected tab
          children: [
            DemandPage(user: user),
            AcceptedDemandPage(user: user),
            OffersPage(user: user)
          ],
        ),
      ),
    );
  }

  void requesPermession() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        sound: true,
        provisional: false);
  }

  @override
  void initState() {
    super.initState();
    requesPermession();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
    });
  }
}

class DemandPage extends StatefulWidget {
  final String user;

  const DemandPage({required this.user});

  @override
  _DemandPageState createState() => _DemandPageState();
}

class _DemandPageState extends State<DemandPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(widget.user)
            .collection('demandes')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No demands available'));
          }

          var docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var demand = docs[index];
              var timestamp = demand['timestamp'] as Timestamp;
              var formattedTime =
                  DateFormat('yyyy-MM-dd – kk:mm').format(timestamp.toDate());

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DemandDetailsPage(
                        idPost: demand.id,
                        id: widget.user,
                        idSender: demand['senderId'], // Passing the user ID
                        name: demand['name'],
                        lastName: demand['lastName'],
                        information: demand['information'],
                        location: demand['location'],
                        phone: demand['phone'],
                        varr: 'demandes',
                      ),
                    ),
                  );
                  // Add your onTap logic here
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 3,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      '${demand['name']} ${demand['lastName']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(demand['information']),
                        SizedBox(height: 4),
                        Text(
                          formattedTime,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AcceptedDemandPage extends StatefulWidget {
  final String user;

  const AcceptedDemandPage({required this.user});

  @override
  _AcceptedDemandPageState createState() => _AcceptedDemandPageState();
}

class _AcceptedDemandPageState extends State<AcceptedDemandPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(widget.user)
            .collection('acceptedDemandes')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No accepted demands available'));
          }

          var docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var demand = docs[index];
              var timestamp = demand['timestamp'] as Timestamp;
              var formattedTime =
                  DateFormat('yyyy-MM-dd – kk:mm').format(timestamp.toDate());

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AcceptDetailsPage(
                        name: demand['name'],
                        information: demand['message'],
                        location: demand['location'],
                        phone: demand['phone'],
                        date: demand['date'],
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 3,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      '${demand['name']} Accepted A Demand',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(demand['message']),
                        SizedBox(height: 4),
                        Text(
                          formattedTime,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class OffersPage extends StatefulWidget {
  final String user;

  const OffersPage({required this.user});

  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(widget.user)
            .collection('offers')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No offers available'));
          }

          var docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var offer = docs[index];
              var timestamp = offer['timestamp'] as Timestamp;
              var formattedTime =
                  DateFormat('yyyy-MM-dd – kk:mm').format(timestamp.toDate());

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DemandDetailsPage(
                        varr: "offers",
                        idPost: offer.id,
                        id: widget.user,
                        name: offer['firstName'],
                        lastName: offer['lastName'],
                        information: offer['moreInfo'],
                        location: offer['location'],
                        phone: offer['phoneNumber'],
                        idSender: offer['idSender'],
                      ),
                    ),
                  );
                },
                // Add your onTap logic here

                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 3,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      'Offer ID: ${offer.id}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Name: ${offer['firstName']} ${offer['lastName']}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Location: ${offer['location']}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Date: $formattedTime',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
