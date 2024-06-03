import 'package:app5/pages/settingsPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesomeIcons

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AboutUs',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 30),
          icon: Icon(Icons.arrow_back_ios,
              color: const Color.fromARGB(255, 10, 10, 10)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SettingPage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 60,
                color: Colors.grey[200], // Change color according to your theme
                child: Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Add your Instagram handling logic here
                          },
                          icon:
                              FaIcon(FontAwesomeIcons.instagram), // Instagram icon
                          color:
                              Colors.pink, // Change color according to your theme
                          iconSize: 30,
                        ),
                        Text('Instagram'),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {
                            // Add your Instagram handling logic here
                          },
                          icon: FaIcon(FontAwesomeIcons.facebook), // Instagram icon
                          color:
                              Colors.blue, // Change color according to your theme
                          iconSize: 30,
                        ),
                        Text('Facebook'),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {
                            // Add your Instagram handling logic here
                          },
                      
                          icon: FaIcon(FontAwesomeIcons.tiktok), // Instagram icon
                          color: const Color.fromARGB(
                              255, 5, 5, 5), // Change color according to your theme
                          iconSize: 30,
                        ),
                        Text('TikTok'),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                'Our Company',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sed velit ut ipsum malesuada laoreet. Suspendisse potenti. Duis in lacus turpis. Integer dictum ligula nec fermentum luctus. Nunc sit amet magna nec neque vestibulum dapibus at vel magna. Nullam tristique quam non nunc varius fringilla. Nulla facilisi. Proin viverra mi id dui ultricies, ut eleifend ipsum tincidunt. Integer at dolor sit amet urna tempor tristique vel ac odio. Nulla facilisi. Vivamus ullamcorper, metus nec consequat congue, nunc nisl suscipit lectus, sit amet eleifend magna justo nec odio. Fusce scelerisque justo nec purus viverra, et rutrum nulla fermentum.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sed velit ut ipsum malesuada laoreet. Suspendisse potenti. Duis in lacus turpis. Integer dictum ligula nec fermentum luctus. Nunc sit amet magna nec neque vestibulum dapibus at vel magna. Nullam tristique quam non nunc varius fringilla. Nulla facilisi. Proin viverra mi id dui ultricies, ut eleifend ipsum tincidunt. Integer at dolor sit amet urna tempor tristique vel ac odio. Nulla facilisi. Vivamus ullamcorper, metus nec consequat congue, nunc nisl suscipit lectus, sit amet eleifend magna justo nec odio. Fusce scelerisque justo nec purus viverra, et rutrum nulla fermentum.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
