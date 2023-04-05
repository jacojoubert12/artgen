import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:artgen/responsive.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:url_launcher/url_launcher.dart';

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

class SideMenu extends StatefulWidget {
  SideMenu({Key? key, this.setViewMode}) : super(key: key);

  final Function? setViewMode;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String userName = 'Welcome';
  String bannerImage = '';

  // String _surname = '';
  // setUserDetalails() async {
  //   // setState(() async {
  //   //   bannerImage = await rootBundle.loadString("assets/images/flower.png");
  //   //   print("bannerImage?????????????");
  //   //   print(bannerImage);
  //   // });
  //   while (user.user == null) {
  //     // Wait until user is not null
  //     await Future.delayed(Duration(milliseconds: 500));
  //     print("user still null");
  //   }
  //   setState(() {
  //     userName = user.user!.displayName!;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setUserDetalails();
  }

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
              Container(
                width: double.maxFinite,
                color: Color(0xFF),
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/flower.png'),
                  image: AssetImage('assets/images/flower.png'),
                ),
                // child: Image.network(bannerImage, fit: BoxFit.fitWidth),
              ),
              // Positioned(
              //   top: MediaQuery.of(context).size.height / 2,
              //   left: MediaQuery.of(context).size.width / 2 - 50,
              //   child: Container(
              //     width: 80,
              //     height: 80,
              //     child: CircleAvatar(
              //       // backgroundImage: NetworkImage(_avatarImage),
              //       child: Image.network("assets/images/flower.png"),
              //     ),
              //   ),
              // ),
              SizedBox(height: kDefaultPadding),
              Text(
                userName,
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
                  this.widget.setViewMode!(ViewMode.create);
                  // setUserDetalails();
                },
                title: "Create",
                icon: Icon(
                  Icons.create,
                  color: kButtonLightPurple,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.widget.setViewMode!(ViewMode.mygallery);
                  // setUserDetalails();
                },
                title: "My Gallery",
                icon: Icon(
                  Icons.collections,
                  color: kButtonLightPurple,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.widget.setViewMode!(ViewMode.explore);
                  // setUserDetalails();
                },
                title: "Explore",
                icon: Icon(
                  Icons.explore,
                  color: kButtonLightPurple,
                ),
                isActive: false,
                showBorder: true,
              ),
              // SideMenuItem(
              //   press: () {
              //     this.widget.setViewMode!(ViewMode.likes);
              //   },
              //   title: "Likes",
              //   icon: Icon(
              //     Icons.favorite,
              //     color: kButtonLightPurple,
              //   ),
              //   isActive: false,
              //   showBorder: true,
              // ),
              SideMenuItem(
                press: () {
                  print(ViewMode.profile);
                  this.widget.setViewMode!(ViewMode.profile);
                },
                title: "Profile",
                icon: Icon(
                  Icons.face,
                  color: kButtonLightPurple,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.widget.setViewMode!(ViewMode.about);
                },
                title: "About",
                icon: Icon(
                  Icons.fingerprint,
                  color: kButtonLightPurple,
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
                  color: kButtonLightPurple,
                ),
                isActive: false,
                showBorder: true,
              ),
              SizedBox(height: 5),
              InkWell(
                onTap: () => launchUrl(Uri.parse('https://www.google.com')),
                child: Text(
                  'Terms and Conditions',
                  style: TextStyle(
                      decoration: TextDecoration.underline, color: Colors.blue),
                ),
              ),
              SizedBox(height: 5),
              InkWell(
                onTap: () => launchUrl(Uri.parse('https://www.google.com')),
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                      decoration: TextDecoration.underline, color: Colors.blue),
                ),
              ),

              SizedBox(height: 5),
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
