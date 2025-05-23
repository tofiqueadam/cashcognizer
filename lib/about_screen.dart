import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatelessWidget {
  final bool darkMode;

  const AboutScreen({Key? key, this.darkMode = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set system UI colors based on theme
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: darkMode ? Color(0xff281537) : Color(0xff6a1b9a),
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    final backgroundColor = darkMode ? Colors.black : Colors.grey[100];
    final primaryColor = darkMode ? Color(0xff281537) : Color(0xff6a1b9a);
    final textColor = darkMode ? Colors.white : Colors.black87;
    final buttonColor = darkMode ? Color(0xff543378) : Color(0xff6a1b9a);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Help',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Icon(
                        Icons.help_outline,
                        size: 60,
                        color: primaryColor,
                      ),
                      SizedBox(height: 30),
                      Text(
                        'How to Use CashCognize',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      _buildFeatureItem(
                        icon: Icons.camera_alt,
                        title: 'Currency Detection',
                        description: 'Point your camera at any Ethiopian currency and CashCognize will identify it.',
                        color: primaryColor,
                        textColor: textColor,
                      ),
                      SizedBox(height: 20),
                      _buildFeatureItem(
                        icon: Icons.text_fields,
                        title: 'Text Recognition',
                        description: 'Switch to text mode to read and hear text from documents or other sources.',
                        color: primaryColor,
                        textColor: textColor,
                      ),
                      SizedBox(height: 20),
                      _buildFeatureItem(
                        icon: Icons.touch_app,
                        title: 'Troubleshooting',
                        description: 'Having trouble? Try adjusting distance, lighting, or orientation of the object.',
                        color: primaryColor,
                        textColor: textColor,
                      ),
                      SizedBox(height: 30),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: darkMode ? Colors.grey[900] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'For best results, ensure good lighting and hold the camera steady.',
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    elevation: 3,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.check),
                  label: Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Color textColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}