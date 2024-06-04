// ignore_for_file: unused_element, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app5/Global.dart';
import 'package:app5/pages/homePageMethod.dart';
import 'package:app5/resources/add_data.dart';
import 'package:app5/shared/getUserData.dart';
import 'package:app5/shared/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'BottomNavigationBarExampleApp.dart';
import 'MinePage.dart';
import 'accountPage.dart';
import 'addPage.dart';

class AddServe extends StatefulWidget {
  const AddServe({super.key});

  @override
  State<AddServe> createState() => _NeedServeState();
}

class _NeedServeState extends State<AddServe> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController TitleControler = TextEditingController();
  final TextEditingController CategoryController = TextEditingController();
  final TextEditingController DescriptionController = TextEditingController();
  final TextEditingController PhoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController PriceControler = TextEditingController();
  List<Uint8List> _imageFiles = [];
  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData(); // Fetch data in initState
  }

  Future<void> _onTapButton() async {
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    if (data.isEmpty) {
      print('No user data found');
      Navigator.pop(context); // Dismiss the progress indicator
      return;
    }
    String? category = _selectedCategory;
    String description = DescriptionController.text;
    String phone = PhoneController.text;
    String title = TitleControler.text;
    int price = PriceControler.text as int;
    String location = _locationController.text;
    // Check if _imageFiles is not empty and its first element is not null
    Uint8List? imageBytes = _imageFiles.isNotEmpty ? _imageFiles[0] : null;
    try {
      String resp = await StoreData().saveWorkData(
        location: location,
        title: title,
        id: FirebaseAuth.instance.currentUser!.uid,
        name: data[0]['name'], // Assuming data[0] has user's name
        category: category!,
        description: description,
        phone: phone,
        file: _imageFiles!,
        price: price,
      );

      // Handle successful data saving (e.g., show success message)
      Navigator.pop(context); // Dismiss the progress indicator
      bottomSelectedIndex = 0;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Bottom()));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Post Created'),
            content: Text("Your Post has been created."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle errors during data saving
      Navigator.pop(context); // Dismiss the progress indicator
      print('Error saving data: $e');
      // Show user-friendly error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                "An error occurred while saving the post data. Please try again later."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  final Widget _fab = Row(
    children: [
      FloatingActionButton(
        onPressed: () {},
        child: const Text("Cancel"),
      ),
      FloatingActionButton(
        onPressed: () {},
        child: const Text("Confirm"),
      ),
    ],
  );

  bool _valueee = false;
  void onChanged(bool? value) {
    if (value is bool) {
      setState(() {
        _valueee = value;
      });
    }
  }

  var _dropdawnvalue;

  void onchanged(String? value) {
    if (value is String) {
      setState(() {
        _dropdawnvalue = value;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    List<Uint8List> _imageFile = [];
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            padding: EdgeInsets.symmetric(horizontal: 30),
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Bottom()));
            }),
        actions: [
          TextButton(
              onPressed: _onTapButton,
              child: Text(
                "finish",
                style: TextStyle(
                    color: Color.fromARGB(255, 102, 161, 173), fontSize: 22),
              ))
        ],
        centerTitle: true,
        title: Text(
          "Add serve",
          style: TextStyle(
              color: Colors.black, fontSize: 33, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 238, 237, 237),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 150,
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _imageFile.length == _imageFiles.length
                        ? Center(
                            child: GestureDetector(
                              onTap: _pickImages,
                              child: Container(
                                height: 120,
                                width: width - 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 104, 105, 105)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Add Photos"),
                                          Icon(Icons.photo_album),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (Uint8List imageFile in _imageFiles)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 5),
                                      child: Image.memory(
                                        imageFile,
                                        width: 80,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  Center(
                                    child: Container(
                                      height: 130,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 104, 105, 105)),
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: _pickImages,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text("Add Photos"),
                                                    Icon(Icons.photo_album),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                          )
                  ],
                ),
              ),
            ),
            TextField(
              controller: _locationController,
              onTap: () {
                // Add onTap functionality here
              },
              decoration: InputDecoration(
                hintText: "Location",
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                ),
                prefixIcon: Icon(Icons.location_on, color: Colors.blue),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            TextField(
                controller: TitleControler,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 95, 94, 94)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade900,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                )),
            SizedBox(
              height: 20,
            ),
            TextField(
                controller: PriceControler,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Price ",
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 95, 94, 94)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade900,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                )),
            SizedBox(
              height: 20,
            ),
            TextField(
                controller: DescriptionController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 95, 94, 94)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade900,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                )),

            SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 95, 94, 94)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade900),
                    ),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  hint: Text('Select Category'),
                  isExpanded: true,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            TextField(
                controller: PhoneController,
                decoration: InputDecoration(
                  hintText: "Phone",
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 95, 94, 94)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade900,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                )),
            SizedBox(
              height: 20,
            ),

            SizedBox(
              height: 10,
            ),
            // Set the position of the floating action button
          ],
        ))),
      ),
    );
  }

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await ImagePicker().pickMultiImage(
      imageQuality: 100,
      maxHeight: 800, // Adjust maxHeight for higher resolution
      maxWidth: 800, // Adjust maxWidth for higher resolution
    );

    if (pickedFiles != null) {
      for (XFile file in pickedFiles) {
        final Uint8List imageBytes = await file.readAsBytes();
        setState(() {
          _imageFiles.add(imageBytes);
        });
      }
    }
  }
}
