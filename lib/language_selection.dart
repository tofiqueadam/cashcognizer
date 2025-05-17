import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'English';

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
          'Select Language',
          style: TextStyle(color: Colors.white), // Set the app bar text color to white
        ),
        iconTheme: IconThemeData(color: Colors.white), // Set the back icon color to white
      ),
      body: Container(
        color: Colors.black, // Set the body background color to black
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Please select your preferred language:',
                style: TextStyle(fontSize: 16, color: Color(0xffFFF5EE)),
              ),
              SizedBox(height: 10),
              _buildLanguageOption('Detected Language'),
              _buildLanguageOption('English'),
              _buildLanguageOption('Amharic'),
              _buildLanguageOption('Spanish'),
              _buildLanguageOption('Chinese'),
              _buildLanguageOption('Arabic'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff281537), // Set the BottomAppBar color to match the AppBar
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0), // Remove the default padding
        title: Text(
          language,
          style: TextStyle(color: Colors.white), // Set the text color to white
        ),
        leading: Radio<String>(
          value: language,
          groupValue: _selectedLanguage,
          onChanged: (String? value) {
            setState(() {
              _selectedLanguage = value!;
            });
          },
        ),
        onTap: () {
          setState(() {
            _selectedLanguage = language;
          });
        },
      ),
    );
  }
}
