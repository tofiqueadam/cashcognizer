import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    // Set the system navigation bar color to match the BottomAppBar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff281537), // Set your desired color here
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff281537), // Set the app bar color to match the theme
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white), // White text for consistency
        ),
      ),
      body: Container(
        color: Colors.black, // Set the body background color to black
        child: ListView(
          children: [
            SwitchListTile(
              title: Text(
                "Dark Mode",
                style: TextStyle(color: Colors.white), // White text for better readability
              ),
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
              activeColor: Color(0xff543378FF), // Active switch color
              inactiveThumbColor: Colors.grey, // Inactive switch thumb color
              inactiveTrackColor: Colors.grey[800], // Inactive switch track color
            ),
            ListTile(
              title: Text(
                "Other Settings",
                style: TextStyle(color: Colors.white), // White text for consistency
              ),
              subtitle: Text(
                "Placeholder text for other settings",
                style: TextStyle(color: Colors.white70), // Slightly lighter white for subtitle
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff281537), // Set the BottomAppBar color to match the AppBar
        child: SizedBox(height: 0), // Ensure there's no additional height added
      ),
    );
  }
}
