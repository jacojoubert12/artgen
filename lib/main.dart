import 'package:flutter/material.dart';
import 'package:artgen/auth_gate.dart';
import 'package:artgen/constants.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:artgen/views/Welcome/welcome_screen.dart';
import 'package:artgen/components/my_input_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'firebase_options.dart';

// void main() {
//   runApp(MyApp());
// }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // Future<InitializationStatus> _initGoogleMobileAds() {
  //   // TODO: Initialize Google Mobile Ads SDK
  //   return MobileAds.instance.initialize();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ArtGen.fun',
      theme: ThemeData(
        inputDecorationTheme: MyInputTheme().theme(),
      ),
      // home: WelcomeScreen(),
      // home: HomeScreen(),
      // home: MainScreen(),
      home: HomeScreen(),
      // home: AuthGate(),
    );
  }
}
