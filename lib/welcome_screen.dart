import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'package:camera/camera.dart';
import 'rounded_icon.dart';
import 'login_screen.dart';


class WelcomeScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  WelcomeScreen({required this.cameras});


  @override
  Widget build(BuildContext context) {
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
              const Padding(
                padding: const EdgeInsets.only(top: 120.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.white, // Desired color
                        BlendMode.srcIn, // Blend mode
                      ),
                      child: Image(
                        image: AssetImage('assets/logo6.png'),
                        height: 80, // Adjust the height
                        width: 80,  // Adjust the width
                      ),
                    ),

                    Text(
                      'CashCognize',
                      style: TextStyle(
                        fontSize: 25, // Adjust the font size
                        color: Colors.white, // Customize the text color
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 100,
              ),
              const Text('Welcome Back',style: TextStyle(
                  fontSize: 30,
                  color: Colors.white
              ),),
              const SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen(cameras: cameras)));
                },
                child: Container(
                  height: 53,
                  width: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white),
                  ),
                  child: const Center(child: Text('SIGN IN',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),),
                ),
              ),
              const SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterScreen(cameras: cameras)));
                },
                child: Container(
                  height: 53,
                  width: 320,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white),
                  ),
                  child: const Center(child: Text('SIGN UP',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),),),
                ),
              ),
              const Spacer(),
              const Text('Login with Social Media',style: TextStyle(
                  fontSize: 17,
                  color: Colors.white
              ),),//
              const SizedBox(height: 12,),
              iconButton(context),
              const SizedBox(height: 8,),
            ]
        ),
      ),

    );
  }
}

iconButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      RoundedIcon(imageUrl: "assets/facebook.png"),
      SizedBox(
        width: 12,
      ),
      RoundedIcon(imageUrl: "assets/twitter.png"),
      SizedBox(
        width: 12,
      ),
      RoundedIcon(imageUrl: "assets/google.jpg"),
    ],
  );
}
