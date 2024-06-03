import 'dart:io';
import 'dart:typed_data';
import 'package:app5/pages/login.dart';
import 'package:app5/pages/verificationEmail.dart';
import 'package:app5/resources/add_data.dart';
import 'package:app5/shared/sharedVar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../shared/textfield.dart';
import '../shared/myButtonSing.dart';
import '../shared/square.dart';
import 'BottomNavigationBarExampleApp.dart';
import 'package:google_sign_in/google_sign_in.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _SignupState();
}

class _SignupState extends State<signup> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  List<Uint8List> _imageFiles = [];

  void _onTapButton() async {
    // Show a loading dialog
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Check if passwords match
      if (passwordController.text == rePasswordController.text) {
        // Check if a photo is selected
        if (_imageFiles.isEmpty) {
          Navigator.pop(context); // Dismiss loading dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Please pick an image to sign up.'),
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

        // Create user in Firebase Authentication
        UserCredential cred =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && user.emailVerified) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Bottom()));
        } else {
          user?.sendEmailVerification();

          String name = usernameController.text;
          String email = emailController.text;
          String password = passwordController.text;
          // Check if _imageFiles is not empty and its first element is not null
          Uint8List? imageBytes =
              _imageFiles.isNotEmpty ? _imageFiles[0] : null;
          if (imageBytes != null) {
            String resp = await StoreData().saveUserData(
              id: FirebaseAuth.instance.currentUser!.uid,
              cred: cred,
              name: name,
              email: email,
              password: password,
              file: imageBytes,
            );
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => EmailVerification()));
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Please pick an image to sign up.'),
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
        }
      } else {
        throw FirebaseAuthException(code: 'password-mismatch');
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth errors
      Navigator.pop(context); // Dismiss loading dialog
      String errorMessage = 'An error occurred';
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Email already in use. Please try again.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Server error';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid Email Address';
          break;
        case 'weak-password':
          errorMessage = 'Weak Password';
          break;
        case 'password-mismatch':
          errorMessage = 'Passwords do not match';
          break;
        default:
          errorMessage = 'An error occurred';
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
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

  Future<void> _onTapToAdd() async {
    final List<XFile>? pickedFiles = await ImagePicker().pickMultiImage(
      imageQuality: 100,
      maxHeight: 800,
      maxWidth: 800, // Adjust image quality as needed
    );

    if (pickedFiles != null) {
      setState(() {
        _imageFiles = pickedFiles
            .map((file) => File(file.path).readAsBytesSync())
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 237, 237),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                _imageFiles.isEmpty
                    ? GestureDetector(
                        onTap: _onTapToAdd,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundImage:
                              AssetImage("assets/images/SignUp.png"),
                        ),
                      )
                    : GestureDetector(
                        onTap: _onTapToAdd,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundImage: _imageFiles.isNotEmpty
                              ? MemoryImage(_imageFiles[0])
                              : null,
                        ),
                      ),
                SizedBox(
                  height: 50,
                ),
                MyTextField(
                  hiegh: 60,
                  widh: 25,
                  num: 10,
                  iconnn: Icon(Icons.person),
                  controler: usernameController,
                  textInputtt: TextInputType.text,
                  isPassword: false,
                  hinttexttt: "Username",
                ),
                SizedBox(height: 10),
                MyTextField(
                  hiegh: 60,
                  widh: 25,
                  num: 10,
                  iconnn: Icon(Icons.email),
                  controler: emailController,
                  textInputtt: TextInputType.emailAddress,
                  isPassword: false,
                  hinttexttt: "Email",
                ),
                SizedBox(height: 10),
                MyTextField(
                  hiegh: 60,
                  widh: 25,
                  num: 10,
                  iconnn: Icon(Icons.lock),
                  iconSuffix: Icon(Icons.remove_red_eye),
                  controler: passwordController,
                  textInputtt: TextInputType.visiblePassword,
                  isPassword: true,
                  hinttexttt: "Password",
                ),
                SizedBox(height: 10),
                MyTextField(
                  hiegh: 60,
                  widh: 25,
                  num: 10,
                  iconnn: Icon(Icons.lock),
                  iconSuffix: Icon(Icons.remove_red_eye),
                  controler: rePasswordController,
                  textInputtt: TextInputType.visiblePassword,
                  isPassword: true,
                  hinttexttt: "Re-enter Password",
                ),
                SizedBox(height: 25),
                MyBut(textt: 'Sign Up', onTap: _onTapButton),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text(
                        "Login now",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
