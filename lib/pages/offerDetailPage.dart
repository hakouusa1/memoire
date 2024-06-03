import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Offerdetailpage extends StatefulWidget {
  final String name;
  final String lastName;
  final String information;
  final String location;
  final String phone;
  final String id;
  final String idPost;

  Offerdetailpage({
    required this.name,
    required this.id,
    required this.lastName,
    required this.information,
    required this.location,
    required this.phone,
    required this.idPost,
  });

  @override
  State<Offerdetailpage> createState() => _OfferdetailpageState();
}

class _OfferdetailpageState extends State<Offerdetailpage> {
  List<QueryDocumentSnapshot> data = [];
  bool isAccepted = false;
  bool isRefused = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        data.addAll(querySnapshot.docs);
      }
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offers Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${widget.name} ${widget.lastName}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildDetailRow(Icons.info, 'Information', widget.information),
            SizedBox(height: 10),
            _buildDetailRow(Icons.location_on, 'Location', widget.location),
            SizedBox(height: 10),
            _buildDetailRow(Icons.phone, 'Phone', widget.phone),
            SizedBox(height: 40),
            _buildButtonRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(fontSize: 18),
                maxLines: null, // Allow multiline text
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isAccepted && !isRefused)
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
        if (!isAccepted && !isRefused)
          SizedBox(width: 20),
        if (!isAccepted && !isRefused)
          ElevatedButton.icon(
            onPressed: () async {
              await _refuseDemand();
            },
            icon: Icon(Icons.cancel),
            label: Text('Refuse'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        if (isAccepted)
          ElevatedButton.icon(
            onPressed: () async {
              await _removeAcceptedDemand();
            },
            icon: Icon(Icons.remove_circle),
            label: Text('Remove'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
      ],
    );
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
                    labelText: 'Link',
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
                    labelText: 'Phone',
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
                await _acceptDemand(link, message, date, phone);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _acceptDemand(String link, String message, String date, String phone) async {
    try {
      if (data.isEmpty) {
        throw Exception("User data not available.");
      }

      CollectionReference acceptedDemands = FirebaseFirestore.instance
          .collection('user')
          .doc(widget.id)
          .collection('acceptedDemandes');

      DateTime parsedDate = DateTime.parse(date);

      await acceptedDemands.add({
        'name': data[0]['name'],
        'location': link,
        'phone': phone,
        'message': message,
        'date': parsedDate,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.idPost)
          .update({
        'number': FieldValue.increment(-1),
      });

      if (mounted) {
        setState(() {
          isAccepted = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Demand accepted and uploaded successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to accept the demand: $e')),
        );
      }
    }
  }

  Future<void> _refuseDemand() async {
    if (mounted) {
      setState(() {
        isRefused = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Demand refused')),
      );
    }
  }

  Future<void> _removeAcceptedDemand() async {
    try {
      CollectionReference acceptedDemands = FirebaseFirestore.instance
          .collection('user')
          .doc(widget.id)
          .collection('acceptedDemandes');

      QuerySnapshot querySnapshot = await acceptedDemands
          .where('name', isEqualTo: data[0]['name'])
          .where('location', isEqualTo: widget.location)
          .where('phone', isEqualTo: widget.phone)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.idPost)
          .update({
        'number': FieldValue.increment(1),
      });

      if (mounted) {
        setState(() {
          isAccepted = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Accepted demand removed successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove the accepted demand: $e')),
        );
      }
    }
  }
}
