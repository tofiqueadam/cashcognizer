import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set the system navigation bar color to match the BottomAppBar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff281537), // Set the desired color
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff281537), // Set the app bar color to match the theme
        title: Text(
          "About Us",
          style: TextStyle(color: Colors.white), // White text for consistency
        ),
        iconTheme: IconThemeData(color: Colors.white), // Set the back icon color to white
      ),
      body: Container(
        color: Colors.black, // Set the body background color to black
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "We are the developers behind this amazing app. Our mission is to create high-quality, user-friendly applications that make your life easier.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white), // White text for readability
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff281537), // Set the BottomAppBar color to match the AppBar
        child: SizedBox(height: 0), // Ensure there's no additional height added
      ),
    );
  }
}
