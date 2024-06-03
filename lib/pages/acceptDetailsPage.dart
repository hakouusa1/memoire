import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptDetailsPage extends StatelessWidget {
  final String name;
  final String information;
  final String location;
  final Timestamp date;
  final String phone;
  const AcceptDetailsPage({
    required this.name,
    required this.date,
    required this.information,
    required this.location,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM dd, yyyy - hh:mm a').format(date.toDate());

    return Scaffold(
      appBar: AppBar(
        title: Text('Accept Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildDetailCard(context, Icons.person, 'Name', name),
            _buildDetailCard(context, Icons.calendar_today, 'Date', formattedDate),
            _buildDetailCard(context, Icons.info, 'Information', information),
            _buildDetailCard(context, Icons.phone, 'Phone', phone),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _launchUrl('https://www.google.com/maps/search/?api=1&query=$location');
              },
              icon: Icon(Icons.map),
              label: Text('Go to Google Maps'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, IconData icon, String label, String value) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
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

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
