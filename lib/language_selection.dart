import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'settings_provider.dart';
import 'package:provider/provider.dart';

class LanguageSelectionScreen extends StatefulWidget {

  const LanguageSelectionScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = 'English'; // Only English is selectable
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    // Set system UI colors based on theme
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: settingsProvider.darkMode ? const Color(0xff281537) : const Color(0xff6a1b9a),
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: settingsProvider.darkMode ? Color(0xff281537) : Color(0xff6a1b9a),
        title: Text(
          "Select Language",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(settingsProvider.darkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              settingsProvider.setDarkMode(!settingsProvider.darkMode);

            },
          ),
        ],
      ),
      body: Container(
        color: settingsProvider.darkMode ? Colors.black : Colors.grey[100],
        child: Column(
          children: [
            _buildSectionHeader("Available Languages"),
            _buildLanguageTile('English', true), // Only English is enabled
            _buildLanguageTile('Amharic', false),
            _buildLanguageTile('Spanish', false),
            _buildLanguageTile('Chinese', false),
            _buildLanguageTile('Arabic', false),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: settingsProvider.darkMode ? Color(0xff6a1b9a) : Color(0xff543378),
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
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: settingsProvider.darkMode ? Colors.white70 : Colors.black54,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLanguageTile(String title, bool enabled) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    final bool isSelected = _selectedLanguage == title;
    final Color textColor = settingsProvider.darkMode
        ? (enabled ? Colors.white : Colors.white60)
        : (enabled ? Colors.black : Colors.black54);

    final Color cardColor = settingsProvider.darkMode
        ? (enabled ? Color(0xff1a0d24) : Color(0xff0d0612))
        : (enabled ? Colors.grey[200]! : Colors.grey[100]!);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Radio<String>(
          value: title,
          groupValue: _selectedLanguage,
          onChanged: enabled ? (value) {
            setState(() {
              _selectedLanguage = value!;
            });
          } : null,
          activeColor: Color(0xff6a1b9a),
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (!enabled) {
              return settingsProvider.darkMode ? Colors.grey[700]! : Colors.grey[400]!;
            }
            return Color(0xff6a1b9a);
          }),
        ),
      ),
    );
  }
}