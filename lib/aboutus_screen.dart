import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screen_reader_helper.dart';

class AboutUsScreen extends StatefulWidget {
  final bool darkMode;

  const AboutUsScreen({Key? key, this.darkMode = false}) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _readContent();
    });
  }

  @override
  void dispose() {
    ScreenReaderHelper.stop();
    super.dispose();
  }

  void _readContent() {
    final content = """
    Our Team. The developers behind this amazing app.
    Our Mission: We create high-quality, accessible applications that make daily tasks easier for everyone, with a special focus on inclusive design.
    Team members: Tofique, Lead Developer. The Team, Design & Development.
    Contact us: tofique@gmail.com.
    """;

    ScreenReaderHelper.readContent(content);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: widget.darkMode ? Color(0xff281537) : Color(0xff6a1b9a),
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    final backgroundColor = widget.darkMode ? Colors.black : Colors.grey[100]!;
    final primaryColor = widget.darkMode ? Color(0xff281537) : Color(0xff6a1b9a);
    final textColor = widget.darkMode ? Colors.white : Colors.black87;
    final cardColor = widget.darkMode ? Colors.grey[900]! : Colors.white;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("About Us", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: backgroundColor,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundColor: primaryColor.withOpacity(0.2),
                child: Icon(Icons.people_alt, size: 50, color: primaryColor),
              ),
              SizedBox(height: 30),
              Text(
                "Our Team",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "The developers behind this amazing app",
                style: TextStyle(
                  fontSize: 16,
                  color: textColor.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 30),
              Card(
                color: cardColor,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Our Mission",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "We create high-quality, accessible applications that make daily tasks easier for everyone, with a special focus on inclusive design.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              _buildTeamMember(
                name: "Tofique",
                role: "Lead Developer",
                color: primaryColor,
                textColor: textColor,
                cardColor: cardColor,
              ),
              SizedBox(height: 20),
              _buildTeamMember(
                name: "The Team",
                role: "Design & Development",
                color: primaryColor,
                textColor: textColor,
                cardColor: cardColor,
              ),
              SizedBox(height: 30),
              Text(
                "Contact us: tofique@gmail.com",
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
    required Color color,
    required Color textColor,
    required Color cardColor,
  }) {
    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(Icons.person, color: color),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}