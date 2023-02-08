import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:artgen/responsive.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

import '../constants.dart';
import '../extensions.dart';
import 'side_menu_item.dart';
import 'tags.dart';
// import 'dream_journal.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

// final ButtonStyle flatButtonStyle = TextButton.styleFrom(
//   primary: kPrimaryColor,
//   minimumSize: const Size(88, 36),
//   padding: EdgeInsets.symmetric(horizontal: 16.0),
//   shape: const RoundedRectangleBorder(
//     borderRadius: BorderRadius.all(Radius.circular(10)),
//   ),
// );

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key, this.setViewMode}) : super(key: key);

  final Function? setViewMode;
  // String _name = '';
  // String _surname = '';

  // Future _getDataFromDatabase() async {
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get()
  //       .then((snapshot) async {
  //     if (snapshot.exists) {
  //       setState(() {
  //         _name = snapshot.data()!["_name"];
  //         _surname = snapshot.data()!["_surname"];
  //         // _email = snapshot.data()!["_email"];
  //         // snapshot.data()!["_profileImg"];
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      // padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
      color: kBgDarkColor,
      child: SafeArea(
        child: SingleChildScrollView(
          // padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              Image.asset(
                "assets/images/flower.png",
                // width: 46,
                fit: BoxFit.fill,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: kDefaultPadding * 6),
                  // Avatar Image
                  Positioned(
                    // top: MediaQuery.of(context).size.height / 8,
                    // left: MediaQuery.of(context).size.width / 2 - 50,
                    child: Container(
                      width: 100,
                      height: 100,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg'),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "User Name",
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 20.0, // text size
                  color: Color.fromARGB(255, 255, 255, 255), // text color
                ),
              ),
              Text(
                "User Plan",
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 10.0, // text size
                  color: Color.fromARGB(255, 255, 255, 255), // text color
                ),
              ),
              // Menu Items
              SideMenuItem(
                press: () {
                  this.setViewMode!(ViewMode.create);
                },
                title: "Create",
                icon: Icon(
                  Icons.create,
                  color: kSideMenuIconsColor,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.setViewMode!(ViewMode.mygallary);
                },
                title: "My Gallary",
                icon: Icon(
                  Icons.collections,
                  color: kSideMenuIconsColor,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.setViewMode!(ViewMode.explore);
                },
                title: "Explore",
                icon: Icon(
                  Icons.explore,
                  color: kSideMenuIconsColor,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.setViewMode!(ViewMode.likes);
                },
                title: "Likes",
                icon: Icon(
                  Icons.favorite,
                  color: kSideMenuIconsColor,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.setViewMode!(ViewMode.profile);
                },
                title: "Profile",
                icon: Icon(
                  Icons.face,
                  color: kSideMenuIconsColor,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.setViewMode!(ViewMode.about);
                },
                title: "About",
                icon: Icon(
                  Icons.fingerprint,
                  color: kSideMenuIconsColor,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  Share.share('check out my website https://google.com');
                },
                title: "Share",
                icon: Icon(
                  Icons.share,
                  color: kSideMenuIconsColor,
                ),
                isActive: false,
                showBorder: true,
              ),

              SizedBox(height: kDefaultPadding),
              SignOutButton(),
              SizedBox(height: kDefaultPadding),

              // SizedBox(height: kDefaultPadding * 2),
              // Tags
              // Tags(),
              // Text(
              //   "ART GEN Powerd By Enginosoft",
              //   style: TextStyle(
              //     fontFamily:
              //         'custom font', // remove this if don't have custom font
              //     fontSize: 10.0, // text size
              //     color: Colors.black, // text color
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
