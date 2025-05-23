import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool initialDarkMode;
  final ValueChanged<bool>? onDarkModeChanged;

  const LanguageSelectionScreen({
    Key? key,
    this.initialDarkMode = false,
    this.onDarkModeChanged,
  }) : super(key: key);

  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late String _selectedLanguage;
  late bool _darkMode;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = 'English';
    _darkMode = widget.initialDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI colors based on theme
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: _darkMode ? const Color(0xff281537) : const Color(0xff6a1b9a),
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _darkMode ? Color(0xff281537) : Color(0xff6a1b9a),
        title: Text(
          "Select Language",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_darkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() => _darkMode = !_darkMode);
              widget.onDarkModeChanged?.call(_darkMode);
            },
          ),
        ],
      ),
      body: Container(
        color: _darkMode ? Colors.black : Colors.grey[100],
        child: Column(
          children: [
            _buildSectionHeader("Available Languages"),
            _buildLanguageTile(
              'English',
              true,
            ),
            _buildLanguageTile(
              'Amharic',
              true,
            ),
            _buildLanguageTile(
              'Spanish',
              true,
            ),
            _buildLanguageTile(
              'Chinese',
              true,
            ),
            _buildLanguageTile(
              'Arabic',
              true,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _darkMode ? Color(0xff6a1b9a) : Color(0xff543378),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pop(context, _selectedLanguage);
                },
                icon: Icon(Icons.check, color: Colors.white),
                label: Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: _darkMode ? Colors.white70 : Colors.black54,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLanguageTile(String title, bool enabled) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: _darkMode ? Color(0xff1a0d24) : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: _darkMode ? Colors.white : Colors.black),
        ),
        trailing: Radio<String>(
          value: title,
          groupValue: _selectedLanguage,
          onChanged: enabled
              ? (value) {
            setState(() {
              _selectedLanguage = value!;
            });
          }
              : null,
          activeColor: Color(0xff6a1b9a),
        ),
      ),
    );
  }
}