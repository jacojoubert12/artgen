import 'package:artgen/auth_gate.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:artgen/views/main_detail_views/subscription_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:universal_platform/universal_platform.dart';

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
  String _backgroundImage =
      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg';
  String _avatarImage =
      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg';
  String _name = '';
  String _surname = '';
  String _email = '';
  String _profileImg = '';
  int _totalImagesGenerated = 0;

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
      body: Container(
        padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
        color: kBgDarkColor,
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: <Widget>[
                    // Background image
                    Container(
                      height: 200,
                      width: double.maxFinite,
                      color: Color(0xFF),
                      child: Image.network(_backgroundImage, fit: BoxFit.cover),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: kDefaultPadding * 5),
                          TextField(
                            enabled: false,
                            style: TextStyle(
                              color: kTextColorLightGrey,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (value) {
                              _name = value;
                            },
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 10,
                                color: kTextColorLightGrey,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 155, 151, 151),
                                  width: 4.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: kButtonLightPurple,
                                  width: 4.0,
                                ),
                              ),
                              label: Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(
                                      child: Text(
                                        'Username',
                                        style: TextStyle(
                                          fontFamily: 'custom font',
                                          fontSize: 11.0,
                                          color: kTextColorLightGrey,
                                        ),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: Text(
                                        '',
                                        style: TextStyle(color: Colors.pink),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: kDefaultPadding),
                          TextField(
                            enabled: false,
                            style: TextStyle(
                              color: kTextColorLightGrey,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (value) {
                              _email = value;
                            },
                            cursorColor: Color.fromARGB(255, 77, 75, 75),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 10,
                                color: kTextColorLightGrey,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 77, 75, 75),
                                  width: 3.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: kButtonLightPurple,
                                  width: 1.0,
                                ),
                              ),
                              label: Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(
                                      child: Text(
                                        'Email',
                                        style: TextStyle(
                                          fontFamily: 'custom font',
                                          fontSize: 11.0,
                                          color: kTextColorLightGrey,
                                        ),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: Text(
                                        '',
                                        style: TextStyle(color: Colors.pink),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),
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
                                  "18+ Age must be verified on your Google account to enable some settings",
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
                          SizedBox(height: 30.0),
                          Text(
                            'Support Us',
                            style: TextStyle(
                              fontFamily:
                                  'custom font', // remove this if don't have custom font
                              fontSize: 17.0, // text size
                              color: kTextColorLightGrey,
                              // text color
                            ),
                          ),
                          SizedBox(),
                          Container(
                            padding:
                                EdgeInsets.symmetric(vertical: kDefaultPadding),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    //save profile
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SubscriptionView();
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.transparent,
                                    primary: Color.fromARGB(255, 181, 9, 130),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                  child: Text('Support Tier '),
                                ),
                                SizedBox(width: 10.0),
                                ElevatedButton(
                                  onPressed: () {
                                    //save profile
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SubscriptionView();
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.transparent,
                                    primary: Color.fromARGB(255, 181, 9, 130),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                  child: Text('Donate '),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: kDefaultPadding / 10),
                          Container(
                            height: 50,
                            width: 250,
                            decoration: BoxDecoration(
                              color: kButtonLightPurple,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (user.user?.isAnonymous ?? true) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AuthGate();
                                    },
                                  );
                                } else {
                                  _signOut();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                              child: (user.user?.isAnonymous ?? true)
                                  ? Text("Login")
                                  : Text("Logout"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
