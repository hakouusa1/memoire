import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StoreData {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadImage(String imageName, Uint8List file) async {
    try {
      // Generate a unique identifier for the image using current timestamp
      String uniqueIdentifier = DateTime.now().millisecondsSinceEpoch.toString();
      String uniqueImageName = '$imageName$uniqueIdentifier';
      final Reference ref = _storage.ref().child(uniqueImageName);
      // Define metadata options to maintain original image quality
      final metadata = SettableMetadata(
        contentType: 'image/jpeg', // Set the content type of the image
        customMetadata: {'quality': '100'}, // Maintain 100% quality
      );

      final UploadTask uploadTask = ref.putData(file, metadata);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception("Error uploading image");
    }
  }

  Future<String> saveUserData({
    required String id,
    required String name,
    required UserCredential cred,
    required String email,
    required String password,
    required Uint8List file,
  }) async {
    String resp = "Some error occurred";
    try {
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        String imageUrl = await uploadImage('$name$id', file);
        await _firestore.collection('user').doc(cred.user!.uid).set({
          'id': id,
          'name': name,
          'email': email,
          'password': password,
          'imageLink': imageUrl
        });
        resp = "success";
      } else {
        print("Missing required fields.");
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }

  Future<String> saveWorkData({
    required String title,
    required String name,
    required String price,
    required String id,
    required String description,
    required String phone,
    required String category,
    required List<Uint8List> file, required String location,
  }) async {
    String resp = "Some error occurred";
    try {
      String workId = Uuid().v4();
      if (title.isNotEmpty &&
          name.isNotEmpty &&
          price.isNotEmpty &&
          description.isNotEmpty &&
          phone.isNotEmpty &&
          category.isNotEmpty &&
          file.isNotEmpty) {
        List<String> imageUrls = []; // Initialize imageUrl list

        for (int i = 0; i < file.length; i++) {
          String url = await uploadImage('$name$id', file[i]);
          imageUrls.add(url); // Add the URL to the imageUrls list
        }

        await _firestore.collection('work').add({
          'workId':workId,
          'location':location,
          'title': title,
          'name': name,
          'price': price,
          'id': id,
          'description': description,
          'phone': phone,
          'category': category,
          'imageLinks': imageUrls
        });
        resp = "success";
      } else {
        print("Missing required fields.");
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }

  Future<String> savePostData({
    required String id,
    required String name,
    required String description,
    required Uint8List file,
    required int numberP, required String category ,
  }) async {
    String resp = "Some error occurred";
    try {
      if (name.isNotEmpty && description.isNotEmpty && numberP != -1) {
        String imageUrl = await uploadImage('$name$id', file);
        await _firestore.collection('post').add({
          'category':category,
          'id': id,
          'name': name,
          'description': description,
          'number': numberP,
          'imageLink': imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
        resp = "Post saved successfully";
      } else {
        print("Missing required fields.");
      }
    } catch (e) {
      resp = 'Failed to save post: $e';
    }
    return resp;
  }

  Future<String> saveCommentData({
    required String name,
    required String id,
    required String commentDate,
    required String description,
    required Uint8List file,
  }) async {
    String resp = "Some error occurred";
    try {
      if (name.isNotEmpty && description.isNotEmpty && file.isNotEmpty) {
        String imageUrl = await uploadImage('$name$id', file);
        DocumentReference docRef =
        _firestore.collection("post1").doc(id).collection("comments").doc();
        await docRef.set({
          'commentDate': commentDate,
          'commenterName': name,
          'commentMessage': description,
          'commenterPic': imageUrl
        });
        resp = "success";
      } else {
        print("Missing required fields.");
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }
}
