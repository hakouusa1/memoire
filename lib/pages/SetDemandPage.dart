import 'package:app5/pages/BottomNavigationBarExampleApp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Setdemandpage extends StatefulWidget {
  final String postId;
  final String realIdPost;
  const Setdemandpage({
    Key? key,
    required this.postId,
    required this.realIdPost,
  }) : super(key: key);

  @override
  _SetdemandpageState createState() => _SetdemandpageState();
}

class _SetdemandpageState extends State<Setdemandpage> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _moreInfoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final customColor = Color.fromARGB(255, 127, 127, 211);

    return Scaffold(
      appBar: AppBar(
        title: Text('Set Demande', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
        backgroundColor: customColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please fill out the form below',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: customColor),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person, color: customColor),
                  ),
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person, color: customColor),
                  ),
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on, color: customColor),
                  ),
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone, color: customColor),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _moreInfoController,
                  decoration: InputDecoration(
                    labelText: 'More Information',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.info_outline, color: customColor),
                  ),
                  maxLines: null, // Allow multiline input
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Send offer data to Firebase Firestore
                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(widget.postId)
                        .collection('offers')
                        .add({
                      'accepted':false,
                      'idSender': FirebaseAuth.instance.currentUser!.uid,
                      'postId': widget.postId,
                      'realPostId': widget.realIdPost,
                      'firstName': _nameController.text,
                      'lastName': _lastNameController.text,
                      'location': _locationController.text,
                      'phoneNumber': _phoneController.text,
                      'moreInfo': _moreInfoController.text,
                      'timestamp': FieldValue
                          .serverTimestamp(), // Add more fields as needed
                    }).then((value) {
                      // Offer data sent successfully
                      // Show dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Success'),
                            content: Text('Offer sent successfully.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  Navigator.of(context)
                                      .pop(); // Close the form page
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }).catchError((error) {
                      // Error handling if offer data fails to send
                      print('Error sending offer: $error');
                      // You can display an error message or retry logic here
                    });
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customColor,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
