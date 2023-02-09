import 'package:artgen/views/main_detail_views/subscription_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
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
              // This is our Seearch bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    // Once user click the menu icon the menu shows like drawer
                    // Also we want to hide this menu icon on desktop
                    if (!Responsive.isDesktop(context))
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: kButtonLightPurple,
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                      ),
                    if (!Responsive.isDesktop(context)) SizedBox(width: 5),
                    // Expanded(
                    //   child: TextField(
                    //     onChanged: (value) {},
                    //     decoration: InputDecoration(
                    //       hintText: "Search",
                    //       fillColor: kBgLightColor,
                    //       filled: true,
                    //       suffixIcon: Padding(
                    //         padding: const EdgeInsets.all(
                    //             kDefaultPadding * 0.75), //15
                    //         child: WebsafeSvg.asset(
                    //           "assets/Icons/Search.svg",
                    //           width: 24,
                    //         ),
                    //       ),
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.all(Radius.circular(10)),
                    //         borderSide: BorderSide.none,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
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
                    Positioned(
                      top: MediaQuery.of(context).size.height / 8,
                      left: MediaQuery.of(context).size.width / 2 - 50,
                      child: Container(
                        width: 150,
                        height: 150,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(_avatarImage),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: kDefaultPadding * 10),
                          TextField(
                            decoration: InputDecoration(labelText: 'Name'),
                            onChanged: (value) {
                              setState(() {
                                _name = value;
                              });
                            },
                          ),
                          SizedBox(height: kDefaultPadding),
                          TextField(
                            decoration: InputDecoration(labelText: 'Surname'),
                            onChanged: (value) {
                              setState(() {
                                _surname = value;
                              });
                            },
                          ),
                          SizedBox(height: kDefaultPadding),
                          TextField(
                            decoration: InputDecoration(labelText: 'Email'),
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                              });
                            },
                          ),
                          SizedBox(height: 30.0),
                          Text(
                              'Total Images Generated: $_totalImagesGenerated'),
                          SizedBox(height: 30.0),
                          Text('Subscription Plan:'),
                          SizedBox(height: 30.0),
                          SizedBox(
                            height: 30.0,
                            width: 250,
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
                                backgroundColor: Colors.pink,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                              child: Text('Subscription Plans'),
                            ),
                          ),
                          SizedBox(height: kDefaultPadding),
                          SizedBox(
                            height: 30.0,
                            width: 250,
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
                                backgroundColor: Colors.pink,
                                foregroundColor: Colors.black,
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
