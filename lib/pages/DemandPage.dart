import 'package:app5/pages/BottomNavigationBarExampleApp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DemandDetailsPage extends StatefulWidget {
  final String name;
  final String lastName;
  final String information;
  final String location;
  final String phone;
  final String id;
  final String idPost;
  final String idSender;
  final String varr;

  DemandDetailsPage({
    required this.name,
    required this.id,
    required this.lastName,
    required this.information,
    required this.location,
    required this.phone,
    required this.idPost,
    required this.idSender,
    required this.varr,
  });

  @override
  State<DemandDetailsPage> createState() => _DemandDetailsPageState();
}

class _DemandDetailsPageState extends State<DemandDetailsPage> {
  DocumentSnapshot? demandSnapshot;
  List<String> suggestions = [];
  String? selectedLocation;

  @override
  void initState() {
    super.initState();
    fetchDemand();
  }

  Future<void> fetchDemand() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.id)
          .collection(widget.varr)
          .doc(widget.idPost)
          .get();

      if (mounted) {
        setState(() {
          demandSnapshot = snapshot;
        });
      }

      if (!snapshot.exists) {
        print('Document with idPost ${widget.idPost} does not exist.');
      } else {
        print('Document data: ${snapshot.data()}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          demandSnapshot = null;
        });
      }
      print('Error fetching demand: $e');
    }
  }

  Future<void> fetchSuggestions(String query) async {
    final url =
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          suggestions = List<String>.from(
              json.decode(response.body).map((x) => x['display_name']));
        });
      }
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  Future<void> updateAcceptedValue() async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.id)
          .collection(widget.varr)
          .doc(widget.idPost)
          .update({'accepted': true});
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.varr} Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
                Icons.person, 'Name', '${widget.name} ${widget.lastName}'),
            SizedBox(height: 20),
            _buildDetailCard(Icons.info, 'Information', widget.information),
            SizedBox(height: 10),
            _buildDetailCard(Icons.location_on, 'Location', widget.location),
            SizedBox(height: 10),
            _buildDetailCard(Icons.phone, 'Phone', widget.phone),
            SizedBox(height: 40),
            _buildButtonRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String label, String value) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.blue),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    if (demandSnapshot == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (!demandSnapshot!.exists) {
      return Center(child: Text('Demand not found'));
    }

    bool isAccepted = demandSnapshot!.get('accepted') ?? false;

    if (!isAccepted) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              await _showAcceptDialog(context);
            },
            icon: Icon(Icons.check),
            label: Text('Accept'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          SizedBox(width: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Add logic to refuse the demand
            },
            icon: Icon(Icons.close),
            label: Text('Refuse'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 206, 108, 101),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      );
    } else {
      return ElevatedButton.icon(
        onPressed: () async {
          try {
            DocumentReference docRef = FirebaseFirestore.instance
                .collection('user')
                .doc(widget.idSender)
                .collection('acceptedDemandes')
                .doc(widget.idPost);

            await docRef.delete();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Demand removed successfully')),
            );
          } catch (e) {
            print('Error removing demand: $e');
          }
        },
        icon: Icon(Icons.remove_circle),
        label: Center(child: Text('Remove')),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      );
    }
  }

  Future<void> _showAcceptDialog(BuildContext context) async {
    String link = '';
    String message = '';
    String date = '';
    String phone = '';

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accept Demand'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    link = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Localisation',
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    message = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Message',
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    date = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Date (YYYY-MM-DD)',
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    phone = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Telephone',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _acceptDemand(context, link, message, date, phone);
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Bottom(),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _acceptDemand(BuildContext context, String link, String message,
      String date, String phone) async {
    try {
      CollectionReference acceptedDemands = FirebaseFirestore.instance
          .collection('user')
          .doc(widget.idSender)
          .collection('acceptedDemandes');

      DateTime parsedDate = DateTime.parse(date);

      DocumentReference documentReference = await acceptedDemands.add({
        'name': widget.name,
        'location': selectedLocation ?? link,
        'phone': phone,
        'message': message,
        'date': parsedDate,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (widget.varr == 'offers') {
        await FirebaseFirestore.instance
            .collection('post')
            .doc(widget.idPost)
            .update({'number': FieldValue.increment(-1)});
      }

      await documentReference.update({'accepted': true});

      await updateAcceptedValue();

      await sendPushMessage('You have an accepted demand',
          "You have everything", "knflkajflkajlkfjalfjla");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Demand accepted and uploaded successfully')),
      );
    } catch (e) {
      print('Error accepting demand: $e');
    }
  }

  Future<String?> getTokenUser(String idSender) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('id', isEqualTo: idSender)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first;
        return userDoc['fcmToken'];
      } else {
        print('No user found with id: $idSender');
        return null;
      }
    } catch (e) {
      print('Error getting user token: $e');
      return null;
    }
  }

  Future<void> sendPushMessage(String title, String body, String id) async {
    String? serverToken = await FirebaseMessaging.instance.getToken();

    if (serverToken == null) {
      print('Error: Unable to get FCM server token.');
      return;
    }

    String? userToken = await getTokenUser(widget.idSender);
    if (userToken == null) {
      print('Error: Unable to get user token.');
      return;
    }

    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': title,
            'title': body,
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': userToken,
        },
      ),
    );
  }
}
