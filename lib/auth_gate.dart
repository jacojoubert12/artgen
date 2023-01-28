import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:artgen/models/firestore_manager.dart';
// import 'package:influxdb_client/api.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

User? user;

Future<String> getData(String key) async {
  if (kIsWeb) {
    return html.window.localStorage[key];
  } else {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  Future<void> storeData(String key, String value) async {
    if (kIsWeb) {
      html.window.localStorage[key] = value;
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(key, value);
    }
  }

  void login() {
    uid = user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Sign in anonymously
      FirebaseAuth.instance.signInAnonymously().then((userCredentials) {
        user = userCredentials.user;
        // user?.uid;
        // userCredentials.user?.uid;
        // Check if certain condition is met
        // if (conditionMet) {
        // Prompt user to sign in for real
        // FirebaseAuth.instance.signOut();
        // Show sign-in dialog
        // }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    login();
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SignInScreen(providerConfigs: [
              EmailProviderConfiguration(),
              FacebookProviderConfiguration(clientId: "297726269218671"),
              GoogleProviderConfiguration(
                  clientId:
                      "596167850151-2lhh2fviql4dkl1jisngt57plikc03qv.apps.googleusercontent.com")
            ]);
          }
          user = snapshot.data;

          return HomeScreen();
        });
  }
}
