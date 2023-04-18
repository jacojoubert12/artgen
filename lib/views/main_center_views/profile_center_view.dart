import 'dart:convert';

import 'package:artgen/views/main/main_view.dart';
import 'package:artgen/views/main_detail_views/subscription_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    getAgeInfo();
    _getDataFromDatabase();
    super.initState();
  }

  getAgeInfo() async {
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final uri = Uri.parse(
        'https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=$token');
    final response = await http.get(uri);

    final jsonData = json.decode(response.body);
    final dateOfBirth = jsonData['birthday'];

    user.age = DateTime.now().difference(dateOfBirth).inDays ~/ 365;
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
                  // if (Responsive.isDesktop(context))
                  // Container(
                  //   child: Container(
                  //     margin: EdgeInsets.only(left: 20),
                  //     width: 45,
                  //     height: 45,
                  //     child: CircleAvatar(
                  //         backgroundImage: NetworkImage(_avatarImage)),
                  //   ),
                  // ),
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

      // key: _scaffoldKey,
      // drawer: ConstrainedBox(
      //   constraints: BoxConstraints(maxWidth: 250),
      //   child: SideMenu(setViewMode: widget.setViewMode),
      // ),
      body: Container(
        padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
        color: kBgDarkColor,
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              // This is our Seearch bar
              // Padding(
              // padding:
              //     const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              // child: Row(
              //   children: [
              //     // Once user click the menu icon the menu shows like drawer
              //     // Also we want to hide this menu icon on desktop
              //     if (!Responsive.isDesktop(context))
              //       IconButton(
              //         icon: Icon(
              //           Icons.menu,
              //           color: kButtonLightPurple,
              //         ),
              //         onPressed: () {
              //           _scaffoldKey.currentState!.openDrawer();
              //         },
              //       ),
              //     if (!Responsive.isDesktop(context)) SizedBox(width: 5),
              //     // Expanded(
              //     //   child: TextField(
              //     //     onChanged: (value) {},
              //     //     decoration: InputDecoration(
              //     //       hintText: "Search",
              //     //       fillColor: kBgLightColor,
              //     //       filled: true,
              //     //       suffixIcon: Padding(
              //     //         padding: const EdgeInsets.all(
              //     //             kDefaultPadding * 0.75), //15
              //     //         child: WebsafeSvg.asset(
              //     //           "assets/Icons/Search.svg",
              //     //           width: 24,
              //     //         ),
              //     //       ),
              //     //       border: OutlineInputBorder(
              //     //         borderRadius: BorderRadius.all(Radius.circular(10)),
              //     //         borderSide: BorderSide.none,
              //     //       ),
              //     //     ),
              //     //   ),
              //     // ),
              //   ],
              // ),
              // ),
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

                    // Avatar Image
                    // Positioned(
                    //   top: MediaQuery.of(context).size.height / 8,
                    //   left: MediaQuery.of(context).size.width / 2 - 50,
                    //   child: Container(
                    //     width: 150,
                    //     height: 150,
                    //     child: CircleAvatar(
                    //       backgroundImage: NetworkImage(_avatarImage),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: kDefaultPadding * 10),
                          // TextField(
                          //   decoration: InputDecoration(labelText: 'Username'),
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _name = value;
                          //     });
                          //   },
                          // ),
                          TextField(
                            style: TextStyle(
                              color: kTextColorLightGrey,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (value) {
                              _name = value;
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
                                  width: 1.0,
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
                          // SizedBox(height: kDefaultPadding),
                          // TextField(
                          //   decoration: InputDecoration(labelText: 'Surname'),
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _surname = value;
                          //     });
                          //   },
                          // ),
                          SizedBox(height: kDefaultPadding),
                          TextField(
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
                                  width: 1.0,
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
                          // TextField(
                          //   decoration: InputDecoration(labelText: 'Email'),
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _email = value;
                          //     });
                          //   },
                          // ),
                          SizedBox(height: 30.0),
                          user.age >= 18
                              ? Text(
                                  "NSFW Filter",
                                  style: TextStyle(
                                    fontFamily:
                                        'custom font', // remove this if don't have custom font
                                    fontSize: 12.0, // text size
                                    color: kTextColorLightGrey,
                                    // text color
                                  ),
                                )
                              : Text(""),
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
                            'Subscription Plan:',
                            style: TextStyle(
                              fontFamily:
                                  'custom font', // remove this if don't have custom font
                              fontSize: 12.0, // text size
                              color: kTextColorLightGrey,
                              // text color
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              color: kButtonLightPurple,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
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
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                              child: Text('Subscription Plans'),
                            ),
                          ),
                          SizedBox(height: kDefaultPadding),
                          Container(
                            height: 50,
                            width: 250,
                            decoration: BoxDecoration(
                              color: kButtonLightPurple,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                //save profile
                                // showDialog(
                                //   context: context,
                                //   builder: (context) {
                                //     return SubscriptionView();
                                //   },
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                              child: Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: kDefaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
