import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:url_launcher/url_launcher.dart';

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
    if (user != null) {
      Navigator.pop(context);
    }
  }

  Future<void> _signInWithGoogle() async {
    GoogleSignIn googleSignIn;
    try {
      if (!UniversalPlatform.isAndroid && !UniversalPlatform.isIOS) {
        googleSignIn = GoogleSignIn(
            clientId:
                "133553272540-4ogfuqk8arc28p49c3ors56pvhhs35ih.apps.googleusercontent.com");
      } else {
        googleSignIn = GoogleSignIn();
      }
      // final googleSignIn = GoogleSignIn();
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

        if (currentUser != null) {
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
                      'https://docs.google.com/document/d/17KdTKpDdhprAPpvhMeRsL6rp7OQuXBtUfsC0vWkdGVU/edit?usp=sharing'
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
