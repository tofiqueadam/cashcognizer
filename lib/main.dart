import 'package:CashCognize/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_screen.dart';
import 'screen_reader_helper.dart';
import 'settings_provider.dart';
import 'welcome_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ScreenReaderHelper.init(); // Initialize screen reader

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  final cameras = await availableCameras();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MyApp(cameras: cameras),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  MyApp({required this.cameras});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      navigatorKey: ScreenReaderHelper.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Cash Cognify',
      theme: ThemeData.light().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: Color(0xff6a1b9a),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: Color(0xff6a1b9a),
        ),
      ),
      themeMode: settingsProvider.darkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(cameras: cameras), // Initial route set to WelcomeScreen
      routes: {
        '/home': (context) => HomeScreen(cameras: cameras),
        '/register': (context) => RegisterScreen(cameras: cameras),
      },
    );
  }
}
