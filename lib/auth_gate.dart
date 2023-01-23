import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:artgen/models/firestore_manager.dart';
// import 'package:influxdb_client/api.dart';

User user;

class AuthGate extends StatelessWidget {
  const AuthGate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
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
