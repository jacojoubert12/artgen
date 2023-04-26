import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class AuthGate extends StatefulWidget {
  AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.isAnonymous) {
      Navigator.pop(context);
    }
  }

  getAgeInfo() async {
    final uri = Uri.parse(
        'https://people.googleapis.com/v1/people/me?personFields=birthdays&access_token=${user.accessToken}');
    final response = await http.get(uri);

    final jsonData = json.decode(response.body);
    print("jsonData:");
    print(jsonData);

    if (jsonData['birthdays'] != null) {
      DateTime lastDateOfBirth = DateTime.now();
      bool yearPresent = false;

      // Iterate through the birthdays list and find the last date with a 'year' field
      for (final birthday in jsonData['birthdays']) {
        if (birthday['date'] != null && birthday['date']['year'] != null) {
          yearPresent = true;
          lastDateOfBirth = DateTime(
            birthday['date']['year'],
            birthday['date']['month'],
            birthday['date']['day'],
          );
        }
      }

      if (lastDateOfBirth != null && yearPresent) {
        print("Last dateOfBirth");
        print(lastDateOfBirth);

        final age = DateTime.now().difference(lastDateOfBirth).inDays ~/ 365;
        print("Age: $age");
        user.age = age;
      } else if (!yearPresent) {
        print("Year not present in any birthday");
      } else {
        print("No birthdays found in the response");
      }
    } else {
      print("No birthdays found in the response");
    }
  }

  setUserInfo(User currentUser) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        documentSnapshot.reference.set({'package': 1, 'age': user.age});
      }
    });
  }

  Future<void> _signInWithGoogle() async {
    GoogleSignIn googleSignIn;
    try {
      if (!UniversalPlatform.isAndroid && !UniversalPlatform.isIOS) {
        googleSignIn = GoogleSignIn(
            clientId:
                "133553272540-4ogfuqk8arc28p49c3ors56pvhhs35ih.apps.googleusercontent.com",
            scopes: ['https://www.googleapis.com/auth/user.birthday.read']);
        ;
      } else {
        googleSignIn = GoogleSignIn(
            scopes: ['https://www.googleapis.com/auth/user.birthday.read']);
      }
      final googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final currentUser = authResult.user;

        print(authResult);
        final accessToken = authResult.credential?.accessToken;
        print("accessToken");
        print(accessToken);
        user.accessToken = accessToken!;
        await getAgeInfo();

        if (currentUser != null) {
          setUserInfo(currentUser);
          setState(() {
            user.user = currentUser;
          });
          Navigator.pop(context);
        }
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome to ArtGen.fun',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              SignInButton(
                Buttons.google,
                onPressed: () {
                  _signInWithGoogle();
                },
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Replace the URL with your privacy policy link
                  launchUrl(
                      'https://docs.google.com/document/d/17KdTKpDdhprAPpvhMeRsL6rp7OQuXBtUfsC0vWkdGVU/edit?usp=share_link'
                          as Uri);
                },
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
