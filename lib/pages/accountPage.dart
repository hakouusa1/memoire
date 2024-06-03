import 'dart:io';
import 'dart:typed_data';
import 'package:app5/pages/BottomNavigationBarExampleApp.dart';
import 'package:app5/pages/workerPage.dart';
import 'package:app5/shared/postCategorei.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app5/pages/settingsPage.dart';
import 'package:app5/shared/posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final FirebaseAuth auth = FirebaseAuth.instance;

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<Uint8List> _imageFiles = [];
  List<QueryDocumentSnapshot> dataOfPosts = [];
  List<QueryDocumentSnapshot> dataOfWorks = [];
  List<QueryDocumentSnapshot> data = [];
  bool showPosts = true;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    getData();
    getDataPost();
    getDataWorks();
    getUserProfileImageUrl();
  }

  Future<void> getData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('id', isEqualTo: auth.currentUser!.uid)
          .get();
      data.addAll(querySnapshot.docs);
      setState(() {});
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> getDataPost() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('post')
          .where('id', isEqualTo: auth.currentUser!.uid)
          .get();
      dataOfPosts.addAll(querySnapshot.docs);
      setState(() {});
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  Future<void> getDataWorks() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('work')
          .where('id', isEqualTo: auth.currentUser!.uid)
          .get();
      dataOfWorks.addAll(querySnapshot.docs);
      setState(() {});
    } catch (e) {
      print('Error fetching works: $e');
    }
  }

  Future<String?> getFirstWorkImage(String workId) async {
    try {
      final DocumentSnapshot workSnapshot =
          await FirebaseFirestore.instance.collection('work').doc(workId).get();

      if (!workSnapshot.exists) {
        return null;
      }

      final dynamic data = workSnapshot.data();
      if (data != null && data['imageLinks'] is List<dynamic>) {
        final List<dynamic> imageLinks = data['imageLinks'];
        if (imageLinks.isNotEmpty) {
          return imageLinks[0].toString();
        }
      }
      return null;
    } catch (e) {
      print('Error getting work images: $e');
      return null;
    }
  }

  Future<void> getUserProfileImageUrl() async {
    final user = auth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();
      setState(() {
        profileImageUrl = doc['imageLink'];
      });
    }
  }

  Future<void> _onTapToAdd() async {
    final List<XFile>? pickedFiles = await ImagePicker().pickMultiImage(
      imageQuality: 100,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFiles != null) {
      setState(() {
        _imageFiles = pickedFiles
            .map((file) => File(file.path).readAsBytesSync())
            .toList();
      });

      // Upload image to Firebase Storage
      for (int i = 0; i < _imageFiles.length; i++) {
        final storageRef = firebase_storage.FirebaseStorage.instance.ref().child(
            'profile_images/${auth.currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageRef.putData(_imageFiles[i]);
        await uploadTask.whenComplete(() async {
          final downloadUrl = await storageRef.getDownloadURL();
          // Update profile image link in Firestore
          await FirebaseFirestore.instance
              .collection('user')
              .doc(auth.currentUser!.uid)
              .update({'imageLink': downloadUrl});
          setState(() {
            profileImageUrl = downloadUrl;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 127, 127, 211),
          title: Text(
            "Profile Page",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.symmetric(horizontal: 30),
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                );
              },
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 127, 127, 211),
        body: Column(
          children: [
            Container(
              color: Color.fromARGB(255, 127, 127, 211),
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _onTapToAdd,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundImage: profileImageUrl != null
                              ? NetworkImage(profileImageUrl!)
                              : null,
                          child: profileImageUrl == null
                              ? Icon(Icons.person,
                                  size: 60, color: Colors.white)
                              : null,
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '@${data.isNotEmpty ? data[0]['name'] : 'UserName'}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "${auth.currentUser?.email ?? 'User Email'}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showPosts = true;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: showPosts
                                    ? Colors.blue
                                    : Colors.transparent,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Posts',
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      showPosts ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showPosts = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: !showPosts
                                    ? Colors.blue
                                    : Colors.transparent,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Works',
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      !showPosts ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: showPosts
                          ? (dataOfPosts.isEmpty
                              ? Center(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      width: double.infinity,
                                      child: Image.asset(
                                        "assets/images/noPostYet.png",
                                        width: double.infinity,
                                        height: 250,
                                      ),
                                    ),
                                  ],
                                ))
                              : ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: dataOfPosts.length,
                                  itemBuilder: (context, index) {
                                    if (index < dataOfPosts.length) {
                                      return InkWell(
                                        onLongPress: () {
                                          AwesomeDialog(
                                            context: context,
                                            animType: AnimType.leftSlide,
                                            headerAnimationLoop: false,
                                            dialogType: DialogType.warning,
                                            showCloseIcon: true,
                                            title: 'Delete',
                                            desc:
                                                'Are you sure you want to delete this Post',
                                            btnOkOnPress: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('post')
                                                  .doc(dataOfPosts[index].id)
                                                  .delete();
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Bottom()),
                                              );
                                            },
                                            btnCancelOnPress: () {},
                                            btnOkIcon: Icons.check_circle,
                                            onDismissCallback: (type) {
                                              debugPrint(
                                                  'Dialog Dissmiss from callback $type');
                                            },
                                          ).show();
                                        },
                                        child: posts(
                                          idPost: dataOfPosts[index].id,
                                          numberOfPersons: dataOfPosts[index]
                                              ['number'],
                                          id: dataOfPosts[index]['id'],
                                          contextt: dataOfPosts[index]
                                              ['description'],
                                          name: dataOfPosts[index]['name'],
                                          bio:
                                              "Published by ${dataOfPosts[index]['name']}",
                                          color: Colors.black,
                                          path: dataOfPosts[index]['imageLink'],
                                          postDate: dataOfPosts[index]
                                                  ['timestamp']
                                              .toDate(),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ))
                          : (dataOfWorks.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        width: double.infinity,
                                        child: Image.asset(
                                          "assets/images/noPostYet.png",
                                          width: double.infinity,
                                          height: 250,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: dataOfWorks.length,
                                  itemBuilder: (context, index) {
                                    if (index < dataOfWorks.length) {
                                      return FutureBuilder<String?>(
                                        future: getFirstWorkImage(
                                            dataOfWorks[index].id),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text('Error loading image');
                                          } else if (snapshot.hasData) {
                                            final String? imagePath =
                                                snapshot.data;
                                            return InkWell(
                                                onLongPress: () {
                                                  AwesomeDialog(
                                                    context: context,
                                                    animType:
                                                        AnimType.leftSlide,
                                                    headerAnimationLoop: false,
                                                    dialogType:
                                                        DialogType.warning,
                                                    showCloseIcon: true,
                                                    title: 'Delete',
                                                    desc:
                                                        'Are you sure you want to delete this Work',
                                                    btnOkOnPress: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('work')
                                                          .doc(dataOfWorks[index]
                                                                  .id)
                                                          .delete();
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Bottom()),
                                                      );
                                                    },
                                                    btnCancelOnPress: () {},
                                                    btnOkIcon:
                                                        Icons.check_circle,
                                                    onDismissCallback: (type) {
                                                      debugPrint(
                                                          'Dialog Dissmiss from callback $type');
                                                    },
                                                  ).show();
                                                },
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WorkerPage(
                                                              idWork: dataOfWorks[index]['workId'],
                                                            )),
                                                  );
                                                },
                                                child: Post2(
                                                  price: dataOfWorks[index]
                                                      ['price'],
                                                  description:
                                                      dataOfWorks[index]
                                                          ['description'],
                                                  userName: dataOfWorks[index]
                                                      ['name'],
                                                  imagePath: imagePath!,
                                                ));
                                          } else {
                                            return Container();
                                          }
                                        },
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
