import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'register_screen.dart';
import 'rounded_icon.dart';
import 'login_screen.dart';
import 'screen_reader_helper.dart';
import 'settings_provider.dart';

class WelcomeScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  WelcomeScreen({required this.cameras});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    // Read welcome message when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScreenReaderHelper.readContent(
          "Welcome to CashCognize. Please sign in or create an account. "
              "You can also login with social media accounts."
      );
    });

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xff387780),
                  Color(0xff281537),
                ]
            )
        ),
        child: Column(
            children: [
               Padding(
                padding: EdgeInsets.only(top: 120.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Semantics(
                      label: "CashCognize logo",
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        child: Image(
                          image: AssetImage('assets/logo6.png'),
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ),
                    Semantics(
                      label: "CashCognize",
                      child: Text(
                        'CashCognize',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
              Semantics(
                label: "Welcome Back",
                child: Text(
                  'Welcome Back',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Semantics(
                button: true,
                label: "Sign in button",
                child: GestureDetector(
                  onTap: (){
                    ScreenReaderHelper.stop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen(cameras: cameras)
                      ),
                    );
                  },
                  child: Container(
                    height: 53,
                    width: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white),
                    ),
                    child: const Center(
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Semantics(
                button: true,
                label: "Sign up button",
                child: GestureDetector(
                  onTap: (){
                    ScreenReaderHelper.stop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen(cameras: cameras)
                      ),
                    );
                  },
                  child: Container(
                    height: 53,
                    width: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white),
                    ),
                    child: const Center(
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
               Semantics(
                label: "Login with Social Media",
                child: Text(
                  'Login with Social Media',
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.white
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildSocialMediaButtons(context),
              const SizedBox(height: 8),
            ]
        ),
      ),
    );
  }

  Widget _buildSocialMediaButtons(BuildContext context) {
    return Semantics(
      label: "Social media login options",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Semantics(
            button: true,
            label: "Login with Facebook",
            child: GestureDetector(
              onTap: () {
                if (Provider.of<SettingsProvider>(context, listen: false).screenReaderEnabled) {
                  ScreenReaderHelper.readContent("Login with Facebook");
                }
                // Add your Facebook login logic here
              },
              child: const RoundedIcon(imageUrl: "assets/facebook.png"),
            ),
          ),
          const SizedBox(width: 12),
          Semantics(
            button: true,
            label: "Login with Twitter",
            child: GestureDetector(
              onTap: () {
                if (Provider.of<SettingsProvider>(context, listen: false).screenReaderEnabled) {
                  ScreenReaderHelper.readContent("Login with Twitter");
                }
                // Add your Twitter login logic here
              },
              child: const RoundedIcon(imageUrl: "assets/twitter.png"),
            ),
          ),
          const SizedBox(width: 12),
          Semantics(
            button: true,
            label: "Login with Google",
            child: GestureDetector(
              onTap: () {
                if (Provider.of<SettingsProvider>(context, listen: false).screenReaderEnabled) {
                  ScreenReaderHelper.readContent("Login with Google");
                }
                // Add your Google login logic here
              },
              child: const RoundedIcon(imageUrl: "assets/google.jpg"),
            ),
          ),
        ],
      ),
    );
  }
}