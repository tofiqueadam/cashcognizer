import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set the system navigation bar color to match the BottomAppBar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff281537), // Set your desired color here
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff281537), // Set the same color as BottomAppBar
        title: Text(
          'Help',
          style: TextStyle(color: Colors.white), // Set the app bar text color to white
        ),
        iconTheme: IconThemeData(color: Colors.white), // Set the back icon color to white
      ),
      body: Container(
        color: Colors.black, // the body background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    '\nPoint your camera at any Ethiopian currency and CashCognize will identify it.'
                        '\n\n\nHaving trouble? Rotate your device vertically or Horizontally, or move closer or further from the Birr Note.   ',
                    style: TextStyle(fontSize: 18, color: Colors.white), // Set the text color to white
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff543378FF), // Same color as the app bar
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                onPressed: () {
                  Navigator.pop(context); // Go back to the home screen
                },
                icon: Icon(Icons.check, color: Colors.white,), // Add the right icon
                label: Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
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
