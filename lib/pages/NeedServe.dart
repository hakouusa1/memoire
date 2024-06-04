import 'dart:typed_data';
import 'package:app5/Global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app5/pages/homePageMethod.dart';
import 'package:app5/shared/getUserData.dart';
import 'package:app5/shared/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../resources/add_data.dart';
import 'BottomNavigationBarExampleApp.dart';
import 'MinePage.dart';
import 'accountPage.dart';
import 'package:http/http.dart' as http;
import 'addPage.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class NeedServe extends StatefulWidget {
  const NeedServe({super.key});

  @override
  State<NeedServe> createState() => _NeedServeState();
}

class _NeedServeState extends State<NeedServe> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController numberOfPeopleController =
      TextEditingController();
  final TextEditingController categoryController =
      TextEditingController(); // New controller for category
  List<QueryDocumentSnapshot> data = [];
  String? _selectedCategory; // Make _selectedCategory a member variable

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
    getData();
    super.initState();
  }

  Future<Uint8List> downloadImageData(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load image: $e');
    }
  }

  Future<void> _onTapButton() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (data.isEmpty) {
      print('No user data found');
      Navigator.pop(context);
      return;
    }

    String description = descriptionController.text;
    int? numberOfPeople = int.tryParse(numberOfPeopleController.text);
    String? category = _selectedCategory; // Get category text

    if (numberOfPeople == null) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Input'),
            content:
                Text("Please enter a valid number for the number of people."),
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
      return;
    }

    Uint8List image = await downloadImageData(data[0]['imageLink']);

    try {
      String resp = await StoreData().savePostData(
        id: FirebaseAuth.instance.currentUser!.uid,
        name: data[0]['name'],
        description: description,
        file: image,
        numberP: numberOfPeople,
        category: category!, // Save category data
      );
      Navigator.pop(context);
    } on Exception catch (e) {
      Navigator.pop(context);
      print("Error saving post: $e");
    }

    Navigator.pop(context); // Dismiss the progress indicator
    bottomSelectedIndex = 0;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Bottom()),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Post Created'),
          content: Text("Your post has been created."),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Bottom()));
            },
          ),
          title: Text(
            "Create Post",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: _onTapButton,
                child: Text(
                  "Post",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFF5F5F5),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.isNotEmpty)
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(data[0]['imageLink']),
                    ),
                    SizedBox(width: 10),
                    Text(
                      data[0]['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: descriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'What\'s on your mind?',
                          hintStyle: TextStyle(fontSize: 18),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                        ),
                      ),
                      Divider(),
                      TextField(
                        controller: numberOfPeopleController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Number of people you need?',
                          hintStyle:
                              TextStyle(fontSize: 16, color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
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
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 95, 94, 94)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade900),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
