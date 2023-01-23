import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:artgen/responsive.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

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
  const SideMenu({Key key, this.setViewMode}) : super(key: key);

  final Function setViewMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
      color: kBgLightColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/monkey.jpg",
                    width: 46,
                  ),
                  Spacer(),
                  // We don't want to show this close button on Desktop mood
                  if (!Responsive.isDesktop(context)) CloseButton(),
                ],
              ),
              // Menu Items

              SideMenuItem(
                press: () {
                  this.setViewMode(ViewMode.create);
                },
                title: "Create",
                icon: Icon(
                  Icons.create,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.setViewMode(ViewMode.mygallary);
                },
                title: "My Gallary",
                // iconSrc: "assets/Icons/create_black_24dp.svg",
                icon: Icon(
                  Icons.collections,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.setViewMode(ViewMode.explore);
                },
                title: "Explore",
                icon: Icon(
                  Icons.explore,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.setViewMode(ViewMode.likes);
                },
                title: "Likes",
                icon: Icon(
                  Icons.favorite,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.setViewMode(ViewMode.profile);
                },
                title: "Profile",
                icon: Icon(
                  Icons.face,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.setViewMode(ViewMode.about);
                },
                title: "About",
                icon: Icon(
                  Icons.fingerprint,
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
            ],
          ),
        ),
      ),
    );
  }
}
