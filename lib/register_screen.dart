import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:camera/camera.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screen_reader_helper.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';

class RegisterScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  RegisterScreen({required this.cameras});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _readWelcomeMessage();
    });
  }

  void _readWelcomeMessage() {
    final content = """
    Welcome to CashCognize registration. 
    Please fill in your details to create an account.
    You'll need to provide your full name, email address, and create a password.
    """;

    ScreenReaderHelper.readContent(content);
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Update user profile with display name
        await userCredential.user!.updateProfile(displayName: _nameController.text.trim());
        await userCredential.user!.reload();

        // Stop reading before navigation
        await ScreenReaderHelper.stop();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(cameras: widget.cameras),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${e.toString()}')),
        );
        ScreenReaderHelper.readContent("Registration failed. ${e.toString()}");
      }
    }
  }

  @override
  void dispose() {
    ScreenReaderHelper.stop();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff387780),
                  Color(0xff281537),
                ],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Create Your\nAccount',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Form container
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 45),
                        // Name field
                        Semantics(
                          label: "Full name input field",
                          child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: "Full Name",
                              prefixIcon: Icon(Icons.person, color: Color(0xff387780)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            onTap: () {
                              if (settingsProvider.screenReaderEnabled) {
                                ScreenReaderHelper.readContent("Full name input field");
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Email field
                        Semantics(
                          label: "Email input field",
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: "Email",
                              prefixIcon: Icon(Icons.email, color: Color(0xff387780)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onTap: () {
                              if (settingsProvider.screenReaderEnabled) {
                                ScreenReaderHelper.readContent("Email input field");
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Password field
                        Semantics(
                          label: "Password input field",
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xff387780),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                  if (settingsProvider.screenReaderEnabled) {
                                    ScreenReaderHelper.readContent(
                                        _isPasswordVisible
                                            ? "Password visible"
                                            : "Password hidden"
                                    );
                                  }
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            onTap: () {
                              if (settingsProvider.screenReaderEnabled) {
                                ScreenReaderHelper.readContent("Password input field, minimum 6 characters");
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Confirm Password field
                        Semantics(
                          label: "Confirm password input field",
                          child: TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_isConfirmPasswordVisible,
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xff387780),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                  if (settingsProvider.screenReaderEnabled) {
                                    ScreenReaderHelper.readContent(
                                        _isConfirmPasswordVisible
                                            ? "Confirm password visible"
                                            : "Confirm password hidden"
                                    );
                                  }
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            onTap: () {
                              if (settingsProvider.screenReaderEnabled) {
                                ScreenReaderHelper.readContent("Confirm password input field");
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 80),
                        // Sign Up Button
                        Semantics(
                          button: true,
                          label: "Sign up button",
                          child: Center(
                            child: GestureDetector(
                              onTap: _register,
                              child: Container(
                                height: 55,
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xff387780),
                                      Color(0xff281537),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 110),
                        // Already have an account
                        Semantics(
                          label: "Already have an account? Sign in",
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    ScreenReaderHelper.stop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(cameras: widget.cameras),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}