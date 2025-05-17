import 'package:flutter/material.dart';

class CurrencySelectionScreen extends StatefulWidget {
  @override
  _CurrencySelectionScreenState createState() => _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends State<CurrencySelectionScreen> {
  String selectedCurrency = "ETB";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff281537), // Set the same color as BottomAppBar
        title: Text(
          "Select Currency",
          style: TextStyle(color: Colors.white), // Set the app bar text color to white
        ),
        iconTheme: IconThemeData(color: Colors.white), // Set the back icon color to white
      ),
      body: Container(
        color: Colors.black, // Set the body background color to black
        child: Column(
          children: [
            const SizedBox(height: 30),
            ListTile(
              leading: Image.asset('assets/ethiopian_flag.png', width: 40), // Ethiopian Birr Flag
              title: Text(
                'Ethiopian Birr (ETB)',
                style: TextStyle(color: Colors.white), // Set the text color to white
              ),
              trailing: Radio<String>(
                value: "ETB",
                groupValue: selectedCurrency,
                onChanged: (value) {
                  setState(() {
                    selectedCurrency = value!;
                  });
                },
              ),
            ),
            ListTile(
              leading: Image.asset('assets/usa_flag.jpg', width: 40), // US Dollar Flag
              title: Text(
                'US Dollar (USD)',
                style: TextStyle(color: Colors.white), // Set the text color to white
              ),
              trailing: Radio<String>(
                value: "USD",
                groupValue: selectedCurrency,
                onChanged: null, // Disabled
              ),
            ),
            ListTile(
              leading: Image.asset('assets/uk_flag.jpg', width: 40), // British Pound Flag
              title: Text(
                'British Pound (GBP)',
                style: TextStyle(color: Colors.white), // Set the text color to white
              ),
              trailing: Radio<String>(
                value: "GBP",
                groupValue: selectedCurrency,
                onChanged: null, // Disabled
              ),
            ),
            ListTile(
              leading: Image.asset('assets/eu_flag.jpg', width: 40), // Euro Flag
              title: Text(
                'Euro (EUR)',
                style: TextStyle(color: Colors.white), // Set the text color to white
              ),
              trailing: Radio<String>(
                value: "EUR",
                groupValue: selectedCurrency,
                onChanged: null, // Disabled
              ),
            ),
            const SizedBox(height: 310),

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
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff281537), // Set the BottomAppBar color to match the AppBar
        child: SizedBox(height: 0), // Ensure there's no additional height added
      ),
    );
  }
}
