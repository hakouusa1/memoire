import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'NeedServe.dart';

class DemandForm extends StatefulWidget {
  final String workid;
  
  var postId;
   DemandForm({Key? key,required this.postId, required this.workid}) : super(key: key);

  @override
  _DemandFormState createState() => _DemandFormState();
}

class _DemandFormState extends State<DemandForm> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _moreInfoController = TextEditingController();

  List<QueryDocumentSnapshot> data = [];

  @override
  void initState() {
    super.initState();
    getData();

  }

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: auth.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  Future<void> PostTheDemand({
    required String name,
    required String lastName,
    required String information,
    required String phone,
    required String location,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('user') // Ensure you have the correct collection name
          .doc(widget.workid)
          .collection('demandes')
          .add({
        'accepted':false,
        'idPost':widget.postId,
        'name': name,
        'lastName': lastName,
        'information': information,
        'phone': phone,
        'id':widget.workid,
        'senderId':data[0]['id'],
        'location': location,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _showDialog('Success', 'Demand posted successfully');
    } catch (e) {
      _showDialog('Error', 'Failed to post demand: $e');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if (title == 'Success') {
                  Navigator.pop(context); // Close the form page on success
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final customColor = Color.fromARGB(255, 127, 127, 211);

    return Scaffold(
      appBar: AppBar(
        title: Text('Make Demande', style: TextStyle(color: Colors.white)),
        leading: IconButton(onPressed: (){ Navigator.pop(context);},icon: Icon(Icons.arrow_back_ios), color: Colors.white,),
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: customColor),
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
                    if (_formKey.currentState!.validate()) {
                      PostTheDemand(
                        name: _nameController.text,
                        lastName: _lastNameController.text,
                        information: _moreInfoController.text,
                        phone: _phoneController.text,
                        location: _locationController.text,
                      );
                    }
                  },
                  child: Text('Submit' , style: TextStyle(color: Colors.white),),
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
