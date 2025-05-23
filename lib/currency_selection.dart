import 'package:flutter/material.dart';

import 'settings_provider.dart';
import 'package:provider/provider.dart';

class CurrencySelectionScreen extends StatefulWidget {

  const CurrencySelectionScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CurrencySelectionScreenState createState() => _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends State<CurrencySelectionScreen> {
  late String _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = "ETB"; // Only ETB is selectable
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: settingsProvider.darkMode ? Color(0xff281537) : Color(0xff6a1b9a),
        title: Text(
          "Select Currency",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(settingsProvider.darkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              settingsProvider.setDarkMode(!settingsProvider.darkMode);
              //widget.onDarkModeChanged?.call(settingsProvider.darkMode);
            },
          ),
        ],
      ),
      body: Container(
        color: settingsProvider.darkMode ? Colors.black : Colors.grey[100],
        child: Column(
          children: [
            _buildSectionHeader("Available Currencies"),
            _buildCurrencyTile(
              'assets/ethiopian_flag.png',
              'Ethiopian Birr (ETB)',
              "ETB",
              true, // Only ETB is enabled
            ),
            _buildCurrencyTile(
              'assets/usa_flag.jpg',
              'US Dollar (USD)',
              "USD",
              false, // Disabled
            ),
            _buildCurrencyTile(
              'assets/uk_flag.jpg',
              'British Pound (GBP)',
              "GBP",
              false, // Disabled
            ),
            _buildCurrencyTile(
              'assets/eu_flag.jpg',
              'Euro (EUR)',
              "EUR",
              false, // Disabled
            ),
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
                  Navigator.pop(context, _selectedCurrency);
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

  Widget _buildCurrencyTile(String imagePath, String title, String currencyCode, bool enabled) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    final bool isSelected = _selectedCurrency == currencyCode;
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
        leading: Opacity(
          opacity: enabled ? 1.0 : 0.6,
          child: Image.asset(imagePath, width: 40),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Radio<String>(
          value: currencyCode,
          groupValue: _selectedCurrency,
          onChanged: enabled ? (value) {
            setState(() {
              _selectedCurrency = value!;
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