import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:artgen/views/main/main_view.dart';

class AuthGate extends StatefulWidget {
  AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // user.initMyUser();
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
          user.user = snapshot.data;
          // user.initMyUser(); //HomeScreen() does this... consider adding it back if below TODO is done
          return HomeScreen(); //TODO: Pass in where to return to
        });
  }
}
