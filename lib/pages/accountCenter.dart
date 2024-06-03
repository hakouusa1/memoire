import 'package:app5/pages/settingsPage.dart';
import 'package:flutter/material.dart';

class AccountCenterPage extends StatelessWidget {
  // Replace these variables with actual user data
  String userEmail = 'user@example.com';
  final String userName = 'John Doe';
  final String userBio =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce gravida turpis non elit volutpat, sit amet eleifend metus tristique.';
  final String userPhoneNumber = '+1234567890';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 30),
          icon: Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SettingPage()),
            );
          },
        ),
        title: Text('Account Center'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'Email:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                userEmail,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Handle the edit email action
                  _changeEmail(context);
                },
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                'Name:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                userName,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Handle the edit name action
                },
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                'Bio:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                userBio,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Handle the edit bio action
                },
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                'Phone Number:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                userPhoneNumber,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Handle the edit phone number action
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle changing email
  void _changeEmail(BuildContext context) {
    // Implement email change logic here
    showDialog(
      context: context,
      builder: (context) {
        // Add your dialog UI for changing email
        return AlertDialog(
          title: Text('Change Email'),
          content: Text(
              'You can add text fields and submit button here to change the email.'),
          actions: [
            TextButton(
              onPressed: () {
                // Implement the logic to update the email
                // For example:
                // userEmail = newText;
                // Then, close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog without updating the email
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
