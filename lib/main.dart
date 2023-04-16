import 'package:universal_platform/universal_platform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:artgen/auth_gate.dart';
import 'package:artgen/constants.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:artgen/views/Welcome/welcome_screen.dart';
import 'package:artgen/components/my_input_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb && (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)) {
    await MobileAds.instance.initialize();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ArtGen.fun',
      theme: ThemeData(
        inputDecorationTheme: MyInputTheme().theme(),
      ),
      home: HomeScreen(),
    );
  }
}
