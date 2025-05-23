import 'package:flutter/material.dart';

class CurrencySelectionScreen extends StatefulWidget {
  final bool initialDarkMode;
  final ValueChanged<bool>? onDarkModeChanged;

  const CurrencySelectionScreen({
    Key? key,
    this.initialDarkMode = false,
    this.onDarkModeChanged,
  }) : super(key: key);

  @override
  _CurrencySelectionScreenState createState() => _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends State<CurrencySelectionScreen> {
  late String _selectedCurrency;
  late bool _darkMode;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = "ETB";
    _darkMode = widget.initialDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _darkMode ? Color(0xff281537) : Color(0xff6a1b9a),
        title: Text(
          "Select Currency",
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
            _buildSectionHeader("Available Currencies"),
            _buildCurrencyTile(
              'assets/ethiopian_flag.png',
              'Ethiopian Birr (ETB)',
              "ETB",
              true,
            ),
            _buildCurrencyTile(
              'assets/usa_flag.jpg',
              'US Dollar (USD)',
              "USD",
              false,
            ),
            _buildCurrencyTile(
              'assets/uk_flag.jpg',
              'British Pound (GBP)',
              "GBP",
              false,
            ),
            _buildCurrencyTile(
              'assets/eu_flag.jpg',
              'Euro (EUR)',
              "EUR",
              false,
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

  Widget _buildCurrencyTile(String imagePath, String title, String currencyCode, bool enabled) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: _darkMode ? Color(0xff1a0d24) : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Image.asset(imagePath, width: 40),
        title: Text(
          title,
          style: TextStyle(color: _darkMode ? Colors.white : Colors.black),
        ),
        trailing: Radio<String>(
          value: currencyCode,
          groupValue: _selectedCurrency,
          onChanged: enabled
              ? (value) {
            setState(() {
              _selectedCurrency = value!;
            });
          }
              : null,
          activeColor: Color(0xff6a1b9a),
        ),
      ),
    );
  }
}