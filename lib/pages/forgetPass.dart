import 'package:app5/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forget extends StatefulWidget {
   Forget({Key? key}) : super(key: key);

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  final emailControler = TextEditingController();

  @override
  void dispose(){
    emailControler.dispose();
    super.dispose();

  }

  Future ForgetButton() async{

    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailControler.text.trim());
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reset Password succes'),
            content: Text("Reset Password sent , Please Check your Email"),
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

    }on FirebaseAuthException catch(e){
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.message.toString()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            padding: EdgeInsets.symmetric(horizontal: 30),
            icon: Icon(Icons.arrow_back_ios , color: Colors.white,),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            }),
        title: Text('Forgot Password' , style: TextStyle(color: Colors.white),),
        backgroundColor: Color.fromARGB(255, 57, 111, 132), // Your app's theme color
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Forgot Your Password?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 57, 111, 132), // Your app's primary color
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Please enter your email address. You will receive a link to create a new password via email.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailControler,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(

              onPressed: ForgetButton,
              child: Text('Send Reset Email' , style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 57, 111, 132), // Your app's primary color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
