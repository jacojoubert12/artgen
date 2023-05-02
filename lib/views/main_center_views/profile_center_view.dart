import 'package:artgen/auth_gate.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:artgen/views/main_detail_views/subscription_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ProfileCenterView extends StatefulWidget {
  const ProfileCenterView({
    Key? key,
    this.setViewMode,
  }) : super(key: key);
  final Function? setViewMode;

  @override
  _ProfileCenterViewState createState() => _ProfileCenterViewState();
}

class _ProfileCenterViewState extends State<ProfileCenterView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _backgroundImage = 'https://ws.artgen.fun/images/icon.png';
  String _avatarImage = 'https://ws.artgen.fun/images/icon.png';
  String _name = '';
  String _surname = '';
  String _email = '';
  String _profileImg = '';
  int _totalImagesGenerated = 0;
  String bannerImage = '';

  //TODO Move to my_user - get some structure on when to get data and where to store it
  Future _getDataFromDatabase() async {
    if (user.user?.photoURL != null) {
      setState(() {
        _avatarImage = user.user!.photoURL!;
      });
    }
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          _name = snapshot.data()!["_name"];
          _surname = snapshot.data()!["_surname"];
          _email = snapshot.data()!["_email"];
          // snapshot.data()!["_profileImg"];
        });
      }
    });
  }

  Future<void> _signOut() async {
    try {
      GoogleSignIn googleSignIn;
      if (!UniversalPlatform.isAndroid && !UniversalPlatform.isIOS) {
        googleSignIn = GoogleSignIn(
            clientId:
                "133553272540-4ogfuqk8arc28p49c3ors56pvhhs35ih.apps.googleusercontent.com");
      } else {
        googleSignIn = GoogleSignIn();
      }

      // Sign out from Google
      await googleSignIn.signOut();

      // Sign out from Firebase Auth
      await FirebaseAuth.instance.signOut();

      // Set user.user to null
      setState(() {
        user.user = null;
      });
    } catch (error) {
      print("Error signing out: $error");
    }
    user.shouldLogin = true;
  }

  @override
  void initState() {
    // _getDataFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
              title: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 35,
                      alignment: Alignment.center,
                      child: Text(
                        "My Profile",
                        style: TextStyle(
                          fontFamily:
                              'custom font', // remove this if don't have custom font
                          fontSize: 20.0, // text size
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      width: 45,
                      height: 45,
                      child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              user.user?.photoURL ?? _avatarImage)),
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
              backgroundColor: kButtonLightPurple,
            )
          : null,
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(setViewMode: widget.setViewMode),
      ),
      body: Column(
        children: [
          Container(
            height: Responsive.isDesktop(context) ? 200 + kDefaultPadding : 100,
            width: double.maxFinite,
            color: Color.fromARGB(0, 0, 0, 0),
            child: Image(
              image: AssetImage('assets/images/banner.png'),
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
              color: kBgDarkColor,
              child: SafeArea(
                right: false,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              user.user?.photoURL ?? _avatarImage,
                            ),
                          ),
                          SizedBox(height: kDefaultPadding),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Text(
                              //   "User:  ",
                              //   style: TextStyle(
                              //     fontFamily:
                              //         'custom font', // remove this if don't have custom font
                              //     fontSize: 20.0, // text size
                              //     color: kTextColorLightGrey, // text color
                              //   ),
                              //   textAlign: TextAlign.center,
                              // ),
                              // SizedBox(height: kDefaultPadding),
                              Text(
                                user.user?.displayName ?? "Please Login",
                                style: TextStyle(
                                  fontFamily:
                                      'custom font', // remove this if don't have custom font
                                  fontSize: 15.0, // text size
                                  color: kTextColorLightGrey, // text color
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(height: kDefaultPadding / 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //   Text(
                              //     "Email:  ",
                              //     style: TextStyle(
                              //       fontFamily:
                              //           'custom font', // remove this if don't have custom font
                              //       fontSize: 20.0, // text size
                              //       color: kTextColorLightGrey, // text color
                              //     ),
                              //     textAlign: TextAlign.center,
                              //   ),
                              //   SizedBox(height: kDefaultPadding),
                              Text(
                                user.user?.email ?? "Please Login",
                                style: TextStyle(
                                  fontFamily:
                                      'custom font', // remove this if don't have custom font
                                  fontSize: 15.0, // text size
                                  color: kTextColorLightGrey, // text color
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(height: kDefaultPadding),
                          user.age >= 18
                              ? Text(
                                  "Safe <-- Filter NSFW --> Unsafe",
                                  style: TextStyle(
                                    fontFamily:
                                        'custom font', // remove this if don't have custom font
                                    fontSize: 12.0, // text size
                                    color: kTextColorLightGrey,
                                    // text color
                                  ),
                                )
                              : Text(
                                  "18+ Age must be verified on your Google account to enable some settings\n If already logged in, please logout and login again to enable these settings.",
                                  style: TextStyle(
                                    fontFamily:
                                        'custom font', // remove this if don't have custom font
                                    fontSize: 12.0, // text size
                                    color: kTextColorLightGrey,
                                    // text color
                                  ),
                                ),
                          user.age >= 18
                              ? SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackShape: RoundedRectSliderTrackShape(),
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 12.0),
                                    overlayShape: RoundSliderOverlayShape(
                                        overlayRadius: 28.0),
                                  ),
                                  child: Container(
                                    width: kDefaultWidth * 35,
                                    child: Slider(
                                      value: user.nsfwFilterSliderValue,
                                      max: 1,
                                      min: 0,
                                      divisions: 101,
                                      label: user.nsfwFilterSliderValue
                                          .toStringAsFixed(2),
                                      activeColor:
                                          kButtonLightPurple, // Set the active color here
                                      inactiveColor:
                                          kButtonLightPurpleTransparent,
                                      onChanged: (double value) {
                                        setState(() {
                                          user.nsfwFilterSliderValue = value;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              : Text(''),
                          // SizedBox(height: kDefaultPadding),
                          Text(
                            'Support Us',
                            style: TextStyle(
                              fontFamily:
                                  'custom font', // remove this if don't have custom font
                              fontSize: 20.0, // text size
                              color: kTextColorLightGrey,
                              // text color
                            ),
                          ),
                          UniversalPlatform.isAndroid || UniversalPlatform.isIOS
                              ? Text(
                                  '\nPlease consider supporting us by subscribing or donating.',
                                  style: TextStyle(
                                    fontFamily:
                                        'custom font', // remove this if don't have custom font
                                    fontSize: 12.0, // text size
                                    color: kTextColorLightGrey,
                                    // text color
                                  ),
                                )
                              : Text(
                                  '\nPlease consider supporting us by downloading the ArtGen App and subscribing or donating.',
                                  style: TextStyle(
                                    fontFamily:
                                        'custom font', // remove this if don't have custom font
                                    fontSize: 12.0, // text size
                                    color: kTextColorLightGrey,
                                    // text color
                                  ),
                                ),
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          !UniversalPlatform.isAndroid &&
                                  !UniversalPlatform.isIOS
                              ? InkWell(
                                  onTap: () async {
                                    launchUrl(
                                        'https://play.google.com/store/apps/details?id=com.enginosoft.artgen'
                                            as Uri);
                                  },
                                  child: Container(
                                    height: 100,
                                    child: Image(
                                        image: AssetImage('images/play.png')),
                                  ),
                                )
                              : Text(''),
                          Container(
                            padding:
                                EdgeInsets.symmetric(vertical: kDefaultPadding),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    UniversalPlatform.isAndroid ||
                                            UniversalPlatform.isIOS
                                        ? showDialog(
                                            context: context,
                                            builder: (context) {
                                              return SubscriptionView();
                                            },
                                          )
                                        : launchUrl(
                                            'https://play.google.com/store/apps/details?id=com.enginosoft.artgen'
                                                as Uri);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.transparent,
                                    primary: Color(0xFF58A408),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                  ),
                                  child: Text('Subscribe'),
                                ),
                                SizedBox(width: 10.0),
                                ElevatedButton(
                                  onPressed: () async {
                                    UniversalPlatform.isAndroid ||
                                            UniversalPlatform.isIOS
                                        ? showDialog(
                                            context: context,
                                            builder: (context) {
                                              return SubscriptionView();
                                            },
                                          )
                                        : launchUrl(
                                            'https://play.google.com/store/apps/details?id=com.enginosoft.artgen'
                                                as Uri);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.transparent,
                                    primary: Color(0xFF58A408),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                  ),
                                  child: Text('  Donate  '),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: kDefaultPadding / 10),
                          Container(
                            // height: kDefaultHeight,
                            // width: 100,
                            decoration: BoxDecoration(
                              color: kButtonLightPurple,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (user.user?.isAnonymous ?? true) {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AuthGate();
                                    },
                                  );
                                } else {
                                  _signOut();
                                }
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                              ),
                              child: (user.user?.isAnonymous ?? true)
                                  ? Text("  Login  ")
                                  : Text("  Logout  "),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
